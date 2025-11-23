import { forwardRef, Module } from '@nestjs/common';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { TablesModule } from 'src/tables/tables.module';
import { ArticleModule } from 'src/article/article.module';
import { UsersModule } from 'src/users/users.module';
import { DatabaseModule } from 'src/database/database.module';
import { BuildingModule } from 'src/building/building.module';

@Module({
  imports: [
    DatabaseModule,
    forwardRef(() => TablesModule),
    ArticleModule,
    UsersModule,
    BuildingModule
  ],
  controllers: [OrderController],
  providers: [OrderService],
  exports: [OrderService],
})
export class OrderModule { }
