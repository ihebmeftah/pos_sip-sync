import { UUID } from 'crypto';
import { TimestampBaseEntity } from 'src/database/base/timestampbase';
import {
  Column,
  Entity,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { OrderStatus } from 'src/enums/order_status';
import { Table } from 'src/tables/entities/table.entity';
import { Article } from 'src/article/entities/article.entity';
import { User } from 'src/users/entities/user.entity';
export interface Item {
  id: UUID;
  article: Article;
  addedBy: User;
  payed: boolean;
}
@Entity()
export class Order extends TimestampBaseEntity {
  @PrimaryGeneratedColumn('uuid')
  id: UUID;
  @Column({ unique: true })
  ref: string;
  @Column()
  status: OrderStatus;
  @Column({
    type: 'jsonb',
  })
  items: Item[];
  @ManyToOne(() => Table, { eager: true })
  table: Table;
  @Column({
    type: 'jsonb',
  })
  openedBy: User;
  @Column({
    type: 'jsonb',
    nullable: true,
  })
  closedBy: User;
}
