import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Employer } from 'src/users/entities/employer.entity';
import { Building } from 'src/building/entities/building.entity';
import { UserType } from 'src/enums/user.roles';
import * as bcrypt from 'bcrypt';

@Injectable()
export class EmployerSeeder {
    constructor(
        @InjectRepository(Employer)
        private readonly employerRepository: Repository<Employer>,
    ) { }

    async seed(buildings: Building[]): Promise<Employer[]> {
        const existingEmployers = await this.employerRepository.find();
        if (existingEmployers.length > 0) {
            return existingEmployers;
        }

        const hashedPassword = await bcrypt.hash('Employee@123', 10);

        const employersData = [
            // Downtown Bistro staff
            {
                firstname: 'Emma',
                lastname: 'Johnson',
                username: 'emma.johnson',
                email: 'emma.johnson@downtown.com',
                phone: '+1234567900',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=1',
                type: UserType.Employer,
                building: buildings[0],
            },
            {
                firstname: 'James',
                lastname: 'Wilson',
                username: 'james.wilson',
                email: 'james.wilson@downtown.com',
                phone: '+1234567901',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=13',
                type: UserType.Employer,
                building: buildings[0],
            },
            {
                firstname: 'Olivia',
                lastname: 'Brown',
                username: 'olivia.brown',
                email: 'olivia.brown@downtown.com',
                phone: '+1234567902',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=9',
                type: UserType.Employer,
                building: buildings[0],
            },

            // Seaside Café staff
            {
                firstname: 'Noah',
                lastname: 'Davis',
                username: 'noah.davis',
                email: 'noah.davis@seaside.com',
                phone: '+1234567903',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=14',
                type: UserType.Employer,
                building: buildings[1],
            },
            {
                firstname: 'Sophia',
                lastname: 'Martinez',
                username: 'sophia.martinez',
                email: 'sophia.martinez@seaside.com',
                phone: '+1234567904',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=10',
                type: UserType.Employer,
                building: buildings[1],
            },
            {
                firstname: 'Liam',
                lastname: 'Garcia',
                username: 'liam.garcia',
                email: 'liam.garcia@seaside.com',
                phone: '+1234567905',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=15',
                type: UserType.Employer,
                building: buildings[1],
            },

            // Mountain View Restaurant staff
            {
                firstname: 'Ava',
                lastname: 'Rodriguez',
                username: 'ava.rodriguez',
                email: 'ava.rodriguez@mountainview.com',
                phone: '+1234567906',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=16',
                type: UserType.Employer,
                building: buildings[2],
            },
            {
                firstname: 'William',
                lastname: 'Hernandez',
                username: 'william.hernandez',
                email: 'william.hernandez@mountainview.com',
                phone: '+1234567907',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=17',
                type: UserType.Employer,
                building: buildings[2],
            },
            {
                firstname: 'Isabella',
                lastname: 'Lopez',
                username: 'isabella.lopez',
                email: 'isabella.lopez@mountainview.com',
                phone: '+1234567908',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=20',
                type: UserType.Employer,
                building: buildings[2],
            },

            // Urban Grill House staff
            {
                firstname: 'Mason',
                lastname: 'Gonzalez',
                username: 'mason.gonzalez',
                email: 'mason.gonzalez@urban.com',
                phone: '+1234567909',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=19',
                type: UserType.Employer,
                building: buildings[3],
            },
            {
                firstname: 'Mia',
                lastname: 'Perez',
                username: 'mia.perez',
                email: 'mia.perez@urban.com',
                phone: '+1234567910',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=23',
                type: UserType.Employer,
                building: buildings[3],
            },
            {
                firstname: 'Ethan',
                lastname: 'Taylor',
                username: 'ethan.taylor',
                email: 'ethan.taylor@urban.com',
                phone: '+1234567911',
                password: hashedPassword,
                photo: 'https://i.pravatar.cc/300?img=27',
                type: UserType.Employer,
                building: buildings[3],
            },
        ];

        const employers = this.employerRepository.create(employersData);
        return await this.employerRepository.save(employers);
    }

    async clear(): Promise<void> {
        await this.employerRepository.delete({});
    }
}
