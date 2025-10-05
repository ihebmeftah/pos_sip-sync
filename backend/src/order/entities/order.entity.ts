import { UUID } from "crypto";
import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { OrderItem } from "./order_item.entity";
import { OrderStatus } from "src/enums/order_status";
import { Table } from "src/tables/entities/table.entity";
import { Employer } from "src/users/entities/employer.entity";
@Entity()
export class Order extends TimestampBaseEntity {

    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column({ unique: true })
    ref: string;
    @Column()
    status: OrderStatus;
    @OneToMany(
        () => OrderItem,
        (orderItem) => orderItem.order,
        {
            cascade: true,
            eager: true
        })
    items: OrderItem[];
    @ManyToOne(() => Table, { eager: true })
    table: Table;
    @Column({
        type: "jsonb", nullable: false
    })
    openedBy: Employer;
    @Column({
        type: "jsonb", nullable: true
    })
    closedBy: Employer;
}

