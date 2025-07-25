import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { DatabaseConnectionService } from './database-connection.service';
import { RepositoryFactory } from './repository-factory.service';

@Global()
@Module({
    imports: [ConfigModule],
    providers: [DatabaseConnectionService, RepositoryFactory],
    exports: [DatabaseConnectionService, RepositoryFactory],
})
export class DatabaseModule { }
