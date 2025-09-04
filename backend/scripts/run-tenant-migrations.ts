import { NestFactory } from '@nestjs/core';
import { AppModule } from 'src/app.module';
import { BuildingService } from 'src/building/building.service';
import { MigrationService } from 'src/database/migration.service';


async function runTenantMigrations() {
    console.log("$$$$$$" + process.argv);

    const app = await NestFactory.create(AppModule);
    const migrationService = app.get(MigrationService);
    if (process.argv[2] == "all") {
        const buildingsService = app.get(BuildingService);
        const buildings = await buildingsService.findAll();
        const dbNames = buildings.map(building => building.dbName);
        console.info('Running migrations for all tenant databases...');
        await migrationService.runAllTenantMigrations(dbNames);
        console.info('All tenant migrations completed!');
        return;
    } else {
        console.info('Running migrations for specific tenant database...');
        await migrationService.runTenantMigrations(process.argv[2]);
        console.info('Tenant migrations completed!');
    }
    await app.close();
}

runTenantMigrations().catch(error => {
    console.error('Migration failed:', error);
    process.exit(1);
});