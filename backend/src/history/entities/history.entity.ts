import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Order } from '../../order/entities/order.entity';
import { OrderItem } from '../../order/entities/order_item.entity';
import { UUID } from 'crypto';
import { Employer } from 'src/users/entities/employer.entity';
import { Staff } from 'src/users/entities/staff.entity';

export enum HistoryActionType {
    PASS_ORDER = 'PASS_ORDER',
    PAY_ORDER_ITEM = 'PAY_ORDER_ITEM',
    ADD_ORDER_ITEM = 'ADD_ORDER_ITEM',
    PAY_ALL_ITEMS = 'PAY_ALL_ITEMS',
    DELETE_ORDER = 'DELETE_ORDER',
}

@Entity()
export class History {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;

    @Column({ type: 'enum', enum: HistoryActionType })
    action: HistoryActionType;

    @ManyToOne(() => Staff, { eager: true })
    user: Staff;

    @ManyToOne(() => Order, { eager: true })
    order: Order;

    @Column("uuid", { array: true, nullable: true })
    orderItemIds: UUID[];

    @Column()
    message: string;

    @CreateDateColumn()
    createdAt: Date;
} 