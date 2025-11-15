import { forwardRef, Module } from '@nestjs/common';
import { TablesService } from './tables.service';
import { TablesController } from './tables.controller';
import { BuildingModule } from 'src/building/building.module';
import { OrderModule } from 'src/order/order.module';


@Module({
  imports: [BuildingModule, forwardRef(() => OrderModule)],
  controllers: [TablesController],
  providers: [TablesService],
  exports: [TablesService],
})
export class TablesModule { }
