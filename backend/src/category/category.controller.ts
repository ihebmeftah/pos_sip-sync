import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe, UseGuards, UseInterceptors, UploadedFiles } from '@nestjs/common';
import { UUID } from 'crypto';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { RolesGuard } from 'src/guards/roles.guard';
import { CustomFileUploadInterceptor } from 'src/utils/custom-file-upload';
import { DbNameGuard } from 'src/guards/dbname.guard';
import { DbName } from 'src/decorators/building.decorator';
import { CategoryService } from './category.service';
import { CreateCategoryDto } from './dto/create-category.dto';

@Controller('Category')
@UseGuards(JwtAuthGuard, RolesGuard, DbNameGuard)
export class CategoryController {
  constructor(private readonly CategoryService: CategoryService) { }

  @Post()
  @Roles(UserType.Admin)
  @UseInterceptors(
    CustomFileUploadInterceptor([
      { name: 'image', maxCount: 1 },
    ], './uploads/category')
  )
  create(
    @Body() createCategoryDto: CreateCategoryDto,
    @DbName() dbName: string,
    @UploadedFiles() files: { image?: Express.Multer.File[] }
  ) {
    if (files.image && files.image.length > 0) {
      createCategoryDto.image = files.image[0].path;
    }
    return this.CategoryService.create(createCategoryDto, dbName);
  }

  @Get()
  findAll(
    @DbName() dbName: string
  ) {
    return this.CategoryService.findAllByDbName(dbName);
  }

  @Get(':id')
  findOne(
    @Param('id', ParseUUIDPipe) id: UUID,
    @DbName() dbName: string
  ) {
    return this.CategoryService.findOne(id, dbName);
  }
}
