import { Controller, Get, Post, Body, Patch, Param, Delete, ParseEnumPipe, UseGuards, ParseUUIDPipe, Query } from '@nestjs/common';
import { TablesService } from './tables.service';
import { CreateTableDto } from './dto/create-table.dto';
import { UUID } from 'crypto';
import { TableStatus } from 'src/enums/table_status';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { RolesGuard } from 'src/guards/roles.guard';
import { BuildingId } from 'src/decorators/building.decorator';
import { BuildingIdGuard } from 'src/guards/building.guard';

@Controller('tables')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
@Roles(UserType.Admin)
export class TablesController {
  constructor(private readonly tablesService: TablesService) { }

  @Post()
  add(
    @Body() createTableDto: CreateTableDto,
    @BuildingId() buildingId: UUID,
  ) {
    return this.tablesService.create(createTableDto, buildingId);
  }

  @Get()
  @Roles(UserType.Employer, UserType.Admin, UserType.Client)
  findTablesOfBuilding(
    @BuildingId() buildingId: UUID,
    @Query(
      'status',
      new ParseEnumPipe(TableStatus, { optional: true })) status?: TableStatus,
  ) {
    return this.tablesService.findTablesOfBuilding(buildingId, status);
  }

  @Get(":id/scan")
  @Roles(UserType.Employer, UserType.Client)
  scanQrCodeTable(
    @Param('id', ParseUUIDPipe) id: UUID,
    @BuildingId() buildingId: UUID,
  ) {
    return this.tablesService.scanQrCodeTable(id, buildingId);
  }

  @Get(":id/order")
  @Roles(UserType.Employer, UserType.Admin)
  getTableCurrentOrder(
    @Param('id', ParseUUIDPipe) id: UUID,
  ) {
    return this.tablesService.getTableCurrentOrder(id);
  }
}
