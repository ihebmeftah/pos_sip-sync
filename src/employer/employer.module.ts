import { Module } from '@nestjs/common';
import { EmployerService } from './employer.service';
import { EmployerController } from './employer.controller';
import { Employer } from './entities/employer.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BuildingModule } from 'src/building/building.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Employer]),
    BuildingModule
  ],
  controllers: [EmployerController],
  providers: [EmployerService],
  exports: [EmployerService],
})
export class EmployerModule { }
