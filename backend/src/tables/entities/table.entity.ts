import { UUID } from "crypto";
import { Building } from "src/building/entities/building.entity";
import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { TableStatus } from "src/enums/table_status";
import { AfterInsert, Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, ValueTransformer } from "typeorm";
export class TableNameTransformer implements ValueTransformer {
    to(value: string): string {
        return value?.toString();
    }


    from(value: string): string {
        return "Table " + (Number.parseInt(value.split(".")[0].split('-')[1]));
    }
}
@Entity()
export class Table extends TimestampBaseEntity {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column({ unique: true, transformer: new TableNameTransformer() })
    name: String;
    @Column()
    seatsMax: number;
    @ManyToOne(() => Building)
    building: Building;

    status: TableStatus = TableStatus.available;


    constructor(name: String, seatsMax: number, building: Building) {
        super();
        this.name = name;
        this.seatsMax = seatsMax;
        this.building = building;
    }
}
