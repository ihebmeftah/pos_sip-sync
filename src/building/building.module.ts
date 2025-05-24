import { Module } from '@nestjs/common';
import { BuildingService } from './building.service';
import { BuildingController } from './building.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Building } from './entities/building.entity';
import { AdminModule } from 'src/admin/admin.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Building
    ]),
    AdminModule,
  ],
  controllers: [BuildingController],
  providers: [BuildingService],
  exports: [BuildingService],
})
export class BuildingModule { }
