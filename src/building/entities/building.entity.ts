import { UUID } from 'crypto';
import { Admin } from 'src/admin/entities/admin.entity';
import { TimestampBaseEntity } from 'src/database/base/timestampbase';
import { Employer } from 'src/employer/entities/employer.entity';
import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Building extends TimestampBaseEntity {
    @PrimaryGeneratedColumn('uuid')
    id: UUID
    @Column()
    name: string
    @Column()
    openingTime: string
    @Column()
    closingTime: string
    @Column()
    location: string
    @Column({ nullable: true })
    long: number
    @Column({ nullable: true })
    lat: number
    @Column({ nullable: true })
    logo: string
    @Column("simple-array", { nullable: true, array: true })
    photos: string[]
    @ManyToOne(() => Admin, { nullable: false })
    admin: Admin
}
