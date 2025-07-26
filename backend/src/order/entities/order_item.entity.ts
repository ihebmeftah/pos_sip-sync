import { UUID } from 'crypto';
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Order } from './order.entity';
import { Article } from 'src/article/entities/article.entity';
import { Staff } from 'src/users/entities/staff.entity';

@Entity()
export class OrderItem {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @ManyToOne(() => Order, (order) => order.items, { eager: false })
    order: Order;
    @ManyToOne(() => Article, { eager: true })
    article: Article;
    @Column({ default: false })
    payed: boolean;
    @ManyToOne(() => Staff, { eager: true })
    passedBy: Staff;

}
