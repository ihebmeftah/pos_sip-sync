import { DataSource } from "typeorm";
import { Order } from 'src/order/entities/order.entity';
import { Article } from 'src/article/entities/article.entity';
import { Table } from 'src/tables/entities/table.entity';
import { OrderItem } from 'src/order/entities/order_item.entity';
import { Category } from 'src/category/entities/category.entity';
import * as dotenv from 'dotenv';
import { Caisse } from "src/caisse/entities/caisse.entity";
dotenv.config();
export const tenantdata: Map<string, any> = new Map();
tenantdata.set("type", "postgres");
tenantdata.set("host", process.env.DB_HOST);
tenantdata.set("port", parseInt(process.env.DB_PORT!));
tenantdata.set("username", process.env.DB_USER);
tenantdata.set("database", process.argv[7]);
tenantdata.set("password", process.env.DB_PASSWORD);
tenantdata.set("synchronize", false);
tenantdata.set("entities", [
    Order, OrderItem, Category, Article, Table, Caisse
]);
tenantdata.set("migrations", [__dirname + '/../../migrations/tenant/*{.js,.ts}']);

export const tenantDS = new DataSource({
    type: tenantdata.get("type"),
    host: tenantdata.get("host"),
    port: tenantdata.get("port"),
    username: tenantdata.get("username"),
    database: tenantdata.get("database"),
    password: tenantdata.get("password"),
    synchronize: tenantdata.get("synchronize"),
    entities: tenantdata.get("entities"),
    migrations: tenantdata.get("migrations"),
});

