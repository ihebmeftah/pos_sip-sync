import { Type } from "class-transformer";
import { IsArray, IsEnum, IsNotEmpty, IsNumber, IsUUID, Min, ValidateNested } from "class-validator";
import { UUID } from "crypto";
import { UnitsType } from "src/enums/units_type";

export class AddComposArticleDto {
    @IsNotEmpty()
    @ValidateNested({ each: true })
    @Type(() => Compos)
    compos: Compos[];
}

class Compos {
    @IsNotEmpty()
    @IsUUID()
    ingradientId: UUID;
    @IsNumber()
    quantity: number;
    /*     @IsNotEmpty()
        @IsEnum(UnitsType)
        unit: UnitsType; */
} 