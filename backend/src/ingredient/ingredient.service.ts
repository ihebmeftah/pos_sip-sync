import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateIngredientDto } from './dto/create-ingredient.dto';
import { UpdateIngredientDto } from './dto/update-ingredient.dto';
import { RepositoryFactory } from '../database/repository-factory.service';
import { Ingredient } from './entities/ingredient.entity';
import { UUID } from 'crypto';

@Injectable()
export class IngredientService {
  constructor(
    private readonly RepositoryFactory: RepositoryFactory,
  ) { }
  async create(createIngredientDto: CreateIngredientDto, dbName: string) {
    const ingredientRepository = await this.RepositoryFactory.getRepository(dbName, Ingredient);
    const exist = await ingredientRepository.findOne({ where: { name: createIngredientDto.name } });
    if (exist) {
      throw new ConflictException(`Ingredient with name ${createIngredientDto.name} already exists`);
    }
    const createdIngraedient = ingredientRepository.create(createIngredientDto);
    return await ingredientRepository.save(createdIngraedient);
  }

  async findAll(dbname: string) {
    const ingredientRepository = await this.RepositoryFactory.getRepository(dbname, Ingredient);
    return await ingredientRepository.find();
  }
  async getIngredientById(id: UUID, dbname: string) {
    const ingredientRepository = await this.RepositoryFactory.getRepository(dbname, Ingredient);
    const ingredient = await ingredientRepository.findOne({ where: { id } });
    if (!ingredient) {
      throw new NotFoundException(`Ingredient with ID ${id} not found`);
    }
    return ingredient;
  }
}