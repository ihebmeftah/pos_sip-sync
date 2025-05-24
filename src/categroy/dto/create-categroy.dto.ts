import { IsNotEmpty, IsOptional, IsString, IsUrl, IsUUID } from "class-validator";
import { UUID } from "crypto";

export class CreateCategroyDto {
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
}
