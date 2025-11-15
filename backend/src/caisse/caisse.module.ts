import { Module } from '@nestjs/common';
import { CaisseService } from './caisse.service';
import { CaisseController } from './caisse.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Caisse } from './entities/caisse.entity';
import { BuildingModule } from 'src/building/building.module';

@Module({
  imports: [
    BuildingModule,
    TypeOrmModule.forFeature([
      Caisse,
    ]),
  ],
  controllers: [CaisseController],
  providers: [CaisseService],
  exports: [CaisseService],
})
export class CaisseModule { }
