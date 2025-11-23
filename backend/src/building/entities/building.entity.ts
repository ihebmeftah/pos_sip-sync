import { UUID } from 'crypto';
import { TimestampBaseEntity } from 'src/database/base/timestampbase';
import { Admin } from 'src/users/entities/admin.entity';
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Building extends TimestampBaseEntity {
    @PrimaryGeneratedColumn('uuid')
    id: UUID
    @Column()
    name: string
    @Column({ unique: true })
    dbName: string

    /// Config to allow multiple orders on same table (e.g table 1 has order 1, order 2, order 3 in prog in the same time.)
    @Column({ default: false })
    tableMultiOrder: boolean

    @Column({ type: 'timestamp' })
    openingTime: Date

    @Column({ type: 'timestamp' })
    closingTime: Date

    @Column()
    location: string
    @Column({ nullable: true })
    long: number
    @Column({ nullable: true })
    lat: number
    @Column({ nullable: true })
    logo: string
    @Column("text", { nullable: true, array: true })
    photos: string[]
    @ManyToOne(() => Admin)
    admin: Admin
}
