import { Controller, Get, Post, Body, Param, ParseUUIDPipe, UseGuards, UseInterceptors, UploadedFiles, Query } from '@nestjs/common';
import { ArticleService } from './article.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { UUID } from 'crypto';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { CustomFileUploadInterceptor } from 'src/utils/custom-file-upload';
import { DbNameGuard } from 'src/guards/dbname.guard';
import { DbName } from 'src/decorators/building.decorator';
import { AddComposArticleDto } from './dto/add-compos-article.dto';

@Controller('article')
@UseGuards(JwtAuthGuard, RolesGuard, DbNameGuard)
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
    @DbName() dbName: string,
    @Query('categoryId', new ParseUUIDPipe({ optional: true })) categoryId: UUID
  ) {
    return this.articleService.findAll(dbName, categoryId);
  }
  @Get(':id')
  getArticleById(
    @Param('id', new ParseUUIDPipe) id: UUID,
    @DbName() dbName: string
  ) {
    return this.articleService.findOne(id, dbName);
  }

  @Get('Category/:CategoryId')
  findArticleByCategoryId(
    @Param('CategoryId', ParseUUIDPipe) CategoryId: UUID,
    @DbName() dbName: string
  ) {
    return this.articleService.findArticleByCategoryId(CategoryId, dbName);
  }

  @Post(":id/compos")
  @Roles(UserType.Admin)
  async addComposToArticle(
    @Param('id', new ParseUUIDPipe) id: UUID,
    @Body() addComposArticleDto: AddComposArticleDto,
    @DbName() dbName: string) {
    return await this.articleService.addComposToArticle(dbName, addComposArticleDto, id);
  }
}
