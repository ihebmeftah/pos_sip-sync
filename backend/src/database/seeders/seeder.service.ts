import { Injectable, Logger } from '@nestjs/common';
import { AdminSeeder } from './admin.seeder';
import { BuildingSeeder } from './building.seeder';
import { TenantSeeder } from './tenant.seeder';
import { EmployerSeeder } from './employer.seeder';


@Injectable()
export class SeederService {
    private readonly logger = new Logger(SeederService.name);

    constructor(
        private readonly adminSeeder: AdminSeeder,
        private readonly buildingSeeder: BuildingSeeder,
        private readonly tenantSeeder: TenantSeeder,
        private readonly employerSeeder: EmployerSeeder,
    ) { }

    async seed() {
        this.logger.log('🌱 Starting database seeding...');

        try {
            // 1. Seed admins first
            this.logger.log('📝 Seeding admins...');
            const admins = await this.adminSeeder.seed();
            this.logger.log(`✅ Created ${admins.length} admins`);

            // 2. Seed buildings (requires admins)
            this.logger.log('🏢 Seeding buildings...');
            const buildings = await this.buildingSeeder.seed(admins);
            this.logger.log(`✅ Created ${buildings.length} buildings`);

            // 3. Seed tenant databases (categories and articles)
            this.logger.log('📂 Seeding tenant databases...');
            let totalCategories = 0;
            let totalArticles = 0;

            for (const building of buildings) {
                await this.tenantSeeder.seedTenantDatabase(building.dbName);
                totalCategories += 12; // We create 12 categories per tenant
                totalArticles += 60; // We create ~60 articles per tenant
            }

            this.logger.log(`✅ Created ${totalCategories} categories across all tenants`);
            this.logger.log(`✅ Created ${totalArticles} articles across all tenants`);

            // 4. Seed employers (requires buildings)
            this.logger.log('👥 Seeding employers...');
            const employers = await this.employerSeeder.seed(buildings);
            this.logger.log(`✅ Created ${employers.length} employers`);

            this.logger.log('🎉 Database seeding completed successfully!');

            return {
                admins: admins.length,
                buildings: buildings.length,
                categories: totalCategories,
                articles: totalArticles,
                employers: employers.length,
            };
        } catch (error) {
            this.logger.error('❌ Error during seeding:', error);
            throw error;
        }
    }

    async clearDatabase() {
        this.logger.log('🗑️  Clearing database...');

        try {
            // Get all buildings first
            const buildings = await this.buildingSeeder.getAll();

            // Clear tenant databases
            for (const building of buildings) {
                await this.tenantSeeder.clearTenantDatabase(building.dbName);
            }

            await this.employerSeeder.clear();
            await this.buildingSeeder.clear();
            await this.adminSeeder.clear();

            this.logger.log('✅ Database cleared successfully!');
        } catch (error) {
            this.logger.error('❌ Error during clearing:', error);
            throw error;
        }
    }
}
