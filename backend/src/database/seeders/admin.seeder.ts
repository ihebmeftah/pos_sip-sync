import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Admin } from 'src/users/entities/admin.entity';
import { UserType } from 'src/enums/user.roles';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AdminSeeder {
    constructor(
        @InjectRepository(Admin)
        private readonly adminRepository: Repository<Admin>,
    ) { }

    async seed(): Promise<Admin[]> {
        const existingAdmins = await this.adminRepository.find();
        if (existingAdmins.length > 0) {
            return existingAdmins;
        }

        const hashedPassword = await bcrypt.hash('Admin@123', 10);

        const adminsData = [
            {
                firstname: 'John',
                lastname: 'Anderson',
                email: 'john.anderson@posadmin.com',
                phone: '+1234567890',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=12',
                type: UserType.Admin,
            },
            {
                firstname: 'Sarah',
                lastname: 'Mitchell',
                email: 'sarah.mitchell@posadmin.com',
                phone: '+1234567891',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=5',
                type: UserType.Admin,
            },
            {
                firstname: 'Michael',
                lastname: 'Chen',
                email: 'michael.chen@posadmin.com',
                phone: '+1234567892',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=33',
                type: UserType.Admin,
            },
        ];

        const admins = this.adminRepository.create(adminsData);
        return await this.adminRepository.save(admins);
    }

    async clear(): Promise<void> {
        await this.adminRepository.delete({});
    }
}
