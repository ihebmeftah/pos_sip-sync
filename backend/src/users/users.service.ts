import { ConflictException, forwardRef, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UUID } from 'crypto';
import { In, Repository } from 'typeorm';
import { Employer } from './entities/employer.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './entities/user.entity';
import { RepositoryFactory } from 'src/database/repository-factory.service';
import { UserType } from 'src/enums/user.roles';
import { Admin } from './entities/admin.entity';
import { BuildingService } from 'src/building/building.service';
import { Staff } from './entities/staff.entity';

@Injectable()
export class UsersService {
    constructor(
        @Inject(forwardRef(() => BuildingService))
        private readonly buildingService: BuildingService,
        private readonly repositoryFactory: RepositoryFactory,
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
        let employer = await this.employerRepository.create({ ...createUser, building, type: UserType.Employer });
        employer.username = `${employer.email.split('@')[0]}_${employer.phone}`;
        employer = await this.employerRepository.save(employer);
        const staffRepo = await this.repositoryFactory.getRepository(DbName, Staff);
        let staff = staffRepo.create({ ...employer, employerId: employer.id, type: UserType.Employer });
        staff = await staffRepo.save(staff);
        return await staffRepo.save(staff);
    }

    //* Staff functionnality
    public async findAllStaff(dbName: string) {
        const staffRepository = await this.repositoryFactory.getRepository(dbName, Staff);
        const staff = await staffRepository.find();
        const employers = await this.employerRepository.findBy({
            id: In(staff.map(s => s.employerId))
        });
        return staff.map(s => ({ ...s, ...employers.find(e => e.id === s.employerId) }));
    }
    public async findStaffById(id: UUID, dbName: string) {
        const staffRepository = await this.repositoryFactory.getRepository(dbName, Staff);
        const staff = await staffRepository.findOneBy({ employerId: id });
        if (!staff) throw new NotFoundException(`Employer with this id ${id} not found`);
        const employer = await this.employerRepository.findOneBy({ email: staff.email });
        if (!employer) throw new NotFoundException(`Employer with this id ${staff.id} not found`);
        return { ...staff, ...employer };
    }


    //* Auth helper functions
    public async findUserByEmailOrUsername(identifier: string): Promise<User> {
        let user: User | null;
        user = await this.adminRepository.findOneBy({ email: identifier });
        user ??= await this.employerRepository.findOneBy({ username: identifier });
        if (user?.type === UserType.Employer) {
            const staff = await this.findStaffById(user.id, (user as Employer)!.building.dbName);
            return {
                ...user,
                ...staff,
            }
        }
        if (!user) throw new NotFoundException(`User with identifier ${identifier} not found`);
        return user;
    }
}
