import { Injectable, NotFoundException, ConflictException, Inject, forwardRef } from '@nestjs/common';
import { CreateBuildingDto } from './dto/create-building.dto';
import { Repository } from 'typeorm';
import { Building } from './entities/building.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { UUID } from 'crypto';
import { UsersService } from 'src/users/users.service';
import { DatabaseConnectionService } from 'src/database/database-connection.service';
import * as moment from 'moment';

@Injectable()
export class BuildingService {
  constructor(
    @InjectRepository(Building)
    private readonly buildingRepo: Repository<Building>,
    @Inject(forwardRef(() => UsersService))
    private readonly userService: UsersService,
    private readonly databaseConnectionService: DatabaseConnectionService,
  ) { }

  async create(ownerId: UUID,
    createBuildingDto: CreateBuildingDto,
  ): Promise<Building> {
    const admin = await this.userService.findAdminById(ownerId);

    // Check if dbName already exists
    const existingBuilding = await this.buildingRepo.findOne({
      where: [
        { name: createBuildingDto.name },
        { dbName: createBuildingDto.dbName }]
    });
    if (existingBuilding) {
      throw new ConflictException(`Building with name ${createBuildingDto.name} already exists`);
    }

    // Create the database for this building
    await this.databaseConnectionService.createDatabase(createBuildingDto.dbName);

    // Convert ISO string dates to Date objects using moment
    const building = this.buildingRepo.create({
      ...createBuildingDto,
      openingTime: moment(createBuildingDto.openingTime).toDate(),
      closingTime: moment(createBuildingDto.closingTime).toDate(),
    });
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

  async findByDbName(dbName: string): Promise<Building> {
    const building = await this.buildingRepo.findOne({
      where: { dbName }
    });
    if (!building) {
      throw new NotFoundException(`Building with database name ${dbName} not found`);
    }
    return building;
  }

  /**
   * Check if the building is currently open based on opening and closing times
   */
  isOpen(building: Building): boolean {
    const now = moment();
    const openingTime = moment(building.openingTime);
    const closingTime = moment(building.closingTime);

    return now.isBetween(openingTime, closingTime);
  }

  /**
   * Format opening time using moment
   */
  formatOpeningTime(building: Building, format: string = 'HH:mm A'): string {
    return moment(building.openingTime).format(format);
  }

  /**
   * Format closing time using moment
   */
  formatClosingTime(building: Building, format: string = 'HH:mm A'): string {
    return moment(building.closingTime).format(format);
  }

  /**
   * Get time until opening (in minutes)
   */
  getMinutesUntilOpening(building: Building): number {
    const now = moment();
    const openingTime = moment(building.openingTime);
    return openingTime.diff(now, 'minutes');
  }

  /**
   * Get time until closing (in minutes)
   */
  getMinutesUntilClosing(building: Building): number {
    const now = moment();
    const closingTime = moment(building.closingTime);
    return closingTime.diff(now, 'minutes');
  }
}
