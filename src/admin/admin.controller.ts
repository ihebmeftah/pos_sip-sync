import { Controller, Get, Param, ParseUUIDPipe, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { UUID } from 'crypto';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserRole } from 'src/enums/user.roles';
import { BuildingIdGuard } from 'src/guards/building.guard';
import { RolesGuard } from 'src/guards/roles.guard';

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
@Roles(UserRole.Admin) export class AdminController {
  constructor(private readonly adminService: AdminService) { }

  @Get()
  findAll() {
    return this.adminService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: UUID) {
    return this.adminService.findOne(id);
  }
}
