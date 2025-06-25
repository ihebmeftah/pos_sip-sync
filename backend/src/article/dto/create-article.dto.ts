import { IsDecimal, IsNotEmpty, IsNumber, IsOptional, IsString, IsUrl, IsUUID, Min } from "class-validator";
import { UUID } from "crypto";

export class CreateArticleDto {
    @IsString()
    @IsNotEmpty()
    name: string;
    @IsString()
    @IsOptional()
    description: string;
    @IsUrl()
    @IsNotEmpty()
    @IsString()
    @IsOptional()
    image: string;
    @IsNumber()
    @Min(1)
    price: number;
    @IsUUID()
    categoryId: UUID;
}
