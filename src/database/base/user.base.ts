import { UUID } from "crypto";
import { PrimaryGeneratedColumn, Column } from "typeorm";
import { TimestampBaseEntity } from "src/database/base/timestampbase";

export class UserBase extends TimestampBaseEntity {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column()
    firstname: string;
    @Column()
    lastname: string;
    @Column({ unique: true, primary: true })
    email: string;
    @Column({ unique: true, primary: true })
    phone: string;

    @Column()
    password: string;
    @Column({ nullable: true })
    photo: string;

}