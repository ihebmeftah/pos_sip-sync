import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DatabaseConnectionService } from './database-connection.service';
import { RepositoryFactory } from './repository-factory.service';
import { MigrationService } from './migration.service';

@Global()
@Module({
    imports: [ConfigModule],
    providers: [DatabaseConnectionService, RepositoryFactory, MigrationService],
    exports: [DatabaseConnectionService, RepositoryFactory, MigrationService],
})
export class DatabaseModule { }
