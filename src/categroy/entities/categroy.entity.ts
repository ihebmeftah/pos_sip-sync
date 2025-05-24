import { UUID } from 'crypto';
import { Building } from 'src/building/entities/building.entity';
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Categroy {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column()
    name: string;
    @Column({ nullable: true })
    description: string;
    @Column({ nullable: true })
    image: string;
    @ManyToOne(() => Building)
    building: Building;

}
