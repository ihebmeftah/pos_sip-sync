import { UUID } from 'crypto';
import { Category } from 'src/category/entities/category.entity';
import { TimestampBaseEntity } from 'src/database/base/timestampbase';
import { DecimalTransformer } from 'src/utils/decimal-transformer';
import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { ArticleCompo } from './article-compo.entity';

@Entity()
export class Article extends TimestampBaseEntity {
    @PrimaryGeneratedColumn('uuid')
    id: UUID;
    @Column()
    name: string;
    @Column({ nullable: true })
    description: string;
    @Column({ nullable: true })
    image: string;
    @Column({ type: 'decimal', precision: 10, scale: 2, transformer: new DecimalTransformer() })
    price: number;
    @ManyToOne(() => Category)
    category: Category;
    @OneToMany(
        () => ArticleCompo,
        (articleCompo) => articleCompo.article,
        { nullable: true, cascade: true, eager: true })
    compositions: ArticleCompo[];
}