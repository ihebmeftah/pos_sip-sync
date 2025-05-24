import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Req, ParseUUIDPipe, UploadedFile, UploadedFiles } from '@nestjs/common';
import { BuildingService } from './building.service';
import { CreateBuildingDto } from './dto/create-building.dto';
import { UpdateBuildingDto } from './dto/update-building.dto';
import { Roles } from 'src/decorators/roles.decorator';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { UserRole } from 'src/enums/user.roles';
import { UUID } from 'crypto';

@Controller('building')
@Roles(UserRole.Admin)
@UseGuards(JwtAuthGuard, RolesGuard)
export class BuildingController {
  constructor(private readonly buildingService: BuildingService) { }

  @Post()
  create(
    @Body() createBuildingDto: CreateBuildingDto,
    @Req() req: any,
  ) {
    const userId: UUID = req.user.id;
    return this.buildingService.create(userId,
      createBuildingDto)
  }

  @Get()
  @Roles(UserRole.Admin, UserRole.Client)
  findAll(
    @Req() req: any,
  ) {
    const role = req.user.role;
    if (role == UserRole.Admin) {
      const adminId: UUID = req.user.id;
      return this.buildingService.findAllOfOwner(adminId);
    }
    return this.buildingService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: UUID) {
    return this.buildingService.findOne(id);
  }


}
