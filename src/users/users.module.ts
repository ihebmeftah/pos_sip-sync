import { forwardRef, Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { BuildingModule } from 'src/building/building.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Admin } from './entities/admin.entity';
import { Employer } from './entities/employer.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Admin,
      Employer,
    ]),
    forwardRef(() => BuildingModule)
  ],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService]
})
export class UsersModule { }
