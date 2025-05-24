import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, ParseUUIDPipe } from '@nestjs/common';
import { ReservationsService } from './reservations.service';
import { CreateReservationDto } from './dto/create-reservation.dto';
import { BuildingIdGuard } from 'src/guards/building.guard';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { UUID } from 'crypto';
import { BuildingId } from 'src/decorators/building.decorator';
import { UserRole } from 'src/enums/user.roles';
import { Roles } from 'src/decorators/roles.decorator';

@Controller('reservations')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
@Roles(UserRole.Admin)
export class ReservationsController {
  constructor(private readonly reservationsService: ReservationsService) { }

  @Post()
  create(
    @Body() createReservationDto: CreateReservationDto,
    @BuildingId() buildingId: UUID
  ) {
    return this.reservationsService.create(createReservationDto, buildingId);
  }

  @Get()
  findAll(
    @BuildingId() buildingId: UUID,
  ) {
    return this.reservationsService.findAll(buildingId);
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: UUID) {
    return this.reservationsService.findOne(id);
  }

  @Patch(':id/table/:tableId')
  assignTable(
    @Param('id', ParseUUIDPipe) id: UUID,
    @Param('tableId', ParseUUIDPipe) tableId: UUID,
  ) {
    return this.reservationsService.assignTable(id, tableId);
  }
  @Delete(':id')
  remove(@Param('id', ParseUUIDPipe) id: UUID) {
    return this.reservationsService.remove(id);
  }
}
