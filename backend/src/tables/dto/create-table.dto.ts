import { IsNumber, IsPositive, Min } from "class-validator";

export class CreateTableDto {
    @IsNumber()
    @Min(1)
    @IsPositive()
    nbTables: number;
    @IsNumber()
    @Min(1)
    @IsPositive()
    seatsMax: number;
}
