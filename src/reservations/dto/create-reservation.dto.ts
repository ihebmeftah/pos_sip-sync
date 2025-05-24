import { IsDate, IsDateString, IsNotEmpty, IsNumber, IsOptional, IsPhoneNumber, IsPositive, IsString, IsUUID, Min } from "class-validator";
import { UUID } from "crypto";

export class CreateReservationDto {
    @IsOptional()
    @IsUUID()
    tableId: UUID;
    @IsDateString()
    @IsNotEmpty()
    startTime: Date;
    @IsDateString()
    @IsNotEmpty()
    endTime: Date;
    @IsNotEmpty()
    @IsString()
    customerName: string;
    @IsPhoneNumber("TN")
    @IsNotEmpty()
    customerPhone: number;
    @IsOptional()
    @IsNumber()
    @IsPositive()
    @Min(1)
    price: number;
}
