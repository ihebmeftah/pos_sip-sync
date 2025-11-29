import { UUID } from 'crypto';
import { TimestampBaseEntity } from 'src/database/base/timestampbase';
import { UnitsType } from 'src/enums/units_type';
import { DecimalTransformer } from 'src/utils/decimal-transformer';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Ingredient extends TimestampBaseEntity {
    @PrimaryGeneratedColumn('uuid')
    id: UUID;

    @Column({ unique: true })
    name: string;

    @Column({ nullable: true })
    description: string;

    @Column() // Default unit for this ingredient
    stockUnit: UnitsType;

    @Column('decimal', { precision: 15, scale: 3, transformer: new DecimalTransformer() })
    currentStock: number; // Current quantity in stock

    @Column('decimal', { precision: 15, scale: 3, nullable: true, transformer: new DecimalTransformer() })
    minimumStock: number; // Alert threshold
}
