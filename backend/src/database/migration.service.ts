import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DataSource } from 'typeorm';
import { DatabaseConnectionService } from './database-connection.service';
import { Order } from 'src/order/entities/order.entity';
import { Article } from 'src/article/entities/article.entity';
import { Table } from 'src/tables/entities/table.entity';
import { OrderItem } from 'src/order/entities/order_item.entity';
import { Category } from 'src/category/entities/category.entity';
import { Caisse } from 'src/caisse/entities/caisse.entity';


@Injectable()
export class MigrationService {
    constructor(
        private configService: ConfigService,
        private databaseConnectionService: DatabaseConnectionService
    ) { }

    // Run migrations for a specific tenant database
    async runTenantMigrations(dbname: string): Promise<void> {
        const tenantDS = new DataSource({
            type: "postgres",
            host: process.env.DB_HOST,
            port: parseInt(process.env.DB_PORT!),
            username: process.env.DB_USER,
            database: dbname,
            password: process.env.DB_PASSWORD,
            synchronize: false,
            entities: [
                Order, OrderItem, Category, Article, Table, Caisse
            ],
            migrations: [__dirname + '/../../migrations/tenant/*{.js,.ts}'],
        });
        await tenantDS.initialize();
        await tenantDS.runMigrations();
        await tenantDS.destroy();
        console.log(`Migrations completed for database: ${dbname}`);

    }

    // Run migrations for all tenant databases
    async runAllTenantMigrations(tenantDBNames: string[]): Promise<void> {
        for (const dbName of tenantDBNames) {
            try {
                await this.runTenantMigrations(dbName);
            } catch (error) {
                console.error(`Failed to run migrations for ${dbName}:`, error);
            }
        }
    }

    // Revert migrations for a specific database
    async revertMigrations(dbName: string): Promise<void> {
        const tenantDS = new DataSource({
            type: "postgres",
            host: process.env.DB_HOST,
            port: parseInt(process.env.DB_PORT!),
            username: process.env.DB_USER,
            database: dbName,
            password: process.env.DB_PASSWORD,
            synchronize: false,
            entities: [
                Order, OrderItem, Category, Article, Table, Caisse
            ],
            migrations: [__dirname + '/../../migrations/tenant/*{.js,.ts}'],
        });
        await tenantDS.initialize();
        await tenantDS.undoLastMigration();
        await tenantDS.destroy();
    }
}