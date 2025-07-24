import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Order } from '../../order/entities/order.entity';
import { OrderItem } from '../../order/entities/order_item.entity';
import { UUID } from 'crypto';

export enum HistoryActionType {
    PASS_ORDER = 'PASS_ORDER',
    PAY_ORDER_ITEM = 'PAY_ORDER_ITEM',
    PAY_ALL_ITEMS = 'PAY_ALL_ITEMS',
    DELETE_ORDER = 'DELETE_ORDER',
}

@Entity()
export class History {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;

    @Column({ type: 'enum', enum: HistoryActionType })
    action: HistoryActionType;

    @ManyToOne(() => User, { eager: true })
    user: User;

    @ManyToOne(() => Order, { eager: true })
    order: Order;

    @Column({ nullable: true })
    orderItemId: UUID;

    @Column()
    message: string;

    @CreateDateColumn()
    createdAt: Date;
} 