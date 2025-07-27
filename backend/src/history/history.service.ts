import { forwardRef, Inject, Injectable } from '@nestjs/common';
import { History, HistoryActionType } from './entities/history.entity';
import { UUID } from 'crypto';
import { UsersService } from 'src/users/users.service';
import { Order } from 'src/order/entities/order.entity';
import { RepositoryFactory } from 'src/database/repository-factory.service';
import { Employer } from 'src/users/entities/employer.entity';
import { Staff } from 'src/users/entities/staff.entity';

@Injectable()
export class HistoryService {
    constructor(
        private readonly repositoryFactory: RepositoryFactory,
        @Inject(forwardRef(() => UsersService))
        private readonly userService: UsersService,
    ) { }

    async createHistory(params: {
        action: HistoryActionType;
        userId: UUID;
        order: Order;
        orderItemIds?: UUID[];
        dbName: string;
    }): Promise<History> {
        const historyRepo = await this.repositoryFactory.getRepository(params.dbName, History);
        const user = await this.userService.findStaffById(params.userId, params.dbName);
        const history = historyRepo.create({
            action: params.action,
            user: user,
            order: params.order,
            orderItemIds: params.orderItemIds,
            message: this.generateMessage(params.action, params.order, user, params.orderItemIds),
        });
        return historyRepo.save(history);
    }

    private generateMessage(action: HistoryActionType,
        order: Order,
        user: Staff,
        orderItemIds?: UUID[],
    ) {
        switch (action) {
            case HistoryActionType.ADD_ORDER_ITEM:
                return `${user.firstname} ${user.lastname} has added new items to the order ${order.ref} in ${order.table.name}`;
            case HistoryActionType.PAY_ALL_ITEMS:
                return `${user.firstname} ${user.lastname} has paid the order ${order.ref} in ${order.table.name}`;
            case HistoryActionType.DELETE_ORDER:
                return `${user.firstname} ${user.lastname} has deleted the order ${order.ref} in ${order.table.name}`;
            case HistoryActionType.PASS_ORDER:
                return `${user.firstname} ${user.lastname} has passed the order ${order.ref} in ${order.table.name}`;
        }
    }

    async getHistoryByOrderId(orderId: UUID, dbName: string) {
        const historyRepo = await this.repositoryFactory.getRepository(dbName, History);
        return historyRepo.find({
            where: { order: { id: orderId } },
            order: { createdAt: 'DESC' },
        });
    }
}