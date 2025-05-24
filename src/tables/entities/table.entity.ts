import { UUID } from "crypto";
import { Building } from "src/building/entities/building.entity";
import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { TableStatus } from "src/enums/table_status";
import { Reservation } from "src/reservations/entities/reservation.entity";
import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Table extends TimestampBaseEntity {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column({ unique: true })
    name: String;
    @Column()
    seatsMax: number;

    @ManyToOne(() => Building)
    building: Building;

    status: TableStatus = TableStatus.available;
    @OneToMany(() => Reservation, (reservation) => reservation.table, { nullable: true })
    reservations: Reservation[];

    constructor(name: String, seatsMax: number, building: Building) {
        super();
        this.name = name;
        this.seatsMax = seatsMax;
        this.building = building;
    }
}
