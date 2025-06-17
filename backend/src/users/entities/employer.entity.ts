import { Building } from "src/building/entities/building.entity";
import { UserBase } from "src/database/base/user.base";
import { Entity, ManyToOne, Column } from 'typeorm';

@Entity()
export class Employer extends UserBase {
    @Column({ nullable: true })
    lastLogin: Date
    @ManyToOne(() => Building, { nullable: false })
    building: Building
}
