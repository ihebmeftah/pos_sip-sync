import { ConflictException, forwardRef, Inject, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UUID } from 'crypto';
import { Repository } from 'typeorm';
import { Employer } from './entities/employer.entity';
import { Admin } from './entities/admin.entity';
import { BuildingService } from 'src/building/building.service';
import { UserType } from 'src/enums/user.roles';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
    constructor(
        @InjectRepository(Admin)
        private readonly adminRepository: Repository<Admin>,
        @InjectRepository(Employer)
        private readonly employerRepository: Repository<Employer>,
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
        @Inject(forwardRef(() => BuildingService))
        private readonly buildingService: BuildingService,
    ) { }

    //* Start Admin functionnality
    public async createAdmin(createUser: CreateUserDto) {
        if (await this.existsAdminByEmail(createUser.email))
            throw new ConflictException("Admin with this email already exists");
        if (await this.existsAdminByPhone(createUser.phone))
            throw new ConflictException("Admin with this phone already exists");
        const createdAdmin = await this.adminRepository.create({
            user: {
                ...createUser,
                type: [UserType.Admin],
            }
        });
        createdAdmin.id = createdAdmin.user.id;
        return await this.adminRepository.save(createdAdmin);
    }
    public async findAllAdmins() {
        return await this.adminRepository.find();
    }
    public async findOneAdmin(id: UUID) {
        const admin = await this.adminRepository.findOneBy({ user: { id } });
        if (!admin) throw new NotFoundException("Admin not found");
        return admin;
    }

    private async existsAdminByEmail(email: string) {
        return await this.adminRepository.existsBy({ user: { email } });
    }

    private async existsAdminByPhone(phone: string) {
        return await this.adminRepository.existsBy({ user: { phone } });
    }

    // Start Employer functionnality
    public async createEmployer(createUser: CreateUserDto, buildingId: UUID) {
        const building = await this.buildingService.findOne(buildingId);
        createUser.email = `${createUser.email.split('@')[0]}@${building.name.replace(/\s+/g, '').toLowerCase()}.com`;
        if (await this.existsEmployerByEmail(createUser.email)) {
            const uniquePrefix = Math.random().toString(36).substring(2, 6);
            createUser.email = `${createUser.email.split('@')[0]}${uniquePrefix}@${building.name.replace(/\s+/g, '').toLowerCase()}.com`;
        }
        if (await this.existsEmployerByPhone(createUser.phone))
            throw new ConflictException("Employer with this phone already exists");
        const createdEmployer = await this.employerRepository.create({
            user: {
                ...createUser,
                type: [UserType.Employer],
            },
            building: building,
        });
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
        const employer = await this.employerRepository.findOneBy({ user: { id } });
        if (!employer) throw new NotFoundException("Employer not found");
        return employer;
    }


    private async existsEmployerByEmail(email: string) {
        return await this.employerRepository.existsBy({ user: { email } });
    }

    private async existsEmployerByPhone(phone: string) {
        return await this.employerRepository.existsBy({ user: { phone } });
    }

    //* Auth helper functions
    public async findUserByEmail(email: string): Promise<User> {
        const admin = await this.adminRepository.findOneBy({ user: { email } });
        if (admin) return admin.user;
        const employer = await this.employerRepository.findOneBy({ user: { email } });
        if (employer) return employer.user;
        throw new UnauthorizedException();
    }
    public async findUserById(id: UUID): Promise<User> {
        const admin = await this.adminRepository.findOneBy({ user: { id } });
        if (admin) return admin.user;
        const employer = await this.employerRepository.findOneBy({ user: { id } });
        if (employer) return employer.user;
        throw new UnauthorizedException();
    }
}
