import { TableStatus } from './../enums/table_status';
import { ConflictException, forwardRef, Inject, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { CreateTableDto } from './dto/create-table.dto';
import { Repository } from 'typeorm';
import { Table } from './entities/table.entity';
import { BuildingService } from 'src/building/building.service';
import { UUID } from 'crypto';
import { OrderService } from 'src/order/order.service';
import { RepositoryFactory } from 'src/database/repository-factory.service';

@Injectable()
export class TablesService {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
    @Inject(forwardRef(() => OrderService))
    private readonly orderService: OrderService
  ) { }

  async create(createTableDto: CreateTableDto, dbName: string) {
    const tableRepo = await this.repositoryFactory.getRepository(dbName, Table);
    const nbTablesOld = await tableRepo.count();
    const createdNewTables: Table[] = [];
    for (let i = nbTablesOld; i < createTableDto.nbTables + nbTablesOld; i++) {
      const newtable = new Table(`Table №${i + 1}`, createTableDto.seatsMax);
      const created = tableRepo.create(newtable);
      const saved = await tableRepo.save(created);
      createdNewTables.push(saved);
    }
    return createdNewTables.map((table) => {
      return {
        ...table,
        status: TableStatus.available,
      };
    });
  }

  async scanQrCodeTable(tableId: UUID, dbName: string) {
    const table = await this.findOne(tableId, dbName);
    if (table.status == TableStatus.occupied) {
      throw new ConflictException(`table with this id ${tableId} is occupied`);
    }
    return table;
  }

  async findOne(id: UUID, dbName: string): Promise<Table> {
    const tableRepo = await this.repositoryFactory.getRepository(dbName, Table);
    const table = await tableRepo.findOneBy({ id });
    if (!table) {
      throw new NotFoundException(`table with this id ${id} not found`);
    }
    const order = await this.orderService.checkTableHaveOrder(table.id, dbName);
    if (order) {
      table.status = TableStatus.occupied;
    }

    return table;
  }

  async findTablesOfBuilding(dbName: string, status?: TableStatus) {
    const tableRepo = await this.repositoryFactory.getRepository(dbName, Table);
    let tables = await tableRepo.find({
      order: {
        createdAt: 'ASC',
      },
    });
    for (const table of tables) {
      const order = await this.orderService.checkTableHaveOrder(table.id, dbName);
      if (order) {
        table.status = TableStatus.occupied;
      }
    }
    if (status) {
      tables = tables.filter((t) => t.status == status)
    }
    return tables
  }

  getTableCurrentOrder(tableId: UUID, dbName: string) {
    return this.orderService.checkTableHaveOrder(tableId, dbName);
  }
}
