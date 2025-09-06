import { ConflictException, Injectable, Inject, forwardRef, NotFoundException } from '@nestjs/common';
import { CreateOrderDto } from './dto/create-order.dto';
import { Order } from './entities/order.entity';
import { OrderItem } from './entities/order_item.entity';
import { TablesService } from 'src/tables/tables.service';
import { ArticleService } from 'src/article/article.service';
import { UUID } from 'crypto';
import { OrderStatus } from 'src/enums/order_status';
import { Article } from 'src/article/entities/article.entity';
import { TableStatus } from 'src/enums/table_status';
import { LoggedUser } from 'src/auth/strategy/loggeduser';
import { UsersService } from 'src/users/users.service';
import { HistoryService } from 'src/history/history.service';
import { RepositoryFactory } from 'src/database/repository-factory.service';

@Injectable()
export class OrderService {
    constructor(
        private readonly repositoryFactory: RepositoryFactory,
        @Inject(forwardRef(() => TablesService))
        private readonly tablesService: TablesService,
        private readonly articleService: ArticleService,
        private readonly usersService: UsersService,
        private readonly historyService: HistoryService,
    ) { }

    async passOrder(
        createOrderDto: CreateOrderDto,
        user: LoggedUser,
        dbName: string,
    ) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const orderItemRepo = await this.repositoryFactory.getRepository(dbName, OrderItem);
        const openedBy = await this.usersService.findStaffById(user.id, dbName);
        const table = await this.tablesService.findOne(createOrderDto.tableId, dbName);
        if (openedBy.building.tableMultiOrder == false) {
            const orderTable = await this.checkTableHaveOrder(createOrderDto.tableId, dbName);
            if (orderTable) {
                throw new ConflictException(`this table ${table.name} already have an order`);
            }
        }
        const articles: Article[] = [];
        for (const articleId of createOrderDto.articlesIds) {
            const article = await this.articleService.findOne(articleId, dbName);
            articles.push(article);
        }

        const orderItems = await orderItemRepo.create(articles.map((article) => {
            const orderItem = new OrderItem();
            orderItem.article = article;
            orderItem.payed = false;
            orderItem.passedBy = openedBy;
            return orderItem;
        }));

        const uniqueNumber = Math.floor(1000 + Math.random() * 9000);
        const order = orderRepo.create({
            table,
            ref: `REF-${uniqueNumber}`,
            items: orderItems,
            status: OrderStatus.PROGRESS,
            openedBy
        });

        const savedOrder = await orderRepo.save(order);
        savedOrder.table.status = TableStatus.occupied;
        return savedOrder;
    }
    async addItemsToOrder(orderId: UUID, articleIds: UUID[], dbName: string, user: LoggedUser) {
        const order = await this.getOrderById(orderId, dbName);
        if (order.status === OrderStatus.PAYED) {
            throw new ConflictException(`Order with ID ${orderId} is already paid and cannot be modified.`);
        }
        const articles: Article[] = [];
        for (const articleId of articleIds) {
            const article = await this.articleService.findOne(articleId, dbName);
            articles.push(article);
        }
        const orderItemRepo = await this.repositoryFactory.getRepository(dbName, OrderItem);
        const orderItems = await Promise.all(articles.map(async (article) => {
            const orderItem = orderItemRepo.create({
                article,
                order,
                payed: false,
                passedBy: await this.usersService.findStaffById(user.id, dbName)
            });
            return await orderItemRepo.save(orderItem);
        }));
        return orderItems;
    }
    async findOrderOfBuilding(dbName: string, status?: OrderStatus) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        return await orderRepo.find({
            where: {
                ...(status && { status })
            },
            order: {
                createdAt: "DESC",
                items: {
                    payed: "ASC",
                    article: {
                        name: "ASC"
                    },
                }
            }
        });
    }
    async findOrderOfTable(dbName: string, tableId: UUID, status?: OrderStatus) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        return await orderRepo.find({
            where: {
                table: { id: tableId },
                ...(status && { status })
            },
            order: {
                createdAt: "DESC",
                items: {
                    payed: "ASC",
                    article: {
                        name: "ASC"
                    },
                }
            }
        });
    }
    async findOrderOfInclCurrUser(dbName: string, user: LoggedUser, status?: OrderStatus,) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        return await orderRepo.find({
            where: [
                {
                    ...(status && { status }),
                    openedBy: { id: user.id }
                },
                {
                    ...(status && { status }),
                    closedBy: { id: user.id }
                },
                {
                    ...(status && { status }),
                    items: { passedBy: { id: user.id } }
                }
            ],
            order: {
                createdAt: "DESC",
                items: {
                    payed: "ASC",
                    article: {
                        name: "ASC"
                    },
                }
            }
        });
    }

    async checkTableHaveOrder(tableId: UUID, dbName: string) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const order = await orderRepo.findOne({
            where: {
                table: { id: tableId },
                status: OrderStatus.PROGRESS
            }
        });
        return order;
    }

    async payOrderItem(orderItemId: UUID, dbName: string, user: LoggedUser) {
        const orderItemRepo = await this.repositoryFactory.getRepository(dbName, OrderItem);
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);

        const orderItem = await this.getItemById(orderItemId, dbName);
        orderItem.payed = true;
        await orderItemRepo.save(orderItem);

        let order = await this.getOrderById(orderItem.order.id, dbName);
        if (order.items.every(item => item.payed)) {
            order.status = OrderStatus.PAYED;
            order.table.status = TableStatus.available;
            order.closedBy = await this.usersService.findStaffById(user.id, dbName);
            order = await orderRepo.save(order);
        }
        return orderItem;
    }

    private async getItemById(orderItemId: UUID, dbName: string) {
        const orderItemRepo = await this.repositoryFactory.getRepository(dbName, OrderItem);
        const orderItem = await orderItemRepo.findOne({
            where: { id: orderItemId },
            relations: {
                order: {
                    table: true,
                    items: true,
                },
            }
        });
        if (!orderItem) {
            throw new NotFoundException(`Order item with ID ${orderItemId} not found`);
        }
        return orderItem;
    }

    async payAllitemsOfOrder(orderId: UUID, dbName: string, user: LoggedUser) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const orderItemRepo = await this.repositoryFactory.getRepository(dbName, OrderItem);

        const order = await this.getOrderById(orderId, dbName);

        // Mark all order items as paid
        await order.items.map(async item => {
            if (!item.payed) {
                item.payed = true;
                await orderItemRepo.save(item);
            }
        });

        // Update the order status to paid
        order.status = OrderStatus.PAYED;
        order.table.status = TableStatus.available;
        order.closedBy = await this.usersService.findStaffById(user.id, dbName);
        await orderRepo.save(order);
        return order;
    }

    async getOrderById(id: UUID, dbName: string) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);

        const order = await orderRepo.findOne({
            where: { id: id },
            relations: {
                items: true,
                table: true,
            },
            order: {
                items: {
                    payed: "ASC",
                },
            }
        });

        if (!order) {
            throw new NotFoundException(`Order with ID ${id} not found`);
        }

        if (order.status === OrderStatus.PROGRESS) {
            order.table.status = TableStatus.occupied;
        }
        return order;
    }

    async deleteOrder(id: UUID, dbName: string) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const orderItemRepo = await this.repositoryFactory.getRepository(dbName, OrderItem);

        const order = await this.getOrderById(id, dbName);

        await orderRepo.manager.transaction(async (manager) => {
            await manager.delete(OrderItem, { order: { id: order.id } });
            await manager.delete(Order, order.id);
        });
        return true;
    }

    async getOrderHistory(orderId: UUID, dbName: string) {
        const order = await this.getOrderById(orderId, dbName);
        return await this.historyService.getHistoryByOrderId(order.id, dbName);
    }
}
