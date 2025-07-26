import { Module } from '@nestjs/common';
import { BuildingModule } from 'src/building/building.module';
import { DatabaseModule } from 'src/database/database.module';
import { CategoryService } from './category.service';
import { CategoryController } from './category.controller';

@Module({
  imports: [
    DatabaseModule,
    BuildingModule,
  ],
  controllers: [CategoryController],
  providers: [CategoryService],
  exports: [CategoryService],
})
export class CategoryModule { }
