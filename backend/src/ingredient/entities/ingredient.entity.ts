import { UUID } from 'crypto';
import { TimestampBaseEntity } from 'src/database/base/timestampbase';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Ingredient extends TimestampBaseEntity {
    @PrimaryGeneratedColumn('uuid')
    id: UUID;

    @Column()
    name: string;

    @Column({ nullable: true })
    description: string;

    @Column({ default: 'g' }) // Default unit for this ingredient
    stockUnit: string;

    @Column('decimal', { precision: 15, scale: 3, default: 0 })
    currentStock: number; // Current quantity in stock

    @Column('decimal', { precision: 15, scale: 3, nullable: true })
    minimumStock: number; // Alert threshold
}
