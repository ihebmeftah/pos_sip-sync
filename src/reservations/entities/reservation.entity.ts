import { UUID } from "crypto";
import { Building } from "src/building/entities/building.entity";
import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { Table } from "src/tables/entities/table.entity";
import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Reservation extends TimestampBaseEntity {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;

    @Column({ type: 'timestamp' })
    // example: 2023-10-01T10:00:00Z
    start: Date;

    @Column({ type: 'timestamp', })
    // example: 2023-10-01T12:00:00Z
    end: Date;

    @Column({ type: 'decimal', default: 10 })
    price: number;

    @Column()
    customerName: string;

    @Column()
    customerPhone: number;

    @ManyToOne(() => Table, { nullable: true })
    table: Table;

    @ManyToOne(() => Building)
    building: Building;

}
