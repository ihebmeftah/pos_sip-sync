import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article } from './entities/article.entity';
import { CategoryService } from 'src/category/category.service';
import { UUID } from 'crypto';
import { RepositoryFactory } from 'src/database/repository-factory.service';

@Injectable()
export class ArticleService {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
    private readonly categoryService: CategoryService,
  ) { }

  async create(createArticleDto: CreateArticleDto, dbName: string) {
    const articleRepo = await this.repositoryFactory.getRepository(dbName, Article);
    const category = await this.categoryService.findOne(createArticleDto.categoryId, dbName);
    const create = await articleRepo.create(createArticleDto);
    create.category = category;
    return await articleRepo.save(create);
  }

  async findAll(dbName: string) {
    const articleRepo = await this.repositoryFactory.getRepository(dbName, Article);
    return await articleRepo.find({
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
    const article = await articleRepo.findOneBy({ id });
    if (!article) {
      throw new NotFoundException(`Article with this id ${id} not found`);;
    }
    return article;
  }
}
