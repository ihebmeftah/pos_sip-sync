import { Injectable, Logger } from '@nestjs/common';
import { DatabaseConnectionService } from '../database-connection.service';
import { DataSource } from 'typeorm';
import { Category } from 'src/category/entities/category.entity';
import { Article } from 'src/article/entities/article.entity';
import { Ingredient } from 'src/ingredient/entities/ingredient.entity';
import { ArticleCompo } from 'src/article/entities/article-compo.entity';
import { UnitsType } from 'src/enums/units_type';

@Injectable()
export class TenantSeeder {
    private readonly logger = new Logger(TenantSeeder.name);

    constructor(
        private readonly dbConnectionService: DatabaseConnectionService,
    ) { }

    async seedTenantDatabase(dbName: string): Promise<void> {
        this.logger.log(`Seeding tenant database: ${dbName}`);

        // Create the database if it doesn't exist
        try {
            await this.dbConnectionService.createDatabase(dbName);
            this.logger.log(`✅ Database ${dbName} created or already exists`);
        } catch (error) {
            this.logger.warn(`Database ${dbName} might already exist, continuing...`);
        }

        const connection = await this.dbConnectionService.getConnection(dbName);

        // Run migrations
        try {
            await connection.runMigrations();
            this.logger.log(`✅ Migrations executed for ${dbName}`);
        } catch (error) {
            this.logger.warn(`Migrations might have already run for ${dbName}`);
        }

        // Seed ingredients first
        const ingredients = await this.seedIngredients(connection);
        this.logger.log(`✅ Created ${ingredients.length} ingredients for ${dbName}`);

        // Seed categories
        const categories = await this.seedCategories(connection);
        this.logger.log(`✅ Created ${categories.length} categories for ${dbName}`);

        // Seed articles
        const articles = await this.seedArticles(connection, categories);
        this.logger.log(`✅ Created ${articles.length} articles for ${dbName}`);

        // Seed article compositions
        await this.seedArticleCompositions(connection, articles, ingredients);
        this.logger.log(`✅ Created article compositions for ${dbName}`);
    }

    private async seedIngredients(connection: DataSource): Promise<Ingredient[]> {
        const ingredientRepo = connection.getRepository(Ingredient);

        const existing = await ingredientRepo.find();
        if (existing.length > 0) {
            return existing;
        }

        const ingredientsData = [
            // Coffee ingredients
            {
                name: 'Coffee Beans (Arabica)',
                description: 'Premium Arabica coffee beans',
                stockUnit: UnitsType.GRAM,
                currentStock: 5000,
                minimumStock: 1000,
            },
            {
                name: 'Coffee Beans (Robusta)',
                description: 'Strong Robusta coffee beans',
                stockUnit: UnitsType.GRAM,
                currentStock: 3000,
                minimumStock: 500,
            },
            {
                name: 'Whole Milk',
                description: 'Fresh whole milk',
                stockUnit: UnitsType.LITER,
                currentStock: 50,
                minimumStock: 10,
            },
            {
                name: 'Skim Milk',
                description: 'Low-fat skim milk',
                stockUnit: UnitsType.LITER,
                currentStock: 30,
                minimumStock: 8,
            },
            {
                name: 'Almond Milk',
                description: 'Plant-based almond milk',
                stockUnit: UnitsType.LITER,
                currentStock: 20,
                minimumStock: 5,
            },
            {
                name: 'Oat Milk',
                description: 'Plant-based oat milk',
                stockUnit: UnitsType.LITER,
                currentStock: 15,
                minimumStock: 5,
            },
            {
                name: 'Heavy Cream',
                description: 'Rich heavy cream for specialty drinks',
                stockUnit: UnitsType.LITER,
                currentStock: 10,
                minimumStock: 3,
            },
            {
                name: 'Sugar',
                description: 'White granulated sugar',
                stockUnit: UnitsType.GRAM,
                currentStock: 10000,
                minimumStock: 2000,
            },
            {
                name: 'Brown Sugar',
                description: 'Brown sugar for specialty drinks',
                stockUnit: UnitsType.GRAM,
                currentStock: 5000,
                minimumStock: 1000,
            },
            {
                name: 'Honey',
                description: 'Natural honey sweetener',
                stockUnit: UnitsType.GRAM,
                currentStock: 3000,
                minimumStock: 500,
            },
            {
                name: 'Vanilla Syrup',
                description: 'Vanilla flavored syrup',
                stockUnit: UnitsType.LITER,
                currentStock: 5,
                minimumStock: 1,
            },
            {
                name: 'Caramel Syrup',
                description: 'Caramel flavored syrup',
                stockUnit: UnitsType.LITER,
                currentStock: 5,
                minimumStock: 1,
            },
            {
                name: 'Hazelnut Syrup',
                description: 'Hazelnut flavored syrup',
                stockUnit: UnitsType.LITER,
                currentStock: 4,
                minimumStock: 1,
            },
            {
                name: 'Chocolate Syrup',
                description: 'Rich chocolate syrup',
                stockUnit: UnitsType.LITER,
                currentStock: 5,
                minimumStock: 1,
            },
            {
                name: 'Cocoa Powder',
                description: 'Pure cocoa powder',
                stockUnit: UnitsType.GRAM,
                currentStock: 2000,
                minimumStock: 500,
            },
            {
                name: 'Whipped Cream',
                description: 'Fresh whipped cream',
                stockUnit: UnitsType.LITER,
                currentStock: 8,
                minimumStock: 2,
            },
            {
                name: 'Cinnamon Powder',
                description: 'Ground cinnamon',
                stockUnit: UnitsType.GRAM,
                currentStock: 500,
                minimumStock: 100,
            },
            {
                name: 'Matcha Powder',
                description: 'Premium matcha green tea powder',
                stockUnit: UnitsType.GRAM,
                currentStock: 1000,
                minimumStock: 200,
            },
            {
                name: 'Black Tea Leaves',
                description: 'Premium black tea',
                stockUnit: UnitsType.GRAM,
                currentStock: 2000,
                minimumStock: 500,
            },
            {
                name: 'Green Tea Leaves',
                description: 'Premium green tea',
                stockUnit: UnitsType.GRAM,
                currentStock: 1500,
                minimumStock: 300,
            },
            {
                name: 'Chai Tea Mix',
                description: 'Spiced chai tea blend',
                stockUnit: UnitsType.GRAM,
                currentStock: 1000,
                minimumStock: 200,
            },
            {
                name: 'Ice Cubes',
                description: 'Frozen water cubes',
                stockUnit: UnitsType.GRAM,
                currentStock: 20000,
                minimumStock: 5000,
            },
            {
                name: 'Mint Leaves',
                description: 'Fresh mint leaves',
                stockUnit: UnitsType.GRAM,
                currentStock: 300,
                minimumStock: 50,
            },
            {
                name: 'Lemon',
                description: 'Fresh lemons',
                stockUnit: UnitsType.GRAM,
                currentStock: 2000,
                minimumStock: 500,
            },
            {
                name: 'Orange',
                description: 'Fresh oranges',
                stockUnit: UnitsType.GRAM,
                currentStock: 3000,
                minimumStock: 500,
            },
            {
                name: 'Strawberry',
                description: 'Fresh strawberries',
                stockUnit: UnitsType.GRAM,
                currentStock: 2000,
                minimumStock: 300,
            },
            {
                name: 'Banana',
                description: 'Fresh bananas',
                stockUnit: UnitsType.GRAM,
                currentStock: 2500,
                minimumStock: 400,
            },
            {
                name: 'Water',
                description: 'Filtered water',
                stockUnit: UnitsType.LITER,
                currentStock: 100,
                minimumStock: 20,
            },
        ];

        const ingredients = ingredientRepo.create(ingredientsData);
        return await ingredientRepo.save(ingredients);
    }

    private async seedCategories(connection: DataSource): Promise<Category[]> {
        const categoryRepo = connection.getRepository(Category);

        const existing = await categoryRepo.find();
        if (existing.length > 0) {
            return existing;
        }

        const categoriesData = [
            {
                name: 'Hot Drinks',
                description: 'Hot beverages including coffee, tea, and specialty drinks',
                image: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=600&h=400&fit=crop',
            },
            {
                name: 'Cold Drinks',
                description: 'Refreshing cold beverages and iced drinks',
                image: 'https://images.unsplash.com/photo-1546173159-315724a31696?w=600&h=400&fit=crop',
            },
            {
                name: 'Appetizers',
                description: 'Delicious starters and small bites to begin your meal',
                image: 'https://images.unsplash.com/photo-1541529086526-db283c563270?w=600&h=400&fit=crop',
            },
            {
                name: 'Main Courses',
                description: 'Hearty and satisfying main dishes',
                image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600&h=400&fit=crop',
            },
            {
                name: 'Pizzas',
                description: 'Wood-fired pizzas with authentic Italian flavors',
                image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&h=400&fit=crop',
            },
            {
                name: 'Burgers',
                description: 'Juicy gourmet burgers made with premium ingredients',
                image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&h=400&fit=crop',
            },
            {
                name: 'Pasta',
                description: 'Fresh homemade pasta with traditional sauces',
                image: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=600&h=400&fit=crop',
            },
            {
                name: 'Salads',
                description: 'Fresh and healthy salad options',
                image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&h=400&fit=crop',
            },
            {
                name: 'Seafood',
                description: 'Fresh catch of the day and seafood specialties',
                image: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=600&h=400&fit=crop',
            },
            {
                name: 'Desserts',
                description: 'Sweet treats and decadent desserts',
                image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=600&h=400&fit=crop',
            },
            {
                name: 'Beverages',
                description: 'Refreshing drinks, coffee, and specialty beverages',
                image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=600&h=400&fit=crop',
            },
            {
                name: 'Breakfast',
                description: 'Start your day right with our breakfast menu',
                image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=600&h=400&fit=crop',
            },
            {
                name: 'Soups',
                description: 'Warm and comforting soups',
                image: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&h=400&fit=crop',
            },
            {
                name: 'Grilled',
                description: 'Perfectly grilled meats and vegetables',
                image: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600&h=400&fit=crop',
            },
        ];

        const categories = categoryRepo.create(categoriesData);
        return await categoryRepo.save(categories);
    }

    private async seedArticles(connection: DataSource, categories: Category[]): Promise<Article[]> {
        const articleRepo = connection.getRepository(Article);

        const existing = await articleRepo.find();
        if (existing.length > 0) {
            return existing;
        }

        const categoryMap = new Map(
            categories.map((cat) => [cat.name, cat])
        );

        const articlesData = [
            // Hot Drinks - Coffee
            {
                name: 'Espresso',
                description: 'Rich and intense Italian espresso shot',
                image: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=600&h=400&fit=crop',
                price: 3.50,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Double Espresso',
                description: 'Two shots of intense espresso',
                image: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600&h=400&fit=crop',
                price: 5.00,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Cappuccino',
                description: 'Espresso with steamed milk and thick foam',
                image: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=600&h=400&fit=crop',
                price: 4.50,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Café Latte',
                description: 'Smooth espresso with steamed milk',
                image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600&h=400&fit=crop',
                price: 4.75,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Macchiato',
                description: 'Espresso marked with a dollop of foam',
                image: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=600&h=400&fit=crop',
                price: 4.00,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Caramel Macchiato',
                description: 'Vanilla-flavored latte marked with espresso and caramel',
                image: 'https://images.unsplash.com/photo-1599750754064-1e4c6ccb2d66?w=600&h=400&fit=crop',
                price: 5.50,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Flat White',
                description: 'Espresso with microfoam milk',
                image: 'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?w=600&h=400&fit=crop',
                price: 4.75,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Americano',
                description: 'Espresso diluted with hot water',
                image: 'https://images.unsplash.com/photo-1532004491497-ba35c367d634?w=600&h=400&fit=crop',
                price: 3.75,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Mocha',
                description: 'Espresso with chocolate and steamed milk',
                image: 'https://images.unsplash.com/photo-1607260550778-aa9d29444ce1?w=600&h=400&fit=crop',
                price: 5.25,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Vanilla Latte',
                description: 'Latte with vanilla syrup',
                image: 'https://images.unsplash.com/photo-1611854779393-1b2da9d400fe?w=600&h=400&fit=crop',
                price: 5.00,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Hazelnut Latte',
                description: 'Latte with hazelnut syrup',
                image: 'https://images.unsplash.com/photo-1578374173703-2f951a6e2f1d?w=600&h=400&fit=crop',
                price: 5.00,
                category: categoryMap.get('Hot Drinks'),
            },

            // Hot Drinks - Tea
            {
                name: 'Black Tea',
                description: 'Classic black tea',
                image: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=600&h=400&fit=crop',
                price: 3.00,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Green Tea',
                description: 'Refreshing green tea',
                image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&h=400&fit=crop',
                price: 3.00,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Chai Latte',
                description: 'Spiced tea with steamed milk',
                image: 'https://images.unsplash.com/photo-1578374173703-2f951a6e2f1d?w=600&h=400&fit=crop',
                price: 4.50,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Matcha Latte',
                description: 'Japanese green tea powder with steamed milk',
                image: 'https://images.unsplash.com/photo-1536013564575-1bc2bafb4a71?w=600&h=400&fit=crop',
                price: 5.50,
                category: categoryMap.get('Hot Drinks'),
            },
            {
                name: 'Hot Chocolate',
                description: 'Rich hot chocolate with whipped cream',
                image: 'https://images.unsplash.com/photo-1517578239113-b03992dcdd25?w=600&h=400&fit=crop',
                price: 4.50,
                category: categoryMap.get('Hot Drinks'),
            },

            // Cold Drinks - Coffee
            {
                name: 'Iced Espresso',
                description: 'Espresso served over ice',
                image: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=600&h=400&fit=crop',
                price: 4.00,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Iced Latte',
                description: 'Espresso with cold milk over ice',
                image: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=600&h=400&fit=crop',
                price: 5.00,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Iced Cappuccino',
                description: 'Cold version of classic cappuccino',
                image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600&h=400&fit=crop',
                price: 4.75,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Iced Americano',
                description: 'Espresso with cold water over ice',
                image: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=600&h=400&fit=crop',
                price: 4.25,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Iced Mocha',
                description: 'Chocolate espresso drink over ice',
                image: 'https://images.unsplash.com/photo-1578374173703-2f951a6e2f1d?w=600&h=400&fit=crop',
                price: 5.50,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Iced Caramel Macchiato',
                description: 'Iced vanilla latte with caramel drizzle',
                image: 'https://images.unsplash.com/photo-1599750754064-1e4c6ccb2d66?w=600&h=400&fit=crop',
                price: 5.75,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Cold Brew Coffee',
                description: 'Smooth cold-steeped coffee',
                image: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=600&h=400&fit=crop',
                price: 4.50,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Frappuccino',
                description: 'Blended iced coffee with whipped cream',
                image: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&h=400&fit=crop',
                price: 6.00,
                category: categoryMap.get('Cold Drinks'),
            },

            // Cold Drinks - Other
            {
                name: 'Iced Tea',
                description: 'Refreshing iced tea with lemon',
                image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&h=400&fit=crop',
                price: 3.99,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Iced Green Tea',
                description: 'Chilled green tea',
                image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&h=400&fit=crop',
                price: 3.99,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Iced Matcha Latte',
                description: 'Matcha green tea with cold milk over ice',
                image: 'https://images.unsplash.com/photo-1536013564575-1bc2bafb4a71?w=600&h=400&fit=crop',
                price: 5.75,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Lemonade',
                description: 'Freshly squeezed lemonade',
                image: 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f1e?w=600&h=400&fit=crop',
                price: 4.50,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Orange Juice',
                description: 'Freshly squeezed orange juice',
                image: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=600&h=400&fit=crop',
                price: 5.00,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Strawberry Smoothie',
                description: 'Blended strawberry smoothie',
                image: 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=600&h=400&fit=crop',
                price: 6.50,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Banana Smoothie',
                description: 'Creamy banana smoothie',
                image: 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=600&h=400&fit=crop',
                price: 6.50,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Mixed Berry Smoothie',
                description: 'Blend of strawberries and berries',
                image: 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=600&h=400&fit=crop',
                price: 6.50,
                category: categoryMap.get('Cold Drinks'),
            },
            {
                name: 'Mint Lemonade',
                description: 'Refreshing lemonade with fresh mint',
                image: 'https://images.unsplash.com/photo-1523677011781-c91d1bbe2f1e?w=600&h=400&fit=crop',
                price: 4.75,
                category: categoryMap.get('Cold Drinks'),
            },

            // Appetizers
            {
                name: 'Bruschetta',
                description: 'Toasted bread topped with fresh tomatoes, garlic, basil, and olive oil',
                image: 'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=600&h=400&fit=crop',
                price: 8.99,
                category: categoryMap.get('Appetizers'),
            },
            {
                name: 'Mozzarella Sticks',
                description: 'Crispy breaded mozzarella served with marinara sauce',
                image: 'https://images.unsplash.com/photo-1531749668029-2db88e4276c7?w=600&h=400&fit=crop',
                price: 7.50,
                category: categoryMap.get('Appetizers'),
            },
            {
                name: 'Chicken Wings',
                description: 'Buffalo wings with blue cheese dip and celery sticks',
                image: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=600&h=400&fit=crop',
                price: 12.99,
                category: categoryMap.get('Appetizers'),
            },
            {
                name: 'Calamari Fritti',
                description: 'Crispy fried squid rings with lemon aioli',
                image: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=600&h=400&fit=crop',
                price: 13.50,
                category: categoryMap.get('Appetizers'),
            },
            {
                name: 'Spring Rolls',
                description: 'Vegetable spring rolls with sweet chili sauce',
                image: 'https://images.unsplash.com/photo-1625943553852-781c6dd46faa?w=600&h=400&fit=crop',
                price: 6.99,
                category: categoryMap.get('Appetizers'),
            },

            // Pizzas
            {
                name: 'Margherita Pizza',
                description: 'Classic pizza with tomato sauce, mozzarella, and fresh basil',
                image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600&h=400&fit=crop',
                price: 14.99,
                category: categoryMap.get('Pizzas'),
            },
            {
                name: 'Pepperoni Pizza',
                description: 'Loaded with pepperoni and extra cheese',
                image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600&h=400&fit=crop',
                price: 16.99,
                category: categoryMap.get('Pizzas'),
            },
            {
                name: 'Four Cheese Pizza',
                description: 'Mozzarella, parmesan, gorgonzola, and ricotta',
                image: 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=600&h=400&fit=crop',
                price: 17.50,
                category: categoryMap.get('Pizzas'),
            },
            {
                name: 'Hawaiian Pizza',
                description: 'Ham, pineapple, and mozzarella',
                image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&h=400&fit=crop',
                price: 15.99,
                category: categoryMap.get('Pizzas'),
            },
            {
                name: 'BBQ Chicken Pizza',
                description: 'Grilled chicken, BBQ sauce, red onions, and cilantro',
                image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600&h=400&fit=crop',
                price: 18.50,
                category: categoryMap.get('Pizzas'),
            },
            {
                name: 'Veggie Supreme Pizza',
                description: 'Bell peppers, mushrooms, olives, onions, and tomatoes',
                image: 'https://images.unsplash.com/photo-1511689660979-10d2b1aada49?w=600&h=400&fit=crop',
                price: 16.50,
                category: categoryMap.get('Pizzas'),
            },

            // Burgers
            {
                name: 'Classic Beef Burger',
                description: 'Angus beef patty with lettuce, tomato, onion, and special sauce',
                image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&h=400&fit=crop',
                price: 13.99,
                category: categoryMap.get('Burgers'),
            },
            {
                name: 'Cheeseburger Deluxe',
                description: 'Double beef patty with cheddar, bacon, and caramelized onions',
                image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&h=400&fit=crop',
                price: 16.99,
                category: categoryMap.get('Burgers'),
            },
            {
                name: 'Mushroom Swiss Burger',
                description: 'Beef patty topped with sautéed mushrooms and Swiss cheese',
                image: 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=600&h=400&fit=crop',
                price: 15.50,
                category: categoryMap.get('Burgers'),
            },
            {
                name: 'Chicken Burger',
                description: 'Grilled chicken breast with avocado and chipotle mayo',
                image: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=600&h=400&fit=crop',
                price: 14.50,
                category: categoryMap.get('Burgers'),
            },
            {
                name: 'Veggie Burger',
                description: 'Plant-based patty with all the fixings',
                image: 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=600&h=400&fit=crop',
                price: 12.99,
                category: categoryMap.get('Burgers'),
            },

            // Pasta
            {
                name: 'Spaghetti Carbonara',
                description: 'Creamy pasta with pancetta, egg, and parmesan',
                image: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=600&h=400&fit=crop',
                price: 16.50,
                category: categoryMap.get('Pasta'),
            },
            {
                name: 'Fettuccine Alfredo',
                description: 'Rich and creamy Alfredo sauce with fettuccine',
                image: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?w=600&h=400&fit=crop',
                price: 15.99,
                category: categoryMap.get('Pasta'),
            },
            {
                name: 'Penne Arrabbiata',
                description: 'Spicy tomato sauce with garlic and chili',
                image: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=600&h=400&fit=crop',
                price: 14.50,
                category: categoryMap.get('Pasta'),
            },
            {
                name: 'Lasagna Bolognese',
                description: 'Layered pasta with meat sauce and béchamel',
                image: 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=600&h=400&fit=crop',
                price: 17.99,
                category: categoryMap.get('Pasta'),
            },
            {
                name: 'Seafood Linguine',
                description: 'Mixed seafood with white wine and garlic sauce',
                image: 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=600&h=400&fit=crop',
                price: 22.50,
                category: categoryMap.get('Pasta'),
            },

            // Main Courses
            {
                name: 'Grilled Ribeye Steak',
                description: '12oz ribeye with garlic butter and seasonal vegetables',
                image: 'https://images.unsplash.com/photo-1558030006-450675393462?w=600&h=400&fit=crop',
                price: 32.99,
                category: categoryMap.get('Main Courses'),
            },
            {
                name: 'Roasted Chicken',
                description: 'Half roasted chicken with herbs and roasted potatoes',
                image: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=600&h=400&fit=crop',
                price: 19.99,
                category: categoryMap.get('Main Courses'),
            },
            {
                name: 'Pork Tenderloin',
                description: 'Pan-seared pork with apple cider reduction',
                image: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&h=400&fit=crop',
                price: 24.50,
                category: categoryMap.get('Main Courses'),
            },
            {
                name: 'Lamb Chops',
                description: 'Grilled lamb chops with mint sauce',
                image: 'https://images.unsplash.com/photo-1595777216583-96e8045d89a0?w=600&h=400&fit=crop',
                price: 28.99,
                category: categoryMap.get('Main Courses'),
            },

            // Salads
            {
                name: 'Caesar Salad',
                description: 'Romaine lettuce, croutons, parmesan, and Caesar dressing',
                image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=600&h=400&fit=crop',
                price: 10.99,
                category: categoryMap.get('Salads'),
            },
            {
                name: 'Greek Salad',
                description: 'Tomatoes, cucumber, olives, feta, and olive oil',
                image: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=600&h=400&fit=crop',
                price: 11.50,
                category: categoryMap.get('Salads'),
            },
            {
                name: 'Caprese Salad',
                description: 'Fresh mozzarella, tomatoes, and basil',
                image: 'https://images.unsplash.com/photo-1592417817098-8fd3d9eb14a5?w=600&h=400&fit=crop',
                price: 12.99,
                category: categoryMap.get('Salads'),
            },
            {
                name: 'Cobb Salad',
                description: 'Chicken, bacon, egg, avocado, and blue cheese',
                image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600&h=400&fit=crop',
                price: 14.50,
                category: categoryMap.get('Salads'),
            },

            // Seafood
            {
                name: 'Grilled Salmon',
                description: 'Atlantic salmon with lemon butter sauce',
                image: 'https://images.unsplash.com/photo-1485921325833-c519f76c4927?w=600&h=400&fit=crop',
                price: 24.99,
                category: categoryMap.get('Seafood'),
            },
            {
                name: 'Fish and Chips',
                description: 'Beer-battered fish with crispy fries',
                image: 'https://images.unsplash.com/photo-1579208575657-c595a05383b7?w=600&h=400&fit=crop',
                price: 16.99,
                category: categoryMap.get('Seafood'),
            },
            {
                name: 'Shrimp Scampi',
                description: 'Sautéed shrimp in garlic butter sauce',
                image: 'https://images.unsplash.com/photo-1633504581786-316c8002b1b9?w=600&h=400&fit=crop',
                price: 21.50,
                category: categoryMap.get('Seafood'),
            },
            {
                name: 'Lobster Tail',
                description: 'Grilled lobster tail with drawn butter',
                image: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=600&h=400&fit=crop',
                price: 38.99,
                category: categoryMap.get('Seafood'),
            },
            {
                name: 'Seafood Platter',
                description: 'Mixed seafood including prawns, mussels, and calamari',
                image: 'https://images.unsplash.com/photo-1615141982883-c7ad0e69fd62?w=600&h=400&fit=crop',
                price: 34.50,
                category: categoryMap.get('Seafood'),
            },

            // Desserts
            {
                name: 'Tiramisu',
                description: 'Classic Italian coffee-flavored dessert',
                image: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=600&h=400&fit=crop',
                price: 8.99,
                category: categoryMap.get('Desserts'),
            },
            {
                name: 'Chocolate Lava Cake',
                description: 'Warm chocolate cake with molten center',
                image: 'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=600&h=400&fit=crop',
                price: 9.50,
                category: categoryMap.get('Desserts'),
            },
            {
                name: 'Cheesecake',
                description: 'New York style cheesecake with berry compote',
                image: 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=600&h=400&fit=crop',
                price: 8.50,
                category: categoryMap.get('Desserts'),
            },
            {
                name: 'Crème Brûlée',
                description: 'Vanilla custard with caramelized sugar',
                image: 'https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?w=600&h=400&fit=crop',
                price: 9.99,
                category: categoryMap.get('Desserts'),
            },
            {
                name: 'Ice Cream Sundae',
                description: 'Three scoops with toppings and whipped cream',
                image: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=600&h=400&fit=crop',
                price: 7.50,
                category: categoryMap.get('Desserts'),
            },

            // Beverages
            {
                name: 'Espresso',
                description: 'Rich Italian espresso',
                image: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=600&h=400&fit=crop',
                price: 3.50,
                category: categoryMap.get('Beverages'),
            },
            {
                name: 'Cappuccino',
                description: 'Espresso with steamed milk and foam',
                image: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=600&h=400&fit=crop',
                price: 4.50,
                category: categoryMap.get('Beverages'),
            },
            {
                name: 'Fresh Orange Juice',
                description: 'Freshly squeezed orange juice',
                image: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=600&h=400&fit=crop',
                price: 5.00,
                category: categoryMap.get('Beverages'),
            },
            {
                name: 'Iced Tea',
                description: 'Refreshing iced tea with lemon',
                image: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=600&h=400&fit=crop',
                price: 3.99,
                category: categoryMap.get('Beverages'),
            },
            {
                name: 'Smoothie',
                description: 'Mixed berry smoothie',
                image: 'https://images.unsplash.com/photo-1505252585461-04db1eb84625?w=600&h=400&fit=crop',
                price: 6.50,
                category: categoryMap.get('Beverages'),
            },

            // Breakfast
            {
                name: 'Full English Breakfast',
                description: 'Eggs, bacon, sausage, beans, toast, and tomatoes',
                image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=600&h=400&fit=crop',
                price: 14.99,
                category: categoryMap.get('Breakfast'),
            },
            {
                name: 'Pancakes',
                description: 'Stack of fluffy pancakes with maple syrup',
                image: 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=600&h=400&fit=crop',
                price: 10.99,
                category: categoryMap.get('Breakfast'),
            },
            {
                name: 'Eggs Benedict',
                description: 'Poached eggs with hollandaise on English muffin',
                image: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=600&h=400&fit=crop',
                price: 13.50,
                category: categoryMap.get('Breakfast'),
            },
            {
                name: 'Avocado Toast',
                description: 'Smashed avocado on sourdough with poached egg',
                image: 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=600&h=400&fit=crop',
                price: 11.99,
                category: categoryMap.get('Breakfast'),
            },

            // Soups
            {
                name: 'French Onion Soup',
                description: 'Caramelized onions with melted cheese',
                image: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=600&h=400&fit=crop',
                price: 8.50,
                category: categoryMap.get('Soups'),
            },
            {
                name: 'Tomato Soup',
                description: 'Creamy tomato soup with basil',
                image: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=600&h=400&fit=crop',
                price: 7.50,
                category: categoryMap.get('Soups'),
            },
            {
                name: 'Chicken Noodle Soup',
                description: 'Homemade chicken soup with vegetables',
                image: 'https://images.unsplash.com/photo-1613844237701-8f3664fc2eff?w=600&h=400&fit=crop',
                price: 8.99,
                category: categoryMap.get('Soups'),
            },

            // Grilled
            {
                name: 'BBQ Ribs',
                description: 'Slow-cooked ribs with BBQ sauce',
                image: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&h=400&fit=crop',
                price: 26.99,
                category: categoryMap.get('Grilled'),
            },
            {
                name: 'Grilled Vegetables',
                description: 'Seasonal vegetables with balsamic glaze',
                image: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600&h=400&fit=crop',
                price: 12.50,
                category: categoryMap.get('Grilled'),
            },
            {
                name: 'Mixed Grill Platter',
                description: 'Combination of grilled meats and sausages',
                image: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600&h=400&fit=crop',
                price: 29.99,
                category: categoryMap.get('Grilled'),
            },
        ];

        const articles = articleRepo.create(articlesData);
        return await articleRepo.save(articles);
    }

    private async seedArticleCompositions(
        connection: DataSource,
        articles: Article[],
        ingredients: Ingredient[]
    ): Promise<void> {
        const articleCompoRepo = connection.getRepository(ArticleCompo);

        const existing = await articleCompoRepo.find();
        if (existing.length > 0) {
            return;
        }

        // Create a map for easy ingredient lookup
        const ingredientMap = new Map(ingredients.map(ing => [ing.name, ing]));
        const articleMap = new Map(articles.map(art => [art.name, art]));

        const compositions: Array<{
            article: Article;
            Ingredient: Ingredient | undefined;
            quantity: number;
        }> = [];

        // Espresso - 18g coffee beans
        const espresso = articleMap.get('Espresso');
        if (espresso) {
            compositions.push({
                article: espresso,
                Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                quantity: 18,
            });
        }

        // Double Espresso - 36g coffee beans
        const doubleEspresso = articleMap.get('Double Espresso');
        if (doubleEspresso) {
            compositions.push({
                article: doubleEspresso,
                Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                quantity: 36,
            });
        }

        // Cappuccino - 18g coffee, 120ml milk
        const cappuccino = articleMap.get('Cappuccino');
        if (cappuccino) {
            compositions.push(
                {
                    article: cappuccino,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: cappuccino,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.12,
                }
            );
        }

        // Café Latte - 18g coffee, 200ml milk
        const latte = articleMap.get('Café Latte');
        if (latte) {
            compositions.push(
                {
                    article: latte,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: latte,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                }
            );
        }

        // Macchiato - 18g coffee, 30ml milk
        const macchiato = articleMap.get('Macchiato');
        if (macchiato) {
            compositions.push(
                {
                    article: macchiato,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: macchiato,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.03,
                }
            );
        }

        // Caramel Macchiato - 18g coffee, 200ml milk, 30ml vanilla syrup, 20ml caramel syrup
        const caramelMacchiato = articleMap.get('Caramel Macchiato');
        if (caramelMacchiato) {
            compositions.push(
                {
                    article: caramelMacchiato,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: caramelMacchiato,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: caramelMacchiato,
                    Ingredient: ingredientMap.get('Vanilla Syrup'),
                    quantity: 0.03,
                },
                {
                    article: caramelMacchiato,
                    Ingredient: ingredientMap.get('Caramel Syrup'),
                    quantity: 0.02,
                }
            );
        }

        // Flat White - 36g coffee, 150ml milk
        const flatWhite = articleMap.get('Flat White');
        if (flatWhite) {
            compositions.push(
                {
                    article: flatWhite,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 36,
                },
                {
                    article: flatWhite,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.15,
                }
            );
        }

        // Americano - 18g coffee, 180ml water
        const americano = articleMap.get('Americano');
        if (americano) {
            compositions.push(
                {
                    article: americano,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: americano,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.18,
                }
            );
        }

        // Mocha - 18g coffee, 150ml milk, 30ml chocolate syrup, whipped cream
        const mocha = articleMap.get('Mocha');
        if (mocha) {
            compositions.push(
                {
                    article: mocha,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: mocha,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.15,
                },
                {
                    article: mocha,
                    Ingredient: ingredientMap.get('Chocolate Syrup'),
                    quantity: 0.03,
                },
                {
                    article: mocha,
                    Ingredient: ingredientMap.get('Whipped Cream'),
                    quantity: 0.02,
                }
            );
        }

        // Vanilla Latte - 18g coffee, 200ml milk, 30ml vanilla syrup
        const vanillaLatte = articleMap.get('Vanilla Latte');
        if (vanillaLatte) {
            compositions.push(
                {
                    article: vanillaLatte,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: vanillaLatte,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: vanillaLatte,
                    Ingredient: ingredientMap.get('Vanilla Syrup'),
                    quantity: 0.03,
                }
            );
        }

        // Hazelnut Latte - 18g coffee, 200ml milk, 30ml hazelnut syrup
        const hazelnutLatte = articleMap.get('Hazelnut Latte');
        if (hazelnutLatte) {
            compositions.push(
                {
                    article: hazelnutLatte,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: hazelnutLatte,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: hazelnutLatte,
                    Ingredient: ingredientMap.get('Hazelnut Syrup'),
                    quantity: 0.03,
                }
            );
        }

        // Black Tea - 3g tea leaves, 250ml water
        const blackTea = articleMap.get('Black Tea');
        if (blackTea) {
            compositions.push(
                {
                    article: blackTea,
                    Ingredient: ingredientMap.get('Black Tea Leaves'),
                    quantity: 3,
                },
                {
                    article: blackTea,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.25,
                }
            );
        }

        // Green Tea - 3g tea leaves, 250ml water
        const greenTea = articleMap.get('Green Tea');
        if (greenTea) {
            compositions.push(
                {
                    article: greenTea,
                    Ingredient: ingredientMap.get('Green Tea Leaves'),
                    quantity: 3,
                },
                {
                    article: greenTea,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.25,
                }
            );
        }

        // Chai Latte - 5g chai mix, 200ml milk, 10g honey
        const chaiLatte = articleMap.get('Chai Latte');
        if (chaiLatte) {
            compositions.push(
                {
                    article: chaiLatte,
                    Ingredient: ingredientMap.get('Chai Tea Mix'),
                    quantity: 5,
                },
                {
                    article: chaiLatte,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: chaiLatte,
                    Ingredient: ingredientMap.get('Honey'),
                    quantity: 10,
                }
            );
        }

        // Matcha Latte - 3g matcha powder, 200ml milk, 10g honey
        const matchaLatte = articleMap.get('Matcha Latte');
        if (matchaLatte) {
            compositions.push(
                {
                    article: matchaLatte,
                    Ingredient: ingredientMap.get('Matcha Powder'),
                    quantity: 3,
                },
                {
                    article: matchaLatte,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: matchaLatte,
                    Ingredient: ingredientMap.get('Honey'),
                    quantity: 10,
                }
            );
        }

        // Hot Chocolate - 20g cocoa powder, 200ml milk, 15g sugar, whipped cream
        const hotChocolate = articleMap.get('Hot Chocolate');
        if (hotChocolate) {
            compositions.push(
                {
                    article: hotChocolate,
                    Ingredient: ingredientMap.get('Cocoa Powder'),
                    quantity: 20,
                },
                {
                    article: hotChocolate,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: hotChocolate,
                    Ingredient: ingredientMap.get('Sugar'),
                    quantity: 15,
                },
                {
                    article: hotChocolate,
                    Ingredient: ingredientMap.get('Whipped Cream'),
                    quantity: 0.02,
                }
            );
        }

        // Iced Espresso - 18g coffee, 100g ice
        const icedEspresso = articleMap.get('Iced Espresso');
        if (icedEspresso) {
            compositions.push(
                {
                    article: icedEspresso,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: icedEspresso,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                }
            );
        }

        // Iced Latte - 18g coffee, 200ml milk, 100g ice
        const icedLatte = articleMap.get('Iced Latte');
        if (icedLatte) {
            compositions.push(
                {
                    article: icedLatte,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: icedLatte,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: icedLatte,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                }
            );
        }

        // Iced Cappuccino - 18g coffee, 120ml milk, 100g ice
        const icedCappuccino = articleMap.get('Iced Cappuccino');
        if (icedCappuccino) {
            compositions.push(
                {
                    article: icedCappuccino,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: icedCappuccino,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.12,
                },
                {
                    article: icedCappuccino,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                }
            );
        }

        // Iced Americano - 18g coffee, 180ml water, 100g ice
        const icedAmericano = articleMap.get('Iced Americano');
        if (icedAmericano) {
            compositions.push(
                {
                    article: icedAmericano,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: icedAmericano,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.18,
                },
                {
                    article: icedAmericano,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                }
            );
        }

        // Iced Mocha - 18g coffee, 150ml milk, 30ml chocolate syrup, ice, whipped cream
        const icedMocha = articleMap.get('Iced Mocha');
        if (icedMocha) {
            compositions.push(
                {
                    article: icedMocha,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: icedMocha,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.15,
                },
                {
                    article: icedMocha,
                    Ingredient: ingredientMap.get('Chocolate Syrup'),
                    quantity: 0.03,
                },
                {
                    article: icedMocha,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                },
                {
                    article: icedMocha,
                    Ingredient: ingredientMap.get('Whipped Cream'),
                    quantity: 0.02,
                }
            );
        }

        // Iced Caramel Macchiato - 18g coffee, 200ml milk, vanilla, caramel, ice
        const icedCaramelMacchiato = articleMap.get('Iced Caramel Macchiato');
        if (icedCaramelMacchiato) {
            compositions.push(
                {
                    article: icedCaramelMacchiato,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: icedCaramelMacchiato,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: icedCaramelMacchiato,
                    Ingredient: ingredientMap.get('Vanilla Syrup'),
                    quantity: 0.03,
                },
                {
                    article: icedCaramelMacchiato,
                    Ingredient: ingredientMap.get('Caramel Syrup'),
                    quantity: 0.02,
                },
                {
                    article: icedCaramelMacchiato,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                }
            );
        }

        // Cold Brew Coffee - 25g coffee beans (cold brew uses more), 250ml water, ice
        const coldBrew = articleMap.get('Cold Brew Coffee');
        if (coldBrew) {
            compositions.push(
                {
                    article: coldBrew,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 25,
                },
                {
                    article: coldBrew,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.25,
                },
                {
                    article: coldBrew,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                }
            );
        }

        // Frappuccino - 18g coffee, 150ml milk, 30ml vanilla syrup, ice, whipped cream
        const frappuccino = articleMap.get('Frappuccino');
        if (frappuccino) {
            compositions.push(
                {
                    article: frappuccino,
                    Ingredient: ingredientMap.get('Coffee Beans (Arabica)'),
                    quantity: 18,
                },
                {
                    article: frappuccino,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.15,
                },
                {
                    article: frappuccino,
                    Ingredient: ingredientMap.get('Vanilla Syrup'),
                    quantity: 0.03,
                },
                {
                    article: frappuccino,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 150,
                },
                {
                    article: frappuccino,
                    Ingredient: ingredientMap.get('Whipped Cream'),
                    quantity: 0.03,
                }
            );
        }

        // Iced Tea - 5g tea leaves, 250ml water, ice, lemon
        const icedTea = articleMap.get('Iced Tea');
        if (icedTea) {
            compositions.push(
                {
                    article: icedTea,
                    Ingredient: ingredientMap.get('Black Tea Leaves'),
                    quantity: 5,
                },
                {
                    article: icedTea,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.25,
                },
                {
                    article: icedTea,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                },
                {
                    article: icedTea,
                    Ingredient: ingredientMap.get('Lemon'),
                    quantity: 30,
                }
            );
        }

        // Iced Green Tea - 5g green tea, 250ml water, ice
        const icedGreenTea = articleMap.get('Iced Green Tea');
        if (icedGreenTea) {
            compositions.push(
                {
                    article: icedGreenTea,
                    Ingredient: ingredientMap.get('Green Tea Leaves'),
                    quantity: 5,
                },
                {
                    article: icedGreenTea,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.25,
                },
                {
                    article: icedGreenTea,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                }
            );
        }

        // Iced Matcha Latte - 3g matcha, 200ml milk, ice, honey
        const icedMatchaLatte = articleMap.get('Iced Matcha Latte');
        if (icedMatchaLatte) {
            compositions.push(
                {
                    article: icedMatchaLatte,
                    Ingredient: ingredientMap.get('Matcha Powder'),
                    quantity: 3,
                },
                {
                    article: icedMatchaLatte,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.2,
                },
                {
                    article: icedMatchaLatte,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                },
                {
                    article: icedMatchaLatte,
                    Ingredient: ingredientMap.get('Honey'),
                    quantity: 10,
                }
            );
        }

        // Lemonade - 100g lemon, 250ml water, 30g sugar, ice
        const lemonade = articleMap.get('Lemonade');
        if (lemonade) {
            compositions.push(
                {
                    article: lemonade,
                    Ingredient: ingredientMap.get('Lemon'),
                    quantity: 100,
                },
                {
                    article: lemonade,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.25,
                },
                {
                    article: lemonade,
                    Ingredient: ingredientMap.get('Sugar'),
                    quantity: 30,
                },
                {
                    article: lemonade,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                }
            );
        }

        // Orange Juice - 200g orange
        const orangeJuice = articleMap.get('Orange Juice');
        if (orangeJuice) {
            compositions.push({
                article: orangeJuice,
                Ingredient: ingredientMap.get('Orange'),
                quantity: 200,
            });
        }

        // Strawberry Smoothie - 150g strawberry, 100ml milk, 50g ice
        const strawberrySmoothie = articleMap.get('Strawberry Smoothie');
        if (strawberrySmoothie) {
            compositions.push(
                {
                    article: strawberrySmoothie,
                    Ingredient: ingredientMap.get('Strawberry'),
                    quantity: 150,
                },
                {
                    article: strawberrySmoothie,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.1,
                },
                {
                    article: strawberrySmoothie,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 50,
                }
            );
        }

        // Banana Smoothie - 150g banana, 100ml milk, 50g ice
        const bananaSmoothie = articleMap.get('Banana Smoothie');
        if (bananaSmoothie) {
            compositions.push(
                {
                    article: bananaSmoothie,
                    Ingredient: ingredientMap.get('Banana'),
                    quantity: 150,
                },
                {
                    article: bananaSmoothie,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.1,
                },
                {
                    article: bananaSmoothie,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 50,
                }
            );
        }

        // Mixed Berry Smoothie - 100g strawberry, 100ml milk, 50g ice
        const mixedBerrySmoothie = articleMap.get('Mixed Berry Smoothie');
        if (mixedBerrySmoothie) {
            compositions.push(
                {
                    article: mixedBerrySmoothie,
                    Ingredient: ingredientMap.get('Strawberry'),
                    quantity: 100,
                },
                {
                    article: mixedBerrySmoothie,
                    Ingredient: ingredientMap.get('Whole Milk'),
                    quantity: 0.1,
                },
                {
                    article: mixedBerrySmoothie,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 50,
                }
            );
        }

        // Mint Lemonade - 100g lemon, 250ml water, 30g sugar, ice, mint
        const mintLemonade = articleMap.get('Mint Lemonade');
        if (mintLemonade) {
            compositions.push(
                {
                    article: mintLemonade,
                    Ingredient: ingredientMap.get('Lemon'),
                    quantity: 100,
                },
                {
                    article: mintLemonade,
                    Ingredient: ingredientMap.get('Water'),
                    quantity: 0.25,
                },
                {
                    article: mintLemonade,
                    Ingredient: ingredientMap.get('Sugar'),
                    quantity: 30,
                },
                {
                    article: mintLemonade,
                    Ingredient: ingredientMap.get('Ice Cubes'),
                    quantity: 100,
                },
                {
                    article: mintLemonade,
                    Ingredient: ingredientMap.get('Mint Leaves'),
                    quantity: 10,
                }
            );
        }

        // Save all compositions
        if (compositions.length > 0) {
            const articleCompositions = articleCompoRepo.create(compositions);
            await articleCompoRepo.save(articleCompositions);
        }
    }

    async clearTenantDatabase(dbName: string): Promise<void> {
        const connection = await this.dbConnectionService.getConnection(dbName);
        const articleCompoRepo = connection.getRepository(ArticleCompo);
        const articleRepo = connection.getRepository(Article);
        const categoryRepo = connection.getRepository(Category);
        const ingredientRepo = connection.getRepository(Ingredient);

        await articleCompoRepo.delete({});
        await articleRepo.delete({});
        await categoryRepo.delete({});
        await ingredientRepo.delete({});
    }
}
