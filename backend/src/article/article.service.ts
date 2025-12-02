import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateArticleDto } from './dto/create-article.dto';
import { Article } from './entities/article.entity';
import { CategoryService } from 'src/category/category.service';
import { UUID } from 'crypto';
import { RepositoryFactory } from 'src/database/repository-factory.service';
import { ArticleCompo } from './entities/article-compo.entity';
import { IngredientService } from 'src/ingredient/ingredient.service';
import { AddComposArticleDto } from './dto/add-compos-article.dto';

@Injectable()
export class ArticleService {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
    private readonly categoryService: CategoryService,
    private readonly ingredientService: IngredientService,
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
      },
      select: {
        compositions: false,
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
      where: { id },
      relations: { category: true },
      select: {
        id: true,
        name: true,
        price: true,
        compositions: {
          id: true,
          quantity: true,
          Ingredient: true,
        },
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
  async addComposToArticle(db: string, compos: AddComposArticleDto, articleId: UUID) {
    const articleCompoRepo = await this.repositoryFactory.getRepository(db, ArticleCompo);
    const article = await this.findOne(articleId, db);
    const composToSave: ArticleCompo[] = [];
    for (const compoDto of compos.compos) {
      const ingredient = await this.ingredientService.getIngredientById(compoDto.ingradientId, db);
      const articleCompo = new ArticleCompo();
      articleCompo.Ingredient = ingredient;
      articleCompo.quantity = compoDto.quantity;
      //      articleCompo.unit = compoDto.unit;
      articleCompo.article = article;
      const create = articleCompoRepo.create(articleCompo);
      composToSave.push(create);
    }
    return await articleCompoRepo.save(composToSave);
  }
}
