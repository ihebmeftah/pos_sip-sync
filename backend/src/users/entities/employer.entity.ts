import { Building } from "src/building/entities/building.entity";
import { Entity, ManyToOne, Column, JoinColumn, OneToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from "./user.entity";
import { UUID } from "crypto";

@Entity()
export class Employer {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column({ unique: true })
    buildingEmail: string;
    @ManyToOne(() => Building, { nullable: false, eager: true })
    building: Building
    @OneToOne(() => User, { eager: true, onDelete: 'CASCADE', cascade: true, })
    @JoinColumn()
    user: User;
}
