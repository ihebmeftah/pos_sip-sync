import { Injectable } from '@nestjs/common';
import { Article } from 'src/article/entities/article.entity';
import { Category } from 'src/category/entities/category.entity';
import { RepositoryFactory } from 'src/database/repository-factory.service';
import { Order } from 'src/order/entities/order.entity';
import { OrderStatus } from 'src/enums/order_status';

@Injectable()
export class StatsService {
    constructor(
        private readonly repositoryFactory: RepositoryFactory,
    ) { }
    async getStats(dbname: string) {
        const orderRepo = await this.repositoryFactory.getRepository(dbname, Order);
        const articleRepo = await this.repositoryFactory.getRepository(dbname, Article);
        const categoryRepo = await this.repositoryFactory.getRepository(dbname, Category);
        // compute stats from paid orders
        const totalOrders = await orderRepo.count();
        const totalArticles = await articleRepo.count();
        const totalCategories = await categoryRepo.count();

        const paidOrders = await orderRepo.find({ where: { status: OrderStatus.PAYED } });

        const articleMap = new Map<string, { article: Article; count: number }>();
        const categoryMap = new Map<string, { category: Category; count: number }>();

        let totalSales = 0;
        let totalItemsSold = 0;

        for (const order of paidOrders) {
            if (!order.items || !Array.isArray(order.items)) continue;
            for (const item of order.items) {
                // only count paid items
                if (!item.payed) continue;
                const art = item.article;
                if (!art || !art.id) continue;

                const artId = String(art.id);
                const prevArt = articleMap.get(artId);
                if (prevArt) {
                    prevArt.count += 1;
                } else {
                    articleMap.set(artId, { article: art, count: 1 });
                }

                // category
                const cat = art.category;
                if (cat && cat.id) {
                    const catId = String(cat.id);
                    const prevCat = categoryMap.get(catId);
                    if (prevCat) prevCat.count += 1;
                    else categoryMap.set(catId, { category: cat, count: 1 });
                }

                // funds
                const price = typeof art.price === 'number' ? art.price : Number(art.price || 0);
                totalSales += price;
                totalItemsSold += 1;
            }
        }

        const mostPopularArticles = Array.from(articleMap.values())
            .sort((a, b) => b.count - a.count)
            .slice(0, 5)
            .map((v) => ({ article: v.article, count: v.count }));

        const mostPopularCategories = Array.from(categoryMap.values())
            .sort((a, b) => b.count - a.count)
            .slice(0, 5)
            .map((v) => ({ category: v.category, count: v.count }));

        const paidOrdersCount = paidOrders.length;
        const avgOrderValue = paidOrdersCount > 0 ? totalSales / paidOrdersCount : 0;

        return {
            totalOrders,
            totalArticles,
            totalCategories,
            paidOrders: paidOrdersCount,
            totalItemsSold,
            funds: {
                totalSales: Number(totalSales.toFixed(2)),
                avgOrderValue: Number(avgOrderValue.toFixed(2)),
            },
            mostPopularArticles,
            mostPopularCategories,
        };
    }
}
