import {
    ConflictException,
    Injectable,
    Inject,
    forwardRef,
    NotFoundException,
} from '@nestjs/common';
import { CreateOrderDto } from './dto/create-order.dto';
import { Order } from './entities/order.entity';
import { TablesService } from 'src/tables/tables.service';
import { ArticleService } from 'src/article/article.service';
import { UUID } from 'crypto';
import { OrderStatus } from 'src/enums/order_status';
import { Article } from 'src/article/entities/article.entity';
import { TableStatus } from 'src/enums/table_status';
import { LoggedUser } from 'src/auth/strategy/loggeduser';
import { UsersService } from 'src/users/users.service';
import { RepositoryFactory } from 'src/database/repository-factory.service';
import { JsonContains } from 'typeorm';
import { BuildingService } from 'src/building/building.service';

@Injectable()
export class OrderService {
    constructor(
        private readonly repositoryFactory: RepositoryFactory,
        @Inject(forwardRef(() => TablesService))
        private readonly tablesService: TablesService,
        private readonly articleService: ArticleService,
        private readonly usersService: UsersService,
        private readonly buildingService: BuildingService,
    ) { }

    async findOrderOfBuilding(dbName: string, status?: OrderStatus) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        return await orderRepo.find({
            where: {
                ...(status && { status }),
            },
            order: {
                createdAt: 'DESC',
                items: {
                    payed: 'ASC',
                    article: {
                        name: 'ASC',
                    },
                },
            },
        });
    }

    async findOrderOfTable(dbName: string, tableId: UUID, status?: OrderStatus) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        return await orderRepo.find({
            where: {
                table: { id: tableId },
                ...(status && { status }),
            },
            order: {
                createdAt: 'DESC',
                items: {
                    payed: 'ASC',
                    article: {
                        name: 'ASC',
                    },
                },
            },
        });
    }

    async findOrderOfCurrUser(
        dbName: string,
        user: LoggedUser,
        status?: OrderStatus,
    ) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        return await orderRepo.find({
            where: [
                {
                    ...(status && { status }),
                    openedBy: JsonContains({ id: user.id }),
                },
                {
                    ...(status && { status }),
                    closedBy: JsonContains({ id: user.id }),
                },
                {
                    ...(status && { status }),
                    items: {
                        addedBy: JsonContains({ id: user.id }),
                    },
                },
            ],
            order: {
                createdAt: 'DESC',
                items: {
                    payed: 'ASC',
                    article: {
                        name: 'ASC',
                    },
                },
            },
        });
    }

    async checkTableHaveOrder(tableId: UUID, dbName: string) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const order = await orderRepo.findOne({
            where: {
                table: { id: tableId },
                status: OrderStatus.PROGRESS,
            },
        });
        return order;
    }

    async passOrder(
        createOrderDto: CreateOrderDto,
        user: LoggedUser,
        dbName: string,
    ) {
        const building = await this.buildingService.findByDbName(dbName);
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const openedBy = await this.usersService.findUser(user.id, user.type);
        const table = await this.tablesService.findOne(
            createOrderDto.tableId,
            dbName,
        );
        if (building.tableMultiOrder == false) {
            const orderTable = await this.checkTableHaveOrder(
                createOrderDto.tableId,
                dbName,
            );
            if (orderTable) {
                throw new ConflictException(
                    `this table ${table.name} already have an order`,
                );
            }
        }
        const articles: Article[] = [];
        for (const articleId of createOrderDto.articlesIds) {
            const article = await this.articleService.findOne(articleId, dbName);
            articles.push(article);
        }
        const uniqueNumber = Math.floor(1000 + Math.random() * 9000);
        const order = orderRepo.create({
            table,
            ref: `REF-${uniqueNumber}`,
            items: articles.map((article) => ({
                id: crypto.randomUUID(),
                article,
                addedBy: openedBy,
                payed: false,
            })),
            status: OrderStatus.PROGRESS,
            openedBy,
        });
        const savedOrder = await orderRepo.save(order);
        savedOrder.table.status = TableStatus.occupied;
        return savedOrder;
    }

    async addItemsToOrder(
        orderId: UUID,
        articleIds: UUID[],
        dbName: string,
        user: LoggedUser,
    ) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const order = await this.getOrderById(orderId, dbName);
        const addedBy = await this.usersService.findUser(user.id, user.type);
        if (order.status === OrderStatus.PAYED) {
            throw new ConflictException(
                `Order with ID ${orderId} is already paid and cannot be modified.`,
            );
        }
        const articles: Article[] = [];
        for (const articleId of articleIds) {
            const article = await this.articleService.findOne(articleId, dbName);
            articles.push(article);
        }
        const newAddedItems = articles.map((article) => ({
            article,
            addedBy,
            payed: false,
        }));
        return await orderRepo.save({
            ...order,
            items: [...order.items, ...newAddedItems],
        });
    }


    async getOrderById(id: UUID, dbName: string) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const order = await orderRepo.findOne({
            where: { id: id },
            relations: {
                table: true,
            },
        });
        if (!order) {
            throw new NotFoundException(`Order with ID ${id} not found`);
        }
        order.items.sort((a, b) => {
            if (a.payed === b.payed) {
                return 0;
            }
            return a.payed ? 1 : -1;
        });
        if (order.status === OrderStatus.PROGRESS) {
            order.table.status = TableStatus.occupied;
        }
        return order;
    }

    async payItemInOrder(
        orderId: UUID,
        itemId: UUID,
        dbName: string,
        loggedUser: LoggedUser,
    ) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const order = await this.getOrderById(orderId, dbName);
        const user = await this.usersService.findUser(loggedUser.id, loggedUser.type);
        const itemIndex = order.items.findIndex((itm) => itm.id === itemId);
        if (itemIndex === -1) {
            throw new NotFoundException(`Item with ID ${itemId} not found in order`);
        }
        order.items[itemIndex].payed = true;
        if (order.items.every((item) => item.payed === true)) {
            order.status = OrderStatus.PAYED;
            order.closedBy = user;
        }
        await orderRepo.save(order);
        return order.items[itemIndex];
    }

    async payOrder(orderId: UUID, dbName: string, loggedUser: LoggedUser) {
        const orderRepo = await this.repositoryFactory.getRepository(dbName, Order);
        const order = await this.getOrderById(orderId, dbName);
        const user = await this.usersService.findUser(loggedUser.id, loggedUser.type);
        order.items = order.items.map(item => ({
            ...item,
            payed: true,
        }));
        order.status = OrderStatus.PAYED;
        order.closedBy = user;
        await orderRepo.save(order);
        return order;
    }
}
