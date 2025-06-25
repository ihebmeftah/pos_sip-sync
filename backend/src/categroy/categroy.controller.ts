import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe, UseGuards, UseInterceptors, UploadedFiles } from '@nestjs/common';
import { CategroyService } from './categroy.service';
import { CreateCategroyDto } from './dto/create-categroy.dto';
import { UpdateCategroyDto } from './dto/update-categroy.dto';
import { UUID } from 'crypto';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserRole } from 'src/enums/user.roles';
import { RolesGuard } from 'src/guards/roles.guard';
import { BuildingId } from 'src/decorators/building.decorator';
import { BuildingIdGuard } from 'src/guards/building.guard';
import { CustomFileUploadInterceptor } from 'src/utils/custom-file-upload';

@Controller('categroy')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
export class CategroyController {
  constructor(private readonly categroyService: CategroyService) { }

  @Post()
  @Roles(UserRole.Admin)
  @UseInterceptors(
    CustomFileUploadInterceptor([
      { name: 'image', maxCount: 1 },
    ], './uploads/categroy')
  )
  create(
    @Body() createCategroyDto: CreateCategroyDto,
    @BuildingId() buildingId: UUID,
    @UploadedFiles() files: { image?: Express.Multer.File[] }
  ) {
    if (files.image && files.image.length > 0) {
      createCategroyDto.image = files.image[0].path;
    }
    return this.categroyService.create(createCategroyDto, buildingId);
  }

  @Get()
  findAll(
    @BuildingId() buildingId: UUID
  ) {
    return this.categroyService.findAllByBuildingId(buildingId);
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: UUID) {
    return this.categroyService.findOne(id);
  }
}
