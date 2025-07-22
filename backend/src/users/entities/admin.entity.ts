import { Entity, OneToOne, JoinColumn, PrimaryGeneratedColumn } from 'typeorm';
import { User } from "./user.entity";
import { UUID } from 'crypto';

@Entity()
export class Admin {
     @PrimaryGeneratedColumn("uuid")
        id: UUID;
    @OneToOne(() => User, { eager: true, onDelete: 'CASCADE', cascade: true, })
    @JoinColumn()
    user: User;
}
