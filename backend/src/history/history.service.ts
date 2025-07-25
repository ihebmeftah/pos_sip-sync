import { forwardRef, Inject, Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { History, HistoryActionType } from './entities/history.entity';
import { UUID } from 'crypto';
import { UsersService } from 'src/users/users.service';
import { Order } from 'src/order/entities/order.entity';
import { User } from 'src/users/entities/user.entity';
import { RepositoryFactory } from 'src/database/repository-factory.service';

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
        orderItemId?: UUID;
        dbName: string;
    }): Promise<History> {
        const historyRepo = await this.repositoryFactory.getRepository(params.dbName, History);
        const user = await this.userService.findUserById(params.userId);

        const history = historyRepo.create({
            action: params.action,
            user: user,
            order: params.order,
            orderItemId: params.orderItemId,
            message: this.generateMessage(params.action, params.order, user, params.orderItemId),
        });
        return historyRepo.save(history);
    }

    private generateMessage(action: HistoryActionType,
        order: Order,
        user: User,
        orderItemId?: UUID,
    ) {
        switch (action) {
            case HistoryActionType.PAY_ORDER_ITEM:
                return `The user ${user.type.join(', ')} ${user.firstname} ${user.lastname} has paid the item ${order.items.find(item => item.id === orderItemId)?.article.name} of the order ${order.ref} in the table ${order.table.name}`;
            case HistoryActionType.PAY_ALL_ITEMS:
                return `The user ${user.type.join(', ')} ${user.firstname} ${user.lastname} has paid the order ${order.ref} in the table ${order.table.name}`;
            case HistoryActionType.DELETE_ORDER:
                return `The user ${user.type.join(', ')} ${user.firstname} ${user.lastname} has deleted the order ${order.ref} in the table ${order.table.name}`;
            case HistoryActionType.PASS_ORDER:
                return `The user ${user.type.join(', ')} ${user.firstname} ${user.lastname} has passed the order ${order.ref} in the table ${order.table.name}`;
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