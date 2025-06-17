import { IsArray, IsNotEmpty, IsString, IsUUID } from "class-validator";
import { UUID } from "crypto";

export class CreateOrderDto {
    @IsString()
    @IsNotEmpty()
    @IsUUID()
    tableId: UUID;

    @IsArray()
    @IsNotEmpty()
    @IsUUID("4", { each: true })
    articlesIds: UUID[];
}
