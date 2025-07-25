import { Body, Controller, Get, Param, ParseUUIDPipe, Post, UploadedFiles, UseGuards, UseInterceptors } from '@nestjs/common';
import { UsersService } from './users.service';
import { AuthGuard } from '@nestjs/passport';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { BuildingIdGuard } from 'src/guards/building.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { BuildingId } from 'src/decorators/building.decorator';
import { UUID } from 'crypto';
import { CreateUserDto } from './dto/create-user.dto';
import { CustomFileUploadInterceptor } from 'src/utils/custom-file-upload';

@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
@Roles(UserType.Admin)
export class UsersController {
  constructor(private readonly usersService: UsersService) { }

  @Get('employers')
  getAllEmployers(
    @BuildingId() buildingId: UUID,
  ) {
    return this.usersService.findAllEmployers(buildingId);
  }
  @Get('employers/:id')
  @Roles(UserType.Employer)
  getOneEmployer(
    @Param('id', ParseUUIDPipe) id: UUID
  ) {
    return this.usersService.findOneEmployer(id);
  }
  @Post('employers/create')
  @UseInterceptors(
    CustomFileUploadInterceptor([
      { name: 'photo', maxCount: 1 },
    ], './uploads/employers')
  )
  createEmployer(
    @BuildingId() buildingId: UUID,
    @Body() createEmployerDto: CreateUserDto,
    @UploadedFiles() files: {
      photo?: Express.Multer.File
    }
  ) {
    if (files.photo) {
      createEmployerDto.photo = files.photo.path;
    }
    return this.usersService.createEmployer(createEmployerDto, buildingId);
  }
}
