import { IsNotEmpty, IsNumber, IsOptional, IsString, Min } from "class-validator";

export class CreateIngredientDto {
    @IsNotEmpty()
    @IsString()
    name: string;

    @IsOptional()
    @IsString()
    @IsNotEmpty()
    description: string;

    @IsNotEmpty()
    @IsString()
    stockUnit: string;

    @IsNumber()
    @Min(1)
    currentStock: number; // Current quantity in stock

    @IsOptional()
    @IsNumber()
    @Min(0)
    minimumStock: number; // Alert threshold
}
