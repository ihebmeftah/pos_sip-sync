import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateCategroyDto } from './dto/create-categroy.dto';
import { UpdateCategroyDto } from './dto/update-categroy.dto';
import { Repository } from 'typeorm';
import { Categroy } from './entities/categroy.entity';
import { BuildingService } from 'src/building/building.service';
import { UUID } from 'crypto';
import { RepositoryFactory } from 'src/database/repository-factory.service';

@Injectable()
export class CategroyService {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
    private readonly buildingService: BuildingService,
  ) { }

  async create(createCategroyDto: CreateCategroyDto, dbName: string) {
    const categroyRepo = await this.repositoryFactory.getRepository(dbName, Categroy);
    const building = await this.buildingService.findByDbName(dbName);

    const ExistName = await categroyRepo.findOneBy({
      name: createCategroyDto.name,
      building: { id: building.id }
    });

    if (ExistName) {
      throw new ConflictException(`Category with name ${createCategroyDto.name} already exists`);
    }

    const create = await categroyRepo.create(createCategroyDto);
    create.building = building;
    return await categroyRepo.save(create);
  }

  async findAllByDbName(dbName: string) {
    const categroyRepo = await this.repositoryFactory.getRepository(dbName, Categroy);
    const building = await this.buildingService.findByDbName(dbName);

    return await categroyRepo.find({
      where: {
        building: { id: building.id }
      }
    });
  }

  async findOne(id: UUID, dbName: string) {
    const categroyRepo = await this.repositoryFactory.getRepository(dbName, Categroy);
    const category = await categroyRepo.findOneBy({ id });

    if (!category) {
      throw new NotFoundException(`Category with id ${id} not found`);
    }
    return category;
  }
}
