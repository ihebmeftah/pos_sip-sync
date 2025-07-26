import { UUID } from "crypto";
import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { TableStatus } from "src/enums/table_status";
import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Table extends TimestampBaseEntity {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column({ unique: true })
    name: String;
    @Column()
    seatsMax: number;

    status: TableStatus = TableStatus.available;

    constructor(name: String, seatsMax: number) {
        super();
        this.name = name;
        this.seatsMax = seatsMax;
    }
}
