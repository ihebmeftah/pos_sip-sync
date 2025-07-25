import { ConflictException, Injectable, Inject, forwardRef, NotFoundException } from '@nestjs/common';
import { CreateOrderDto } from './dto/create-order.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
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

@Injectable()
export class OrderService {
    constructor(
        @InjectRepository(Order)
        private readonly orderRepo: Repository<Order>,
        @InjectRepository(OrderItem)
        private readonly orderItemRepo: Repository<OrderItem>,
        @Inject(forwardRef(() => TablesService))
        private readonly tablesService: TablesService,
        private readonly articleService: ArticleService,
        private readonly usersService: UsersService,
        private readonly historyService: HistoryService,
    ) { }


    async passOrder(
        createOrderDto: CreateOrderDto,
        user: LoggedUser,
    ) {
        const openedBy = await this.usersService.findUserById(user.id);
        const table = await this.tablesService.findOne(createOrderDto.tableId);
        const orderTable = await this.checkTableHaveOrder(createOrderDto.tableId);
        if (orderTable) {
            throw new ConflictException(`this table ${table.name.split('.')[0]} already have an order`);
        }
        const articles: Article[] = [];
        for (const articleId of createOrderDto.articlesIds) {
            const article = await this.articleService.findOne(articleId);
            articles.push(article);
        }
        const orderItems = await this.orderItemRepo.create(articles.map((article) => {
            const orderItem = new OrderItem();
            orderItem.article = article;
            orderItem.payed = false;
            orderItem.passedBy = openedBy;
            return orderItem;
        }));
        const uniqueNumber = Math.floor(1000 + Math.random() * 9000);
        const now = new Date();
        const formattedDate = `${now.getDate()}J/${now.getMonth() + 1}M/${now.getFullYear()},${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}:${now.getSeconds().toString().padStart(2, '0')}`;
        const order = this.orderRepo.create({
            table,
            ref: `REF-${uniqueNumber}/${formattedDate}`,
            items: orderItems,
            status: OrderStatus.PROGRESS,
            openedBy
        });
        const savedOrder = await this.orderRepo.save(order);
        savedOrder.table.status = TableStatus.occupied;
        return savedOrder;
    }

    async findOrderOfBuilding(buildingId: UUID, status?: OrderStatus) {
        return await this.orderRepo.find({
            where: {
                table: { building: { id: buildingId } },
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
    async checkTableHaveOrder(tableId: UUID) {
        const order = await this.orderRepo.findOne({
            where: {
                table: { id: tableId },
                status: OrderStatus.PROGRESS
            }
        });
        return order;
    }

    async payOrderItem(orderItemId: UUID) {
        const orderItem = await this.getItemById(orderItemId);
        orderItem.payed = true;
        await this.orderItemRepo.save(orderItem);
        let order = await this.getOrderById(orderItem.order.id);
        if (order.items.every(item => item.payed)) {
            order.status = OrderStatus.PAYED;
            order.table.status = TableStatus.available;
            order = await this.orderRepo.save(order);
        }
        return orderItem;
    }
    private async getItemById(orderItemId: UUID) {
        const orderItem = await this.orderItemRepo.findOne({
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

    async payAllitemsOfOrder(orderId: UUID) {
        const order = await this.getOrderById(orderId);
        // Mark all order items as paid
        await order.items.map(async item => {
            if (!item.payed) {
                item.payed = true;
                await this.orderItemRepo.save(item);
            }
        });
        // Update the order status to paid
        order.status = OrderStatus.PAYED;
        order.table.status = TableStatus.available;
        await this.orderRepo.save(order);
        return order;
    }
    async getOrderById(id: UUID) {
        const order = await this.orderRepo.findOne({
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

    async deleteOrder(id: UUID) {
        const order = await this.getOrderById(id);
        await this.orderRepo.manager.transaction(async (manager) => {
            await manager.delete(OrderItem, { order: { id: order.id } });
            await manager.delete(Order, order.id);
        });
        return true;
    }

    async getOrderHistory(orderId: UUID) {
        const order = await this.getOrderById(orderId);
        return await this.historyService.getHistoryByOrderId(order.id);
    }
}
