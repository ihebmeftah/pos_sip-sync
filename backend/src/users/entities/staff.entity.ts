import { Column, Entity, OneToOne } from 'typeorm';
import { User } from './user.entity';
import { Employer } from './employer.entity';
import { UUID } from 'crypto';
import { Building } from 'src/building/entities/building.entity';

@Entity()
export class Staff extends User {
    @Column()
    employerId: UUID;
  
}
