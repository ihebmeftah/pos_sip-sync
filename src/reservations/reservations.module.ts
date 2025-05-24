import { Module } from '@nestjs/common';
import { ReservationsService } from './reservations.service';
import { ReservationsController } from './reservations.controller';
import { TablesModule } from 'src/tables/tables.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Reservation } from './entities/reservation.entity';
import { BuildingModule } from 'src/building/building.module';

@Module({
  imports: [
    TablesModule,
    BuildingModule,
    TypeOrmModule.forFeature([Reservation]),
  ],
  controllers: [ReservationsController],
  providers: [ReservationsService],
  exports: [ReservationsService]
})
export class ReservationsModule { }
