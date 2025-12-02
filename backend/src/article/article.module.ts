import { Module } from '@nestjs/common';
import { ArticleService } from './article.service';
import { ArticleController } from './article.controller';
import { CategoryModule } from 'src/category/category.module';
import { IngredientModule } from 'src/ingredient/ingredient.module';


@Module({
  imports: [
    CategoryModule,
    IngredientModule,
  ],
  controllers: [ArticleController],
  providers: [ArticleService],
  exports: [ArticleService]
})
export class ArticleModule { }