import { Module } from '@nestjs/common';
import { CategroyService } from './categroy.service';
import { CategroyController } from './categroy.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Categroy } from './entities/categroy.entity';
import { BuildingModule } from 'src/building/building.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Categroy]),
    BuildingModule,
  ],
  controllers: [CategroyController],
  providers: [CategroyService],
  exports: [CategroyService],

})
export class CategroyModule { }
