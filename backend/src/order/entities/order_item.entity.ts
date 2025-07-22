import { UUID } from 'crypto';
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne } from 'typeorm';
import { Order } from './order.entity';
import { Article } from 'src/article/entities/article.entity';
import { UserType } from 'src/enums/user.roles';
import { User } from 'src/users/entities/user.entity';

@Entity()
export class OrderItem {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @ManyToOne(() => Order, (order) => order.items,)
    order: Order;
    @ManyToOne(() => Article, { eager: true })
    article: Article;
    @Column({ default: false })
    payed: boolean;
    @ManyToOne(() => User, { eager: true })
    passedBy: User;

}
