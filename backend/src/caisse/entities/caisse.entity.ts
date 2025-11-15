import { Building } from "src/building/entities/building.entity";
import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { UUID } from "crypto";

@Entity()
export class Caisse extends TimestampBaseEntity {
    @PrimaryGeneratedColumn('uuid')
    id: UUID;

    @Column({ unique: true })
    day: string;

    @Column({ type: 'timestamp' })
    start: Date;

    @Column({ type: 'timestamp' })
    close: Date;

}
