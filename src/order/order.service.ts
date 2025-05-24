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
import { UserRole } from 'src/enums/user.roles';

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
    ) { }


    async passOrder(
        createOrderDto: CreateOrderDto,
        user,
    ) {
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
            orderItem.passedBy = user.role;
            orderItem.passedById = user.id;
            return orderItem;
        }));
        const order = this.orderRepo.create({
            table,
            items: orderItems,
            status: OrderStatus.PROGRESS,
        });
        const savedOrder = await this.orderRepo.save(order);
        savedOrder.table.status = TableStatus.occupied;
        return savedOrder;
    }

    async findOrderOfBuilding(buildingId: UUID, user) {
        if (user.role === UserRole.Employer || user.role === UserRole.Client) {
            return await this.orderRepo.find({
                where: {
                    table: {
                        building: { id: buildingId }
                    },
                    items: {
                        passedById: user.id
                    }
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
        } else
            return await this.orderRepo.find({
                where: {
                    table: { building: { id: buildingId } }
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
    async getOrderItems(orderId: UUID) {
        return this.orderItemRepo.find({
            where: {
                order: { id: orderId }
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
        return await this.orderRepo.manager.transaction(async (entityManager) => {
            const orderItem = await entityManager.findOne(OrderItem, {
                where: { id: orderItemId },
                relations: { order: true },
            });

            if (!orderItem) {
                throw new ConflictException(`Order item with ID ${orderItemId} not found`);
            }

            // Mark the order item as paid
            orderItem.payed = true;
            await entityManager.save(orderItem);

            // Check if all items in the order are paid
            const order = await entityManager.findOne(Order, {
                where: { id: orderItem.order.id },
                relations: { items: true },
            });

            if (order && order.items.every((item) => item.payed)) {
                order.status = OrderStatus.PAYED;
                await entityManager.save(order);
            }
            return order;
        });
    }
    async payAllitemsOfOrder(orderId: UUID) {
        return await this.orderRepo.manager.transaction(async (entityManager) => {
            const order = await entityManager.findOne(Order, {
                where: { id: orderId },
                relations: { items: true },
            });
            if (!order) {
                throw new NotFoundException(`Order with ID ${orderId} not found`);
            }
            // Mark all order items as paid
            for (const item of order.items) {
                if (!item.payed) {
                    item.payed = true;
                    await entityManager.save(item);
                }
            }
            // Update the order status to paid
            order.status = OrderStatus.PAYED;
            await entityManager.save(order);
            return order;
        });
    }
    async getOrderById(id: UUID) {
        const order = await this.orderRepo.findOne({
            where: { id },
        });
        if (!order) {
            throw new NotFoundException(`Order with ID ${id} not found`);
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
    async getSales(buildingId: UUID) {
        const orders = await this.orderRepo.find({
            where: {
                table: {
                    building: { id: buildingId }
                },
                status: OrderStatus.PAYED
            },
            relations: {
                items: {
                    article: true
                }
            }
        });
        let total = 0;
        for (const order of orders) {
            for (const item of order.items) {
                total += Number(item.article.price);
            }
        }
        // Return total rounded to two decimal places
        return Number(total.toFixed(2));
    }
    async totalOrderNb(buildingId: UUID) {
        return await this.orderRepo.count({ where: { table: { building: { id: buildingId } } } });
    }
    async mostSelledArticles(buildingId: UUID) {
        const orders = await this.orderRepo.find({
            where: {
                table: {
                    building: { id: buildingId }
                }
            },
            relations: {
                items: {
                    article: true
                }
            }
        });

        const articleCount = new Map<string, { article: Article, count: number }>();

        for (const order of orders) {
            for (const item of order.items) {
                const articleId = item.article.id;
                if (!articleCount.has(articleId)) {
                    articleCount.set(articleId, { article: item.article, count: 0 });
                }
                articleCount.get(articleId)!.count += 1;
            }
        }

        // Sort by count descending and return top 5 with count
        return Array.from(articleCount.values())
            .sort((a, b) => b.count - a.count)
            .slice(0, 5);
    }
}
