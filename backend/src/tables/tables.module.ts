import { forwardRef, Module } from '@nestjs/common';
import { TablesService } from './tables.service';
import { TablesController } from './tables.controller';
import { BuildingModule } from 'src/building/building.module';
import { OrderModule } from 'src/order/order.module';
import { DatabaseModule } from 'src/database/database.module';

@Module({
  imports: [
    BuildingModule,
    DatabaseModule,
    forwardRef(() => OrderModule),
  ],
  controllers: [TablesController],
  providers: [TablesService],
  exports: [TablesService]
})
export class TablesModule { }
