import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article } from './entities/article.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { CategroyService } from 'src/categroy/categroy.service';
import { UUID } from 'crypto';

@Injectable()
export class ArticleService {
  constructor(
    @InjectRepository(Article)
    private readonly articleRepo: Repository<Article>,
    private readonly categroyService: CategroyService,
  ) { }
  async create(createArticleDto: CreateArticleDto) {
    const category = await this.categroyService.findOne(createArticleDto.categoryId);
    const create = await this.articleRepo.create(createArticleDto);
    create.category = category;
    return await this.articleRepo.save(create);
  }

  async findAll(buildingId: UUID) {
    return await this.articleRepo.find({
      where: {
        category: {
          building: { id: buildingId }
        }
      }, relations: {
        category: true
      }
    });
  }

  async findArticleByCategoryId(categoryId: UUID) {
    return await this.articleRepo.find({
      where: {
        category: { id: categoryId }
      },
      relations: {
        category: true
      }
    });
  }

  async findOne(id: UUID) {
    const article = await this.articleRepo.findOneBy({ id });
    if (!article) {
      throw new NotFoundException(`Article with this id ${id} not found`);;
    }
    return article;
  }


}
