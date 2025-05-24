import { Module } from '@nestjs/common';
import { StatsService } from './stats.service';
import { StatsController } from './stats.controller';
import { OrderModule } from 'src/order/order.module';
import { TablesModule } from 'src/tables/tables.module';
import { CustomerModule } from 'src/customer/customer.module';

@Module({
  imports: [
    OrderModule,
    TablesModule,
    CustomerModule,
  ],
  controllers: [StatsController],
  providers: [StatsService],
})
export class StatsModule { }
