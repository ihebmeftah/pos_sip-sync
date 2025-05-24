import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateReservationDto } from './dto/create-reservation.dto';
import { TablesService } from '../tables/tables.service';
import { Reservation } from './entities/reservation.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UUID } from 'crypto';
import { BuildingService } from 'src/building/building.service';
import { TableStatus } from 'src/enums/table_status';

@Injectable()
export class ReservationsService {
  constructor(
    @InjectRepository(Reservation)
    private readonly reservationRepo: Repository<Reservation>,
    private readonly tablesService: TablesService,
    private readonly buildingService: BuildingService
  ) { }
  async create(createReservationDto: CreateReservationDto, buildingId: UUID) {
    const building = await this.buildingService.findOne(buildingId);
    const { startTime, endTime, customerName, customerPhone, price } = createReservationDto;
    // Ensure start and end times are in the same day, month, and year
    const start = new Date(startTime);
    const end = new Date(endTime);
    // Ensure the difference between start and end times is at least 1 hour
    const timeDifference = (end.getTime() - start.getTime()) / (1000 * 60 * 60); // Difference in hours
    if (timeDifference < 1) {
      throw new ConflictException('The time difference between start and end must be at least 1 hour.');
    }
    const reservation = this.reservationRepo.create({
      start: startTime,
      end: endTime,
      customerName,
      customerPhone,
      price,
      building,
    });
    if (createReservationDto.tableId) {
      const table = await this.tablesService.findOne(createReservationDto.tableId);
      reservation.table = table;
    }
    return await this.reservationRepo.save(reservation);
  }

  async findAll(buildingId: UUID, date: Date = new Date()) {
    return await this.reservationRepo.find({
      order: {
        start: 'DESC',
      },
      where: [
        {
          building: {
            id: buildingId,
          },
        },
        {
          table: {
            building: {
              id: buildingId,
            }
          },
        }
      ]
    });
  }

  async findOne(id: UUID) {
    const reservation = await this.reservationRepo.findOne({
      where: { id },
      relations: {
        table: true,
      }
    },);
    if (!reservation) {
      throw new NotFoundException('Reservation not found');
    }
    return reservation;
  }


  async assignTable(id: UUID, tableId: UUID) {
    const reservation = await this.findOne(id);
    const table = await this.tablesService.findOne(tableId);
    if (table.status == TableStatus.occupied) {
      throw new ConflictException('Table is already occupied');
    }
    return await this.reservationRepo.update(id, { table });
  }

  async remove(id: UUID) {
    const reservation = await this.findOne(id);
    await this.reservationRepo.delete(id);
    return true;
  }

}

