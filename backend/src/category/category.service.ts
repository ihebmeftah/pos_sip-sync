import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';

import { UUID } from 'crypto';
import { RepositoryFactory } from 'src/database/repository-factory.service';
import { Category } from './entities/category.entity';
import { CreateCategoryDto } from './dto/create-category.dto';

@Injectable()
export class CategoryService {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
  ) { }

  async create(createCategoryDto: CreateCategoryDto, dbName: string) {
    const categoryRepo = await this.repositoryFactory.getRepository(dbName, Category);
    const existingCategory = await categoryRepo.findOneBy({ name: createCategoryDto.name });
    if (existingCategory) {
      throw new ConflictException(`Category with name ${createCategoryDto.name} already exists`);
    }
    const create = categoryRepo.create(createCategoryDto);
    return await categoryRepo.save(create);
  }

  async findAllByDbName(dbName: string) {
    const categoryRepo = await this.repositoryFactory.getRepository(dbName, Category);
    return await categoryRepo.find();
  }

  async findOne(id: UUID, dbName: string) {
    const categoryRepo = await this.repositoryFactory.getRepository(dbName, Category);
    const category = await categoryRepo.findOneBy({ id });
    if (!category) {
      throw new NotFoundException(`Category with id ${id} not found`);
    }
    return category;
  }
}
