import { Module } from '@nestjs/common';
import { BuildingModule } from 'src/building/building.module';

import { CategoryService } from './category.service';
import { CategoryController } from './category.controller';

@Module({
  imports: [
    BuildingModule,
  ],
  controllers: [CategoryController],
  providers: [CategoryService],
  exports: [CategoryService],
})
export class CategoryModule { }
