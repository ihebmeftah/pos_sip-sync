import { Body, Controller, Get, Param, ParseUUIDPipe, Post, UploadedFiles, UseGuards, UseInterceptors } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { RolesGuard } from 'src/guards/roles.guard';
import { UUID } from 'crypto';
import { CreateUserDto } from './dto/create-user.dto';
import { CustomFileUploadInterceptor } from 'src/utils/custom-file-upload';
import { DbNameGuard } from 'src/guards/dbname.guard';
import { DbName } from 'src/decorators/building.decorator';

@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard, DbNameGuard)
@Roles(UserType.Admin)
export class UsersController {
  constructor(private readonly usersService: UsersService) { }

  @Get('employers')
  findEmployers(
    @DbName() dbName: string
  ) {
    return this.usersService.findEmployers(dbName);
  }
  @Get('employers/:id')
  @Roles(UserType.Employer)
  findEmployerById(
    @Param('id', ParseUUIDPipe) id: UUID,
  ) {
    return this.usersService.findEmployerById(id);
  }
  @Post('employers/create')
  @UseInterceptors(
    CustomFileUploadInterceptor([
      { name: 'photo', maxCount: 1 },
    ], './uploads/employers')
  )
  createEmployer(
    @DbName() dbName: UUID,
    @Body() createEmployerDto: CreateUserDto,
    @UploadedFiles() files: {
      photo?: Express.Multer.File
    }
  ) {
    if (files.photo) {
      createEmployerDto.photo = files.photo.path;
    }
    return this.usersService.createEmployer(createEmployerDto, dbName);
  }
}
