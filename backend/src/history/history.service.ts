import { forwardRef, Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { History, HistoryActionType } from './entities/history.entity';
import { UUID } from 'crypto';
import { OrderService } from 'src/order/order.service';
import { UsersService } from 'src/users/users.service';
import { Order } from 'src/order/entities/order.entity';
import { User } from 'src/users/entities/user.entity';

@Injectable()
export class HistoryService {
    constructor(
        @InjectRepository(History)
        private readonly historyRepository: Repository<History>,

        @Inject(forwardRef(() => UsersService))
        private readonly userService: UsersService,

    ) { }

    async createHistory(params: {
        action: HistoryActionType;
        userId: UUID;
        order: Order;
        orderItemId?: UUID;
    }): Promise<History> {
        const user = await this.userService.findUserById(params.userId);
        const history = this.historyRepository.create({
            action: params.action,
            user: user,
            order: params.order,
            orderItemId: params.orderItemId,
            message: this.generateMessage(params.action, params.order, user, params.orderItemId),
        });
        return this.historyRepository.save(history);
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

    async getHistoryByOrderId(orderId: UUID) {
        return this.historyRepository.find({
            where: { order: { id: orderId } },
            order: { createdAt: 'DESC' },
        });
    }
}