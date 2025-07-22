import { Building } from "src/building/entities/building.entity";
import { Entity, ManyToOne, Column, JoinColumn, OneToOne, PrimaryColumn } from 'typeorm';
import { User } from "./user.entity";
import { UUID } from "crypto";

@Entity()
export class Employer {
    @PrimaryColumn("uuid")
    id: UUID;
    @Column({ nullable: true })
    lastLogin: Date
    @ManyToOne(() => Building, { nullable: false })
    building: Building
    @OneToOne(() => User, { eager: true, onDelete: 'CASCADE', cascade: true, })
    @JoinColumn()
    user: User;
    @Column({ nullable: true })
    role: String;
}
