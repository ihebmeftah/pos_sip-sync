import { Body, Controller, Get, Param, ParseUUIDPipe, Post, Req, UseGuards } from '@nestjs/common';
import { EmployerService } from './employer.service';
import { UUID } from 'crypto';
import { CreateEmployerDto } from './dto/create-employer.dto';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserRole } from 'src/enums/user.roles';
import { BuildingIdGuard } from 'src/guards/building.guard';
import { BuildingId } from 'src/decorators/building.decorator';


@Controller('employer')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
@Roles(UserRole.Admin)
export class EmployerController {
  constructor(private readonly employerService: EmployerService) { }

  @Post()
  create(
    @Body() createEmployerDto: CreateEmployerDto,
    @BuildingId() buildingId: UUID,
  ) {
    return this.employerService.create(createEmployerDto, buildingId);
  }

  @Get()
  findAll(
    @BuildingId() buildingId: UUID,
  ) {
    return this.employerService.findAll(buildingId);
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: UUID) {
    return this.employerService.findOne(id);
  }
}
