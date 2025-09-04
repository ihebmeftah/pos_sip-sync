import { IsEmail, IsNotEmpty, IsOptional, IsPhoneNumber, IsString, IsUrl, MinLength } from "class-validator";

export class CreateUserDto {
    @IsNotEmpty()
    @IsString()
    firstname: string;
    @IsNotEmpty()
    @IsString()
    lastname: string;
    @IsEmail()
    email: string;
    @IsPhoneNumber("TN")
    phone: string;
    @IsString()
    @IsNotEmpty()
    @MinLength(8)
    password: string;
    @IsNotEmpty()
    @IsString()
    @IsOptional()
    photo: string;

}
