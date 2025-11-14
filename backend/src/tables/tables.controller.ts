import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  ParseEnumPipe,
  UseGuards,
  ParseUUIDPipe,
  Query,
} from '@nestjs/common';
import { TablesService } from './tables.service';
import { CreateTableDto } from './dto/create-table.dto';
import { UUID } from 'crypto';
import { TableStatus } from 'src/enums/table_status';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { RolesGuard } from 'src/guards/roles.guard';
import { DbName } from 'src/decorators/building.decorator';
import { DbNameGuard } from 'src/guards/dbname.guard';

@Controller('tables')
@UseGuards(JwtAuthGuard, RolesGuard, DbNameGuard)
@Roles(UserType.Admin)
export class TablesController {
  constructor(private readonly tablesService: TablesService) { }

  @Post()
  /**
   * Creates a new table with the given `createTableDto` and associates it with
   * the building specified by the `dbName`.
   * @param createTableDto The information of the table to be created.
   * @param dbName The database name for the building where the table will be created.
   */
  add(@Body() createTableDto: CreateTableDto, @DbName() dbName: string) {
    return this.tablesService.create(createTableDto, dbName);
  }

  @Get()
  @Roles(UserType.Employer, UserType.Admin, UserType.Client)
  /**
   * Retrieves a list of all tables associated with the given `dbName`.
   * @param dbName The database name for the building that the tables are associated with.
   * @param status An optional filter for the status of the tables. If not set, all tables will be returned.
   * @returns A list of `Table` objects containing the information of the tables found.
   */
  findTablesOfBuilding(
    @DbName() dbName: string,
    @Query('status', new ParseEnumPipe(TableStatus, { optional: true }))
    status?: TableStatus,
  ) {
    return this.tablesService.findTablesOfBuilding(dbName, status);
  }

  @Get(':id/scan')
  @Roles(UserType.Employer, UserType.Client)
  /**
   * Scans the QR code of a table using its ID and verifies if it matches the specified building.
   * @param id The UUID of the table to be scanned.
   * @param dbName The database name to verify the table's association.
   * @throws UnauthorizedException if the table does not belong to the specified building.
   * @throws ConflictException if the table is currently occupied.
   * @returns The details of the table if the scan is successful.
   */
  scanQrCodeTable(
    @Param('id', ParseUUIDPipe) id: UUID,
    @DbName() dbName: string,
  ) {
    return this.tablesService.scanQrCodeTable(id, dbName);
  }

  @Get(':id/order')
  @Roles(UserType.Employer, UserType.Admin)
  getTableCurrentOrder(
    @Param('id', ParseUUIDPipe) id: UUID,
    @DbName() dbName: string,
  ) {
    return this.tablesService.getTableCurrentOrder(id, dbName);
  }
}
