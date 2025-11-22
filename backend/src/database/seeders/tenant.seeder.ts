import { Injectable, Logger } from '@nestjs/common';
import { DatabaseConnectionService } from '../database-connection.service';
import { DataSource } from 'typeorm';
import { Category } from 'src/category/entities/category.entity';
import { Article } from 'src/article/entities/article.entity';

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

        // Seed categories
        const categories = await this.seedCategories(connection);
        this.logger.log(`✅ Created ${categories.length} categories for ${dbName}`);

        // Seed articles
        const articles = await this.seedArticles(connection, categories);
        this.logger.log(`✅ Created ${articles.length} articles for ${dbName}`);
    }

    private async seedCategories(connection: DataSource): Promise<Category[]> {
        const categoryRepo = connection.getRepository(Category);

        const existing = await categoryRepo.find();
        if (existing.length > 0) {
            return existing;
        }

        const categoriesData = [
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

    async clearTenantDatabase(dbName: string): Promise<void> {
        const connection = await this.dbConnectionService.getConnection(dbName);
        const articleRepo = connection.getRepository(Article);
        const categoryRepo = connection.getRepository(Category);

        await articleRepo.delete({});
        await categoryRepo.delete({});
    }
}
