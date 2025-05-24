import { UserBase } from "src/database/base/user.base";
import { Entity } from 'typeorm';

@Entity()
export class Customer extends UserBase {}
