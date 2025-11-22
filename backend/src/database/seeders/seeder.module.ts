import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { Admin } from 'src/users/entities/admin.entity';
import { Building } from 'src/building/entities/building.entity';
import { Employer } from 'src/users/entities/employer.entity';
import { AdminSeeder } from './admin.seeder';
import { BuildingSeeder } from './building.seeder';
import { EmployerSeeder } from './employer.seeder';
import { SeederService } from './seeder.service';
import { TenantSeeder } from './tenant.seeder';
import { DatabaseModule } from '../database.module';

@Module({
    imports: [
        ConfigModule,
        DatabaseModule,
        TypeOrmModule.forFeature([
            Admin,
            Building,
            Employer,
        ]),
    ],
    providers: [
        SeederService,
        AdminSeeder,
        BuildingSeeder,
        TenantSeeder,
        EmployerSeeder,
    ],
    exports: [SeederService],
})
export class SeederModule { }

