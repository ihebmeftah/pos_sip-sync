import { Injectable } from '@nestjs/common';
import { CreateIngredientDto } from './dto/create-ingredient.dto';
import { UpdateIngredientDto } from './dto/update-ingredient.dto';
import { RepositoryFactory } from '../database/repository-factory.service';
import { Ingredient } from './entities/ingredient.entity';

@Injectable()
export class IngredientService {
  constructor(
    private readonly RepositoryFactory: RepositoryFactory,
  ) { }
  async create(createIngredientDto: CreateIngredientDto, dbName: string) {
    const ingredientRepository = await this.RepositoryFactory.getRepository(dbName, Ingredient);
    const createdIngraedient = ingredientRepository.create(createIngredientDto);
    return await ingredientRepository.save(createdIngraedient);
  }

  async findAll(dbname: string) {
    const ingredientRepository = await this.RepositoryFactory.getRepository(dbname, Ingredient);
    return await ingredientRepository.find();
  }

}
