import { TableStatus } from './../enums/table_status';
import { ConflictException, forwardRef, Inject, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { CreateTableDto } from './dto/create-table.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Table } from './entities/table.entity';
import { BuildingService } from 'src/building/building.service';
import { UUID } from 'crypto';
import { OrderService } from 'src/order/order.service';

@Injectable()
export class TablesService {
  constructor(
    @InjectRepository(Table)
    private readonly tableRepo: Repository<Table>,
    private readonly buildingService: BuildingService,
    @Inject(forwardRef(() => OrderService))
    private readonly orderService: OrderService

  ) { }
  async create(createTableDto: CreateTableDto, buildingId: UUID) {
    const building = await this.buildingService.findOne(buildingId);
    const nbTablesOld = await this.tableRepo.count({ where: { building: { id: buildingId } } });
    const createdNewTables: Table[] = [];
    for (let i = nbTablesOld; i < createTableDto.nbTables + nbTablesOld; i++) {
      const newtable = new Table(`Table-${i + 1}.${building.id}`, createTableDto.seatsMax, building);
      const created = this.tableRepo.create(newtable);
      const saved = await this.tableRepo.save(created);
      createdNewTables.push(saved);
    }
    return createdNewTables.map((table) => {
      return {
        ...table,
        status: TableStatus.available,
      };
    });
  }
  async scanQrCodeTable(tableId: UUID, buildingId: UUID) {
    const table = await this.findOne(tableId);
    const tableBuildingId = table.name.split('.')[1];
    if (tableBuildingId != buildingId) {
      throw new UnauthorizedException(`Building not match`);
    }
    if (table.status == TableStatus.occupied) {
      throw new ConflictException(`table with this id ${tableId} is occupied`);
    }
    return table;
  }
  async findOne(id: UUID): Promise<Table> {
    const table = await this.tableRepo.findOneBy({ id });
    if (!table) {
      throw new NotFoundException(`table with this id ${id} not found`);
    }
    const order = await this.orderService.checkTableHaveOrder(table.id);
    if (order) {
      table.status = TableStatus.occupied;
    }
    return table;
  }

  async findTablesOfBuilding(buildingId: UUID, status?: TableStatus) {
    let tables = await this.tableRepo.find({
      where: {
        building: { id: buildingId },
      },
      order: {
        createdAt: 'ASC',
      },
    });
    for (const table of tables) {
      const order = await this.orderService.checkTableHaveOrder(table.id);
      if (order) {
        table.status = TableStatus.occupied;
      }
    }
    if (status) {
      tables = tables.filter((t) => t.status == status)
    }
    return tables
  }

  getTableCurrentOrder(tableId: UUID) {
    return this.orderService.checkTableHaveOrder(tableId);
  }
}
