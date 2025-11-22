import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Building } from 'src/building/entities/building.entity';
import { Admin } from 'src/users/entities/admin.entity';

@Injectable()
export class BuildingSeeder {
    constructor(
        @InjectRepository(Building)
        private readonly buildingRepository: Repository<Building>,
    ) { }

    async seed(admins: Admin[]): Promise<Building[]> {
        const existingBuildings = await this.buildingRepository.find();
        if (existingBuildings.length > 0) {
            return existingBuildings;
        }

        const now = new Date();
        const openingTime = new Date(now);
        openingTime.setHours(8, 0, 0, 0);

        const closingTime = new Date(now);
        closingTime.setHours(23, 0, 0, 0);

        const buildingsData = [
            {
                name: 'Downtown Bistro',
                dbName: 'downtown_bistro_db',
                tableMultiOrder: true,
                openingTime,
                closingTime,
                location: '123 Main Street, Downtown',
                logo: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&h=400&fit=crop',
                photos: [
                    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
                    'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800',
                    'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?w=800',
                ],
                admin: admins[0],
            },
            {
                name: 'Seaside Café',
                dbName: 'seaside_cafe_db',
                tableMultiOrder: false,
                openingTime,
                closingTime,
                location: '456 Beach Boulevard, Waterfront',
                logo: 'https://images.unsplash.com/photo-1559305616-3c7a51d42c37?w=400&h=400&fit=crop',
                photos: [
                    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800',
                    'https://images.unsplash.com/photo-1556912167-f556f1f39faa?w=800',
                    'https://images.unsplash.com/photo-1567521464027-f127ff144326?w=800',
                ],
                admin: admins[1],
            },
            {
                name: 'Mountain View Restaurant',
                dbName: 'mountain_view_db',
                tableMultiOrder: true,
                openingTime,
                closingTime,
                location: '789 Highland Avenue, Mountain District',
                logo: 'https://images.unsplash.com/photo-1592861956120-e524fc739696?w=400&h=400&fit=crop',
                photos: [
                    'https://images.unsplash.com/photo-1564759224907-65b0329744aa?w=800',
                    'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
                    'https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?w=800',
                ],
                admin: admins[2],
            },
            {
                name: 'Urban Grill House',
                dbName: 'urban_grill_db',
                tableMultiOrder: true,
                openingTime,
                closingTime,
                location: '321 City Center Plaza, Urban Quarter',
                logo: 'https://images.unsplash.com/photo-1578474846511-04ba529f0b88?w=400&h=400&fit=crop',
                photos: [
                    'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=800',
                    'https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?w=800',
                    'https://images.unsplash.com/photo-1424847651672-bf20a4b0982b?w=800',
                ],
                admin: admins[0],
            },
        ];

        const buildings = this.buildingRepository.create(buildingsData);
        return await this.buildingRepository.save(buildings);
    }

    async getAll(): Promise<Building[]> {
        return await this.buildingRepository.find();
    }

    async clear(): Promise<void> {
        await this.buildingRepository.delete({});
    }
}
