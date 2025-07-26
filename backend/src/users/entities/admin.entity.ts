import { Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { User } from './user.entity';
import { UUID } from 'crypto';

@Entity()
export class Admin extends User {

}
