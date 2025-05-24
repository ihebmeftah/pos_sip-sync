import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateBuildingDto } from './dto/create-building.dto';
import { UpdateBuildingDto } from './dto/update-building.dto';
import { Repository } from 'typeorm';
import { Building } from './entities/building.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { UUID } from 'crypto';
import { AdminService } from 'src/admin/admin.service';

@Injectable()
export class BuildingService {
  constructor(
    @InjectRepository(Building)
    private readonly buildingRepo: Repository<Building>,
    private readonly adminservice: AdminService,
  ) { }
  async create(ownerId: UUID, 
    createBuildingDto: CreateBuildingDto, 
 ): Promise<Building> {
    const admin = await this.adminservice.findOne(ownerId);
    const building = await this.buildingRepo.create(createBuildingDto);
    building.admin = admin;
    return this.buildingRepo.save(building);
  }

  findAll(): Promise<Building[]> {
    return this.buildingRepo.find();
  }
  findAllOfOwner(adminId: UUID): Promise<Building[]> {
    return this.buildingRepo.findBy(
      {
        admin: { id: adminId },
      },
    );
  }
  async findOne(id: UUID): Promise<Building> {
    const building = await this.buildingRepo.findOneBy({ id });
    if (!building) {
      throw new NotFoundException(`Building with this id ${id} not found`);;
    }
    return building;
  }


}
