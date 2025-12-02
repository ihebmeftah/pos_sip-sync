import { Ingredient } from './../../ingredient/entities/ingredient.entity';
import { UUID } from 'crypto';
import { TimestampBaseEntity } from 'src/database/base/timestampbase';
import { UnitsType } from 'src/enums/units_type';
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Article } from './article.entity';
import { DecimalTransformer } from 'src/utils/decimal-transformer';

@Entity()
export class ArticleCompo extends TimestampBaseEntity {
    @PrimaryGeneratedColumn('uuid')
    id: UUID;
    @ManyToOne(() => Ingredient, { eager: true })
    Ingredient: Ingredient;
    @Column('decimal', { precision: 10, scale: 2, transformer: new DecimalTransformer() })
    quantity: number;
    /*     @Column()
        unit: UnitsType; */
    @ManyToOne(() => Article, article => article.compositions, { eager: false })
    article: Article;
}

