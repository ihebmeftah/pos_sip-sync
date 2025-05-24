import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateEmployerDto } from './dto/create-employer.dto';
import { Employer } from './entities/employer.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UUID } from 'crypto';
import { UserBase } from 'src/database/base/user.base';
import { BuildingService } from 'src/building/building.service';

@Injectable()
export class EmployerService {
    constructor(
        @InjectRepository(Employer)
        private readonly employerRepository: Repository<Employer>,
        private readonly buildingService: BuildingService,
    ) { }
    public async create(createEmployerDto: CreateEmployerDto, buildingId: UUID) {
        const building = await this.buildingService.findOne(buildingId);
        createEmployerDto.email = `${createEmployerDto.email.split('@')[0]}@${building.name.replace(/\s+/g, '').toLowerCase()}.com`;
        if (await this.existsEmployerByEmail(createEmployerDto.email)) {
            const uniquePrefix = Math.random().toString(36).substring(2, 6);
            createEmployerDto.email = `${createEmployerDto.email.split('@')[0]}${uniquePrefix}@${building.name.replace(/\s+/g, '').toLowerCase()}.com`;
        }
        if (await this.existsEmployerByPhone(createEmployerDto.phone))
            throw new ConflictException("Employer with this phone already exists");
        const createdEmployer = await this.employerRepository.create(createEmployerDto);
        createdEmployer.building = building;
        return await this.employerRepository.save(createdEmployer);
    }
    public async findAll(buildingId: UUID) {
        return await this.employerRepository.find({
            where: {
                building: {
                    id: buildingId,
                }
            },
        });
    }
    public async findOne(id: UUID) {
        const employer = await this.employerRepository.findOneBy({ id });
        if (!employer) throw new NotFoundException("Employer not found");
        return employer;
    }

    public async findOneByEmail(email: string): Promise<UserBase> {
        const employer = await this.employerRepository.findOne({
            where: { email },
            relations: { building: true },
        });
        if (!employer) throw new NotFoundException("Employer not found");
        return employer;

    }
    private async existsEmployerByEmail(email: string) {
        return await this.employerRepository.existsBy({ email });
    }

    private async existsEmployerByPhone(phone: string) {
        return await this.employerRepository.existsBy({ phone });
    }
}
