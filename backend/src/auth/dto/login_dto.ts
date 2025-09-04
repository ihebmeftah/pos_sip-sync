import { IsString, IsNotEmpty, IsEmail } from "class-validator";

export class LoginDto {
    @IsString()
    @IsNotEmpty()
    identifier: string;
    @IsString()
    @IsNotEmpty()
    password: string;
}