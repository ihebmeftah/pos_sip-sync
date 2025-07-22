import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, ParseUUIDPipe, Req, ParseEnumPipe, Query } from '@nestjs/common';
import { OrderService } from './order.service';

import { BuildingIdGuard } from 'src/guards/building.guard';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { BuildingId } from 'src/decorators/building.decorator';
import { UUID } from 'crypto';
import { CreateOrderDto } from './dto/create-order.dto';
import { RolesGuard } from 'src/guards/roles.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { LoggedUser } from 'src/auth/strategy/loggeduser';
import { CurrUser } from 'src/decorators/curr-user.decorator';
import { OrderStatus } from 'src/enums/order_status';

@Controller('order')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
export class OrderController {
    constructor(private readonly orderService: OrderService) { }

    @Get()
    async findOrderOfBuilding(
        @BuildingId() buildingId: UUID,
        @Query(
            'status',
            new ParseEnumPipe(OrderStatus, { optional: true })) status?: OrderStatus,
    ) {
        return await this.orderService.findOrderOfBuilding(buildingId, status);
    }

    @Get(":id")
    async getOrderById(
        @Param('id', ParseUUIDPipe) id: UUID,
    ) {
        return await this.orderService.getOrderById(id);
    }

    @Delete(":id")
    async deleteOrder(
        @Param('id', ParseUUIDPipe) id: UUID,
    ) {
        return await this.orderService.deleteOrder(id);
    }

    @Post()
    async passOrder(
        @Body() createOrderDto: CreateOrderDto,
        @CurrUser() user: LoggedUser,
    ) {
        return await this.orderService.passOrder(createOrderDto, user);
    }

    @Patch("/item/:id")
    @Roles(UserType.Admin)
    async payOrderItem(
        @Param("id", ParseUUIDPipe) orderItemId: UUID,
    ) {
        return await this.orderService.payOrderItem(orderItemId);
    }

    @Patch("/:id/pay-items")
    @Roles(UserType.Admin)
    async payAllItemsOfOrder(
        @Param("id", ParseUUIDPipe) orderId: UUID
    ) {
        return await this.orderService.payAllitemsOfOrder(orderId);
    }
}
