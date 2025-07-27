import {
    Injectable,
    NestInterceptor,
    ExecutionContext,
    CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { HistoryService } from './history.service';
import { HistoryActionType } from './entities/history.entity';
import { UUID } from 'crypto';
import { Order } from 'src/order/entities/order.entity';

@Injectable()
export class HistoryInterceptor implements NestInterceptor {
    constructor(private readonly historyService: HistoryService) { }

    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        const request = context.switchToHttp().getRequest();
        const user = request.user;
        const dbName = request.headers['dbname'] || request.headers['dbName'];
        const handlerName = context.getHandler().name;

        return next.handle().pipe(
            tap(async (result) => {
                let action: HistoryActionType | undefined;
                let order: Order | undefined;
                let orderItemIds: UUID[] | undefined;

                // Map handler names to actions
                switch (handlerName) {
                    case 'passOrder':
                        action = HistoryActionType.PASS_ORDER;
                        order = result;
                        break;
                    case 'addItemsToOrder':
                        action = HistoryActionType.ADD_ORDER_ITEM;
                        order = result[0].order as Order;
                        orderItemIds = result.map(item => item.id);
                        break;
                    case 'payOrderItem':
                        action = HistoryActionType.PAY_ORDER_ITEM;
                        order = result?.order as Order;
                        orderItemIds = [result?.id as UUID];
                        break;
                    case 'payAllItemsOfOrder':
                        action = HistoryActionType.PAY_ALL_ITEMS;
                        order = result as Order;
                        break;
                    case 'deleteOrder':
                        action = HistoryActionType.DELETE_ORDER;
                        order = result as Order;
                        break;
                }

                if (action && user && order && dbName) {
                    await this.historyService.createHistory({
                        action,
                        userId: user.id,
                        order: order,
                        orderItemIds,
                        dbName,
                    });
                }
            }),
        );
    }
} 