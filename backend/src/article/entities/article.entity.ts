import { UUID } from 'crypto';
import { Categroy } from 'src/categroy/entities/categroy.entity';
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
    @Column({type: 'decimal'})
    price: number;
    @ManyToOne(() => Categroy)
    category: Categroy

}