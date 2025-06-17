import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateCategroyDto } from './dto/create-categroy.dto';
import { UpdateCategroyDto } from './dto/update-categroy.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Categroy } from './entities/categroy.entity';
import { BuildingService } from 'src/building/building.service';
import { UUID } from 'crypto';

@Injectable()
export class CategroyService {
  constructor(
    @InjectRepository(Categroy)
    private readonly categroyRepo: Repository<Categroy>,
    private readonly buildingService: BuildingService,
  ) { }
  async create(createCategroyDto: CreateCategroyDto, buildingId: UUID) {
    const building = await this.buildingService.findOne(buildingId);
    const ExistName = await this.categroyRepo.findOneBy({ name: createCategroyDto.name, building: { id: buildingId } });
    if (ExistName) {
      throw new ConflictException(`Category with name ${createCategroyDto.name} already exists`);
    }
    const create = await this.categroyRepo.create(createCategroyDto);
    create.building = building;
    return await this.categroyRepo.save(create);

  }

  async findAllByBuildingId(id: UUID) {
    await this.buildingService.findOne(id);
    return await this.categroyRepo.find({
      where: {
        building: { id }
      }
    });
  }

  async findOne(id: UUID) {
    const category = await this.categroyRepo.findOneBy({ id });
    if (!category) {
      throw new NotFoundException(`Category with id ${id} not found`);
    }
    return category
  }
}
