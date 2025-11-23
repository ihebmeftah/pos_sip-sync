import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, ParseUUIDPipe, ParseEnumPipe, Query, UseInterceptors } from '@nestjs/common';
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

@Controller('order')
@UseGuards(JwtAuthGuard, RolesGuard, DbNameGuard)
export class OrderController {
    constructor(private readonly orderService: OrderService) { }

    @Get()
    async findOrderOfBuilding(
        @CurrUser() user: LoggedUser,
        @DbName() dbName: string,
        @Query(
            'status',
            new ParseEnumPipe(OrderStatus, { optional: true })) status?: OrderStatus,
    ) {
        if (user.type.includes(UserType.Employer)) {
            return await this.orderService.findOrderOfCurrUser(dbName, user, status);
        }
        return await this.orderService.findOrderOfBuilding(dbName, status);
    }

    @Get("table/:id")
    async findOrderOfTable(
        @DbName() dbName: string,
        @Param('id', ParseUUIDPipe) tableId: UUID,
        @Query(
            'status',
            new ParseEnumPipe(OrderStatus, { optional: true })) status?: OrderStatus,
    ) {
        return await this.orderService.findOrderOfTable(dbName, tableId, status);
    }
    @Get(":id")
    async getOrderById(
        @Param('id', ParseUUIDPipe) id: UUID,
        @DbName() dbName: string,
    ) {
        return await this.orderService.getOrderById(id, dbName);
    }

    @Post()
    @Roles(UserType.Employer, UserType.Admin)
    async passOrder(
        @Body() createOrderDto: CreateOrderDto,
        @CurrUser() user: LoggedUser,
        @DbName() dbName: string,
    ) {
        return await this.orderService.passOrder(createOrderDto, user, dbName);
    }

    @Patch("/:id/add-items")
    @Roles(UserType.Employer, UserType.Admin)
    async addItemsToOrder(
        @Param("id", ParseUUIDPipe) orderId: UUID,
        @Body('articlesIds') articlesIds: UUID[],
        @DbName() dbName: string,
        @CurrUser() user: LoggedUser,
    ) {
        return await this.orderService.addItemsToOrder(orderId, articlesIds, dbName, user);
    }

    @Patch("/:id/items/:itemId")
    @Roles(UserType.Employer, UserType.Admin)
    async payItemInOrder(
        @Param("id", ParseUUIDPipe) orderId: UUID,
        @Param("itemId", ParseUUIDPipe) itemId: UUID,
        @DbName() dbName: string,
        @CurrUser() user: LoggedUser,
    ) {
        return await this.orderService.payItemInOrder(orderId, itemId, dbName, user);
    }


    @Patch("/:id/payment")
    @Roles(UserType.Employer, UserType.Admin)
    async payOrder(
        @Param("id", ParseUUIDPipe) orderId: UUID,
        @DbName() dbName: string,
        @CurrUser() user: LoggedUser,
    ) {
        return await this.orderService.payOrder(orderId, dbName, user);
    }
}
