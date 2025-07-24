import { Module } from '@nestjs/common';
import { CategroyModule } from './categroy/categroy.module';
import { TablesModule } from './tables/tables.module';
import { BuildingModule } from './building/building.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { typeOrmAsyncConfig } from './database/data-source';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { ArticleModule } from './article/article.module';
import { OrderModule } from './order/order.module';
import { UsersModule } from './users/users.module';
import { HistoryModule } from './history/history.module';

@Module({
  imports: [
    TypeOrmModule.forRootAsync(typeOrmAsyncConfig),
    ConfigModule.forRoot({
      envFilePath: ['dev.env']
    }),
    CategroyModule,
    TablesModule,
    BuildingModule,
    AuthModule,
    ArticleModule,
    OrderModule,
    UsersModule,
    HistoryModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule { }
