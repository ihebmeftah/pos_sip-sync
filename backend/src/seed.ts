import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { SeederService } from './database/seeders/seeder.service';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const seeder = app.get(SeederService);

    const args = process.argv.slice(2);
    const command = args[0];

    try {
        if (command === 'clear') {
            await seeder.clearDatabase();
        } else {
            await seeder.seed();
        }

        await app.close();
        process.exit(0);
    } catch (error) {
        console.error('Seeding failed:', error);
        await app.close();
        process.exit(1);
    }
}

bootstrap();
