import { UUID } from 'crypto';
import { TimestampBaseEntity } from 'src/database/base/timestampbase';
import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class Category extends TimestampBaseEntity {
    @PrimaryGeneratedColumn("uuid")
    id: UUID;
    @Column({ unique: true })
    name: string;
    @Column({ nullable: true })
    description: string;
    @Column({ nullable: true })
    image: string;
}
