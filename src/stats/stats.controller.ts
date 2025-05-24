import { Controller, Get, UseGuards } from '@nestjs/common';
import { StatsService } from './stats.service';
import { OrderService } from '../order/order.service';
import { TablesService } from 'src/tables/tables.service';
import { UUID } from 'crypto';
import { BuildingId } from 'src/decorators/building.decorator';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { BuildingIdGuard } from 'src/guards/building.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserRole } from 'src/enums/user.roles';
import { CustomerService } from 'src/customer/customer.service';

@Controller('stats')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
@Roles(UserRole.Admin)
export class StatsController {
  constructor(
    private readonly statsService: StatsService,
    private readonly orderService: OrderService,
    private readonly tablesService: TablesService,
    private readonly customerService: CustomerService,
  ) { }

  @Get()
  async getStats(
    @BuildingId() buildingId: UUID,
  ) {
    const orders = await this.orderService.mostSelledArticles(buildingId);
    const orderNb = await this.orderService.totalOrderNb(buildingId);
    const sales = await this.orderService.getSales(buildingId);
    const tables = await this.tablesService.getNbTableStatus(buildingId);
    return {
      sales,
      orderNb,
      top: orders,
      ...tables,
    };
  }
}
