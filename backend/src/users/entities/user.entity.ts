import { UUID } from "crypto";
import { PrimaryGeneratedColumn, Column, Entity } from "typeorm";
import { TimestampBaseEntity } from "src/database/base/timestampbase";
import { UserType } from "src/enums/user.roles";

@Entity()
export class User extends TimestampBaseEntity {
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
    @Column("enum", { enum: UserType, array: true })
    type: UserType[];
}