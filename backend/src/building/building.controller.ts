import { Controller, Get, Post, Body, Param, UseGuards, ParseUUIDPipe, UseInterceptors, UploadedFiles } from '@nestjs/common';
import { BuildingService } from './building.service';
import { CreateBuildingDto } from './dto/create-building.dto';
import { Roles } from 'src/decorators/roles.decorator';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { UserType } from 'src/enums/user.roles';
import { UUID } from 'crypto';
import { CurrUser } from 'src/decorators/curr-user.decorator';
import { LoggedUser } from 'src/auth/strategy/loggeduser';
import { CustomFileUploadInterceptor } from 'src/utils/custom-file-upload';

@Controller('building')
@Roles(UserType.Admin)
@UseGuards(JwtAuthGuard, RolesGuard)
export class BuildingController {
  constructor(private readonly buildingService: BuildingService) { }

  @Post()
  @UseInterceptors(
    CustomFileUploadInterceptor([
      { name: 'logo', maxCount: 1 },
      { name: 'photos', maxCount: 10 },
    ], './uploads/building')
  )
  create(
    @Body() createBuildingDto: CreateBuildingDto,
    @CurrUser() user: LoggedUser,
    @UploadedFiles() files: {
      logo?: Express.Multer.File;
      photos?: Express.Multer.File[]
    }
  ) {
    const userId: UUID = user.id;
    if (files.logo) {
      createBuildingDto.logo = files.logo[0].path;
    }
    if (files.photos) {
      createBuildingDto.photos = files.photos.map(f => f.path);
    }
    return this.buildingService.create(userId, createBuildingDto);
  }

  @Get()
  @Roles(UserType.Admin, UserType.Client)
  findAll(
    @CurrUser() user: LoggedUser,
  ) {
    if (user.type.includes(UserType.Admin)) {
      return this.buildingService.findAllOfOwner(user.id);
    }
    return this.buildingService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: UUID) {
    return this.buildingService.findOne(id);
  }

  @Get(':id/status')
  async getStatus(@Param('id', ParseUUIDPipe) id: UUID) {
    const building = await this.buildingService.findOne(id);
    return {
      isOpen: this.buildingService.isOpen(building),
      openingTime: this.buildingService.formatOpeningTime(building),
      closingTime: this.buildingService.formatClosingTime(building),
      minutesUntilOpening: this.buildingService.getMinutesUntilOpening(building),
      minutesUntilClosing: this.buildingService.getMinutesUntilClosing(building),
    };
  }
}
