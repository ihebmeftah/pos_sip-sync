import { UUID } from 'crypto';
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Order } from './order.entity';
import { Article } from 'src/article/entities/article.entity';
import { Employer } from 'src/users/entities/employer.entity';

@Entity()
export class OrderItem {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @ManyToOne(() => Order, (order) => order.items, { eager: false, })
    order: Order;
    @ManyToOne(() => Article, { eager: true })
    article: Article;
    @Column({ default: false })
    payed: boolean;

    @Column({
        type: "jsonb", nullable: true
    })
    passedBy: Employer;

}
