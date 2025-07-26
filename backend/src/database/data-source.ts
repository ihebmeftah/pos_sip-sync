import { ConfigModule, ConfigService } from "@nestjs/config";
import { TypeOrmModuleAsyncOptions, TypeOrmModuleOptions } from "@nestjs/typeorm";
import { DataSource } from "typeorm";
import * as path from "path";
import { Admin } from "src/users/entities/admin.entity";
import { User } from "src/users/entities/user.entity";
import { Building } from "src/building/entities/building.entity";
import { Employer } from "src/users/entities/employer.entity";

export const typeOrmAsyncConfig: TypeOrmModuleAsyncOptions = {
    imports: [ConfigModule],
    inject: [ConfigService],
    useFactory: async (
        configService: ConfigService
    ): Promise<TypeOrmModuleOptions> => {
        return {
            type: "postgres",
            host: configService.get<string>("DB_HOST"),
            port: configService.get<number>("DB_PORT"),
            username: configService.get<string>("DB_USER"),
            database: configService.get<string>("DB_NAME"),
            password: configService.get<string>("DB_PASSWORD"),
            synchronize: true,
            entities: [
                Admin,
                User,
                Building,
                Employer,
            ],
            migrations: [path.resolve(__dirname, '../../migrations/*{.js,.ts}')],
        };
    },
    dataSourceFactory: async (options) => {
        if (options === undefined) console.log("No data source options provided");
        const data = await new DataSource(options!).initialize()
        return data;
    },
};
export const datasource = new DataSource({
    type: "postgres",
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT!),
    username: process.env.USERNAME,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    synchronize: true,
});
