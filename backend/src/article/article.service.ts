import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article } from './entities/article.entity';
import { CategoryService } from 'src/category/category.service';
import { UUID } from 'crypto';
import { RepositoryFactory } from 'src/database/repository-factory.service';
import { In } from 'typeorm';

@Injectable()
export class ArticleService {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
    private readonly categoryService: CategoryService,
  ) { }

  async create(createArticleDto: CreateArticleDto, dbName: string) {
    const articleRepo = await this.repositoryFactory.getRepository(dbName, Article);
    const category = await this.categoryService.findOne(createArticleDto.categoryId, dbName);
    const create = articleRepo.create(createArticleDto);
    create.category = category;
    return await articleRepo.save(create);
  }

  async findAll(dbName: string, categoryId?: UUID) {
    const articleRepo = await this.repositoryFactory.getRepository(dbName, Article);
    return await articleRepo.find({
      where: {
        category: categoryId && { id: categoryId }
      },
      relations: {
        category: true
      }
    });
  }

  async findArticleByCategoryId(CategoryId: UUID, dbName: string) {
    const articleRepo = await this.repositoryFactory.getRepository(dbName, Article);
    return await articleRepo.find({
      where: {
        category: { id: CategoryId }
      },
      relations: {
        category: true
      }
    });
  }

  async findOne(id: UUID, dbName: string) {
    const articleRepo = await this.repositoryFactory.getRepository(dbName, Article);
    const article = await articleRepo.findOne({
      where: { id }, relations: { category: true }, select: {
        id: true,
        name: true,
        price: true,
        category: {
          id: true,
          name: true,
        }
      }
    });
    if (!article) {
      throw new NotFoundException(`Article with this id ${id} not found`);;
    }
    return article;
  }

}
