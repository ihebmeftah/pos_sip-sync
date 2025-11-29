import { IsEnum, IsNotEmpty, IsNumber, IsOptional, IsString, Min } from "class-validator";
import { UnitsType } from "src/enums/units_type";

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
    @IsEnum(UnitsType)
    stockUnit: UnitsType;

    @IsNumber({}, { message: 'currentStock must be a number' })
    @Min(1.0000000000001, { message: 'currentStock must be greater than 1' })
    currentStock: number; // Current quantity in stock (must be > 1, floats allowed)

    @IsOptional()
    @IsNumber()
    minimumStock: number; // Alert threshold
}
