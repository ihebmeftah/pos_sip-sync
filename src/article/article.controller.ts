import { Controller, Get, Post, Body, Param, ParseUUIDPipe, UseGuards } from '@nestjs/common';
import { ArticleService } from './article.service';
import { CreateArticleDto } from './dto/create-article.dto';
import { UUID } from 'crypto';
import { BuildingId } from 'src/decorators/building.decorator';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { BuildingIdGuard } from 'src/guards/building.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserRole } from 'src/enums/user.roles';

@Controller('article')
@UseGuards(JwtAuthGuard, RolesGuard, BuildingIdGuard)
export class ArticleController {
  constructor(private readonly articleService: ArticleService) { }

  @Post()
  @Roles(UserRole.Admin)
  create(@Body() createArticleDto: CreateArticleDto) {
    return this.articleService.create(createArticleDto);
  }

  @Get()
  findAll(
    @BuildingId() buildingId: UUID
  ) {
    return this.articleService.findAll(buildingId);
  }

  @Get('category/:categoryId')
  findArticleByCategoryId(
    @Param('categoryId', ParseUUIDPipe) categoryId: UUID
  ) {
    return this.articleService.findArticleByCategoryId(categoryId);
  }
}
