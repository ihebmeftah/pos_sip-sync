import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { CreateBuildingDto } from './dto/create-building.dto';
import { Repository } from 'typeorm';
import { Building } from './entities/building.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { UUID } from 'crypto';
import { UsersService } from 'src/users/users.service';
import { DatabaseConnectionService } from 'src/database/database-connection.service';

@Injectable()
export class BuildingService {
  constructor(
    @InjectRepository(Building)
    private readonly buildingRepo: Repository<Building>,
    private readonly userService: UsersService,
    private readonly databaseConnectionService: DatabaseConnectionService,
  ) { }

  async create(ownerId: UUID,
    createBuildingDto: CreateBuildingDto,
  ): Promise<Building> {
    const admin = await this.userService.findOneAdmin(ownerId);

    // Check if dbName already exists
    const existingBuilding = await this.buildingRepo.findOne({
      where: { dbName: createBuildingDto.dbName }
    });
    if (existingBuilding) {
      throw new ConflictException(`Database name ${createBuildingDto.dbName} already exists`);
    }

    // Create the database for this building
    await this.databaseConnectionService.createDatabase(createBuildingDto.dbName);

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
        admin: { user: { id: adminId } },
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

  async findByDbName(dbName: string): Promise<Building> {
    const building = await this.buildingRepo.findOne({
      where: { dbName }
    });
    if (!building) {
      throw new NotFoundException(`Building with database name ${dbName} not found`);
    }
    return building;
  }
}
