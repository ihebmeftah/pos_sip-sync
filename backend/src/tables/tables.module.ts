import { forwardRef, Module } from '@nestjs/common';
import { TablesService } from './tables.service';
import { TablesController } from './tables.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BuildingModule } from 'src/building/building.module';
import { Table } from './entities/table.entity';
import { OrderModule } from 'src/order/order.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Table]),
    BuildingModule,
    forwardRef(() => OrderModule),
  ],
  controllers: [TablesController],
  providers: [TablesService],
  exports: [TablesService]
})
export class TablesModule { }
