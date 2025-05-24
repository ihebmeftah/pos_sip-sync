import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateAdminDto } from './dto/create-admin.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Admin } from './entities/admin.entity';
import { Repository } from 'typeorm';
import { UUID } from 'crypto';
import { UserBase } from 'src/database/base/user.base';

@Injectable()
export class AdminService {
    constructor(
        @InjectRepository(Admin)
        private readonly adminRepository: Repository<Admin>,
    ) { }
    public async create(createAdminDto: CreateAdminDto) {
        if (await this.existsAdminByEmail(createAdminDto.email))
            throw new ConflictException("Admin with this email already exists");
        if (await this.existsAdminByPhone(createAdminDto.phone))
            throw new ConflictException("Admin with this phone already exists");
        const createdAdmin = await this.adminRepository.create(createAdminDto);
        return await this.adminRepository.save(createdAdmin);
    }
    public async findAll() {
        return await this.adminRepository.find();
    }
    public async findOne(id: UUID) {
        const admin = await this.adminRepository.findOneBy({ id });
        if (!admin) throw new NotFoundException("Admin not found");
        return admin;
    }
    public async findOneByEmail(email: string): Promise<UserBase | null> {
        return await this.adminRepository.findOneBy({ email });
    }
    private async existsAdminByEmail(email: string) {
        return await this.adminRepository.existsBy({ email });
    }

    private async existsAdminByPhone(phone: string) {
        return await this.adminRepository.existsBy({ phone });
    }
}
