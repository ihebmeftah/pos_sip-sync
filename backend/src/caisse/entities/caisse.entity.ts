import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";
import { UUID } from "crypto";

@Entity()
export class Caisse extends TimestampBaseEntity {
    @PrimaryGeneratedColumn('uuid')
    id: UUID;
    @Column({ unique: true })
    day: string;
}
