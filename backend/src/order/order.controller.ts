import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, ParseUUIDPipe, Req, ParseEnumPipe, Query, UseInterceptors } from '@nestjs/common';
import { OrderService } from './order.service';
import { DbNameGuard } from 'src/guards/dbname.guard';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { DbName } from 'src/decorators/building.decorator';
import { UUID } from 'crypto';
import { CreateOrderDto } from './dto/create-order.dto';
import { RolesGuard } from 'src/guards/roles.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { LoggedUser } from 'src/auth/strategy/loggeduser';
import { CurrUser } from 'src/decorators/curr-user.decorator';
import { OrderStatus } from 'src/enums/order_status';
import { HistoryInterceptor } from '../history/history.interceptor';

@Controller('order')
@UseGuards(JwtAuthGuard, RolesGuard, DbNameGuard)
export class OrderController {
    constructor(private readonly orderService: OrderService) { }

    @Get()
    async findOrderOfBuilding(
        @DbName() dbName: string,
        @Query(
            'status',
            new ParseEnumPipe(OrderStatus, { optional: true })) status?: OrderStatus,
    ) {
        return await this.orderService.findOrderOfBuilding(dbName, status);
    }

    @Get(":id")
    async getOrderById(
        @Param('id', ParseUUIDPipe) id: UUID,
        @DbName() dbName: string,
    ) {
        return await this.orderService.getOrderById(id, dbName);
    }

    @Get(":id/history")
    async getOrderHistory(
        @Param('id', ParseUUIDPipe) id: UUID,
        @DbName() dbName: string,
    ) {
        return await this.orderService.getOrderHistory(id, dbName);
    }

    @Delete(":id")
    @UseInterceptors(HistoryInterceptor)
    async deleteOrder(
        @Param('id', ParseUUIDPipe) id: UUID,
        @DbName() dbName: string,
    ) {
        return await this.orderService.deleteOrder(id, dbName);
    }

    @Post()
    @UseInterceptors(HistoryInterceptor)
    async passOrder(
        @Body() createOrderDto: CreateOrderDto,
        @CurrUser() user: LoggedUser,
        @DbName() dbName: string,
    ) {
        return await this.orderService.passOrder(createOrderDto, user, dbName);
    }

    @Patch("/item/:id")
    @Roles(UserType.Admin)
    @UseInterceptors(HistoryInterceptor)
    async payOrderItem(
        @Param("id", ParseUUIDPipe) orderItemId: UUID,
        @DbName() dbName: string,
    ) {
        return await this.orderService.payOrderItem(orderItemId, dbName);
    }

    @Patch("/:id/pay-items")
    @Roles(UserType.Admin)
    @UseInterceptors(HistoryInterceptor)
    async payAllItemsOfOrder(
        @Param("id", ParseUUIDPipe) orderId: UUID,
        @DbName() dbName: string,
    ) {
        return await this.orderService.payAllitemsOfOrder(orderId, dbName);
    }
}
