import { Injectable } from '@nestjs/common';
import { Repository, DataSource, EntityTarget, ObjectLiteral } from 'typeorm';
import { DatabaseConnectionService } from './database-connection.service';

@Injectable()
export class RepositoryFactory {
    constructor(private databaseConnectionService: DatabaseConnectionService) { }

    async getRepository<Entity extends ObjectLiteral>(
        dbName: string,
        entity: EntityTarget<Entity>
    ): Promise<Repository<Entity>> {
        const connection = await this.databaseConnectionService.getConnection(dbName);
        return connection.getRepository(entity);
    }
}
