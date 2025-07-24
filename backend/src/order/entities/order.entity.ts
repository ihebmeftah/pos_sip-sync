import { UUID } from "crypto";
import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, ValueTransformer } from "typeorm";
import { OrderItem } from "./order_item.entity";
import { OrderStatus } from "src/enums/order_status";
import { Table } from "src/tables/entities/table.entity";
import { User } from "src/users/entities/user.entity";
export class RefTransformer implements ValueTransformer {
    to(value: string): string {
        return value?.toString();
    }


    from(value: string): string {
        return value.split("/")[0];
    }
}
@Entity()
export class Order extends TimestampBaseEntity {

    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column({ unique: true, transformer: new RefTransformer() })
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
    @ManyToOne(() => User, { eager: true })
    openedBy: User;
    @ManyToOne(() => User, { eager: true, nullable: true })
    closedBy: User;
}

