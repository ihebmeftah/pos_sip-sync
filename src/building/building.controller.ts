import { Controller, Get, Post, Body, Param, UseGuards, ParseUUIDPipe } from '@nestjs/common';
import { BuildingService } from './building.service';
import { CreateBuildingDto } from './dto/create-building.dto';
import { Roles } from 'src/decorators/roles.decorator';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { UserRole } from 'src/enums/user.roles';
import { UUID } from 'crypto';
import { CurrUser } from 'src/decorators/curr-user.decorator';
import { LoggedUser } from 'src/auth/strategy/loggeduser';

@Controller('building')
@Roles(UserRole.Admin)
@UseGuards(JwtAuthGuard, RolesGuard)
export class BuildingController {
  constructor(private readonly buildingService: BuildingService) { }

  @Post()
  create(
    @Body() createBuildingDto: CreateBuildingDto,
    @CurrUser() user: LoggedUser,
  ) {
    const userId: UUID = user.id;
    return this.buildingService.create(userId,
      createBuildingDto)
  }

  @Get()
  @Roles(UserRole.Admin, UserRole.Client)
  findAll(
    @CurrUser() user: LoggedUser,
  ) {
    if (user.role == UserRole.Admin) {
      return this.buildingService.findAllOfOwner(user.id);
    }
    return this.buildingService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: UUID) {
    return this.buildingService.findOne(id);
  }
}
