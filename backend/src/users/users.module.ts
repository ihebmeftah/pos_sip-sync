import { forwardRef, Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Admin } from './entities/admin.entity';
import { Employer } from './entities/employer.entity';
import { User } from './entities/user.entity';
import { BuildingModule } from 'src/building/building.module';

@Module({
  imports: [
    forwardRef(() => BuildingModule),
    TypeOrmModule.forFeature([
      Admin,
      Employer,
      User
    ]),
  ],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService]
})
export class UsersModule { }
