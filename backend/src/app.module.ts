import { Module } from '@nestjs/common';
import { TablesModule } from './tables/tables.module';
import { BuildingModule } from './building/building.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { typeOrmAsyncConfig } from './database/data-source';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { ArticleModule } from './article/article.module';
import { OrderModule } from './order/order.module';
import { UsersModule } from './users/users.module';
import { CategoryModule } from './category/category.module';
import { CaisseModule } from './caisse/caisse.module';
import { DatabaseModule } from './database/database.module';
import { SeederModule } from './database/seeders/seeder.module';
import { StatsModule } from './stats/stats.module';
import { IngredientModule } from './ingredient/ingredient.module';

@Module({
  imports: [
    DatabaseModule,
    SeederModule,
    TypeOrmModule.forRootAsync(typeOrmAsyncConfig),
    ConfigModule.forRoot({
      envFilePath: ['env']
    }),
    CategoryModule,
    TablesModule,
    BuildingModule,
    AuthModule,
    ArticleModule,
    OrderModule,
    UsersModule,
    CaisseModule,
    StatsModule,
    IngredientModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule { }
