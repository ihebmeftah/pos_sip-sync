import { UUID } from 'crypto';
import { Categroy } from 'src/categroy/entities/categroy.entity';
import { DecimalTransformer } from 'src/utils/decimal-transformer';
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Article {
    @PrimaryGeneratedColumn('uuid')
    id: UUID;
    @Column()
    name: string;
    @Column({ nullable: true })
    description: string;
    @Column({ nullable: true })
    image: string;
    @Column({ type: 'decimal', precision: 10, scale: 2, transformer: new DecimalTransformer() })
    price: number;
    @ManyToOne(() => Categroy)
    category: Categroy
}