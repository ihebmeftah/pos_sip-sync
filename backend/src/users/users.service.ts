import { ConflictException, forwardRef, Inject, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UUID } from 'crypto';
import { UserBase } from 'src/database/base/user.base';
import { Repository } from 'typeorm';
import { CreateAdminDto } from './dto/create-admin.dto';
import { Employer } from './entities/employer.entity';
import { Admin } from './entities/admin.entity';
import { CreateEmployerDto } from './dto/create-employer.dto';
import { BuildingService } from 'src/building/building.service';
import { UserRole } from 'src/enums/user.roles';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(Admin)
        private readonly adminRepository: Repository<Admin>,
        @InjectRepository(Employer)
        private readonly employerRepository: Repository<Employer>,
        @Inject(forwardRef(() => BuildingService))
        private readonly buildingService: BuildingService,
    ) { }

    //* Start Admin functionnality
    public async createAdmin(createAdminDto: CreateAdminDto) {
        if (await this.existsAdminByEmail(createAdminDto.email))
            throw new ConflictException("Admin with this email already exists");
        if (await this.existsAdminByPhone(createAdminDto.phone))
            throw new ConflictException("Admin with this phone already exists");
        const createdAdmin = await this.adminRepository.create(createAdminDto);
        createdAdmin.role = UserRole.Admin;
        return await this.adminRepository.save(createdAdmin);
    }
    public async findAllAdmins() {
        return await this.adminRepository.find();
    }
    public async findOneAdmin(id: UUID) {
        const admin = await this.adminRepository.findOneBy({ id });
        if (!admin) throw new NotFoundException("Admin not found");
        return admin;
    }

    private async existsAdminByEmail(email: string) {
        return await this.adminRepository.existsBy({ email });
    }

    private async existsAdminByPhone(phone: string) {
        return await this.adminRepository.existsBy({ phone });
    }

    // Start Employer functionnality
    public async createEmployer(createEmployerDto: CreateEmployerDto, buildingId: UUID) {
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
        createdEmployer.role = UserRole.Employer;
        return await this.employerRepository.save(createdEmployer);
    }
    public async findAllEmployers(buildingId: UUID) {
        return await this.employerRepository.find({
            where: {
                building: {
                    id: buildingId,
                }
            },
        });
    }
    public async findOneEmployer(id: UUID) {
        const employer = await this.employerRepository.findOneBy({ id });
        if (!employer) throw new NotFoundException("Employer not found");
        return employer;
    }


    private async existsEmployerByEmail(email: string) {
        return await this.employerRepository.existsBy({ email });
    }

    private async existsEmployerByPhone(phone: string) {
        return await this.employerRepository.existsBy({ phone });
    }

    //* Auth helper functions
    public async findUserByEmail(email: string): Promise<UserBase> {
        let user = await this.adminRepository.findOneBy({ email });
        if (user) return { ...user, role: UserRole.Admin };
        user = await this.employerRepository.findOneBy({ email });
        if (user) return { ...user, role: UserRole.Employer };
        throw new UnauthorizedException();
    }

}
