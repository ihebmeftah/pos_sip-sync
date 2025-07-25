import { Controller, Get, Post, Body, Param, ParseUUIDPipe, UseGuards, UseInterceptors, UploadedFiles } from '@nestjs/common';
import { ArticleService } from './article.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { UUID } from 'crypto';
import { BuildingId, DbName } from 'src/decorators/building.decorator';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { BuildingIdGuard } from 'src/guards/building.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { CustomFileUploadInterceptor } from 'src/utils/custom-file-upload';

@Controller('article')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
export class ArticleController {
  constructor(private readonly articleService: ArticleService) { }

  @Post()
  @Roles(UserType.Admin)
  @UseInterceptors(
    CustomFileUploadInterceptor([
      { name: 'image', maxCount: 1 },
    ], './uploads/article')
  )
  create(
    @Body() createArticleDto: CreateArticleDto,
    @UploadedFiles() files: { image?: Express.Multer.File[] },
    @DbName() dbName: string
  ) {
    if (files.image && files.image.length > 0) {
      createArticleDto.image = files.image[0].path;
    }
    return this.articleService.create(createArticleDto, dbName);
  }

  @Get()
  findAll(
    @DbName() dbName: string
  ) {
    return this.articleService.findAll(dbName);
  }

  @Get('category/:categoryId')
  findArticleByCategoryId(
    @Param('categoryId', ParseUUIDPipe) categoryId: UUID,
    @DbName() dbName: string
  ) {
    return this.articleService.findArticleByCategoryId(categoryId, dbName);
  }
}
