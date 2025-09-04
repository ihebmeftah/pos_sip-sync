import { Building } from "src/building/entities/building.entity";
import { Entity, ManyToOne, Column, JoinColumn, OneToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from "./user.entity";


@Entity()
export class Employer extends User {
    @Column({ unique: true })
    username: string;
    @ManyToOne(() => Building, { eager: true })
    building: Building;
}
