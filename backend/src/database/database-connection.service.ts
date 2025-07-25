import { Injectable, Inject } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DataSource } from 'typeorm';
import * as path from 'path';

@Injectable()
export class DatabaseConnectionService {
    private connections = new Map<string, DataSource>();

    constructor(private configService: ConfigService) { }

    async getConnection(dbName: string): Promise<DataSource> {
        if (this.connections.has(dbName)) {
            const connection = this.connections.get(dbName);
            if (connection?.isInitialized) {
                return connection;
            }
        }

        // Create new connection for the specific database
        const dataSource = new DataSource({
            type: 'postgres',
            host: this.configService.get<string>('DB_HOST'),
            port: this.configService.get<number>('DB_PORT'),
            username: this.configService.get<string>('DB_USER'),
            database: dbName,
            password: this.configService.get<string>('DB_PASSWORD'),
            synchronize: true, // In production, use migrations instead
            entities: [path.resolve(__dirname, '../**/*.entity{.js,.ts}')],
            logging: false,
        });

        await dataSource.initialize();
        this.connections.set(dbName, dataSource);
        return dataSource;
    }

    async createDatabase(dbName: string): Promise<void> {
        // Connect to default postgres database to create new database
        const adminDataSource = new DataSource({
            type: 'postgres',
            host: this.configService.get<string>('DB_HOST'),
            port: this.configService.get<number>('DB_PORT'),
            username: this.configService.get<string>('DB_USER'),
            database: 'postgres', // Connect to default postgres database
            password: this.configService.get<string>('DB_PASSWORD'),
        });

        await adminDataSource.initialize();

        try {
            // Check if database exists
            const result = await adminDataSource.query(
                'SELECT 1 FROM pg_database WHERE datname = $1',
                [dbName]
            );

            if (result.length === 0) {
                // Create database if it doesn't exist
                await adminDataSource.query(`CREATE DATABASE "${dbName}"`);
            }
        } finally {
            await adminDataSource.destroy();
        }
    }

    async closeConnection(dbName: string): Promise<void> {
        const connection = this.connections.get(dbName);
        if (connection && connection.isInitialized) {
            await connection.destroy();
            this.connections.delete(dbName);
        }
    }

    async closeAllConnections(): Promise<void> {
        const promises = Array.from(this.connections.keys()).map(dbName =>
            this.closeConnection(dbName)
        );
        await Promise.all(promises);
    }
}
