import { ConflictException, forwardRef, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UUID } from 'crypto';
import { FindOneOptions, Repository } from 'typeorm';
import { Employer } from './entities/employer.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './entities/user.entity';
import { UserType } from 'src/enums/user.roles';
import { Admin } from './entities/admin.entity';
import { BuildingService } from 'src/building/building.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
    constructor(
        @Inject(forwardRef(() => BuildingService))
        private readonly buildingService: BuildingService,
        @InjectRepository(Admin)
        private readonly adminRepository: Repository<Admin>,
        @InjectRepository(Employer)
        private readonly employerRepository: Repository<Employer>,
    ) { }

    //* Start Admin functionnality
    public async createAdmin(createUser: CreateUserDto) {
        const existingAdmin = await this.adminRepository.exists({
            where: [
                { email: createUser.email },
                { phone: createUser.phone }
            ]
        });
        if (existingAdmin)
            throw new ConflictException("Admin with this email or phone already exists");
        const createdAdmin = this.adminRepository.create({ ...createUser, type: UserType.Admin });
        createdAdmin.password = await bcrypt.hash(createUser.password, 10);
        return await this.adminRepository.save(createdAdmin);
    }

    public async findAdminById(id: UUID): Promise<Admin> {
        const admin = await this.adminRepository.findOneBy({ id });
        if (!admin) throw new NotFoundException(`Admin with this id ${id} not found`);
        return admin;
    }

    //* Start Employer functionnality
    public async createEmployer(createUser: CreateUserDto, DbName: string) {
        const building = await this.buildingService.findByDbName(DbName);
        const existingEmployer = await this.employerRepository.exists({
            where: [
                { email: createUser.email },
                { phone: createUser.phone }
            ]
        });
        if (existingEmployer)
            throw new ConflictException("Employer with this email or phone already exists");
        const employer = this.employerRepository.create({ ...createUser, building, type: UserType.Employer });
        employer.username = `${employer.email.split('@')[0]}_${employer.phone}`;
        employer.password = await bcrypt.hash(createUser.password, 10);
        return await this.employerRepository.save(employer);
    }

    public async findEmployerById(id: UUID): Promise<Employer> {
        const employer = await this.employerRepository.findOneBy({ id });
        if (!employer) throw new NotFoundException(`Employer with this id ${id} not found`);
        return employer;
    }

    public async findEmployers(db: string): Promise<Employer[]> {
        return await this.employerRepository.find({
            where: { building: { dbName: db } },
        });

    }
    //* Auth helper functions
    public async findUserByEmailOrUsername(identifier: string): Promise<User> {
        let user: User | null;
        user = await this.adminRepository.findOneBy({ email: identifier });
        user ??= await this.employerRepository.findOneBy({ username: identifier });
        if (!user) throw new NotFoundException(`User with identifier ${identifier} not found`);
        return user;
    }

    async findUser(id: UUID, role?: UserType[]) {
        let user: User | null;
        const options: FindOneOptions<User> = {
            where: { id },
            select: {
                id: true,
                firstname: true,
                lastname: true,
                type: true, photo: true,
                phone: true,
                email: true
            }
        }
        if (!role) {
            user ??= await this.adminRepository.findOne(options);
            user ??= await this.employerRepository.findOne(options);
        } else {
            if (role.includes(UserType.Admin)) {
                user = await this.adminRepository.findOne(options);
            } else {
                user = await this.employerRepository.findOne(options);
            }
        }
        if (!user) throw new NotFoundException(`User with id ${id} not found`);
        return user;
    }
}
