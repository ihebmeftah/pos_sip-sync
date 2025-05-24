import { IsNotEmpty, IsNumber, IsOptional, IsString, Matches } from "class-validator"

export class CreateBuildingDto {
    @IsNotEmpty()
    @IsString()
    name: string

    /*  @Matches(/^(0[1-9]|1[0-2]):([0-5]\d)\s?(AM|PM)$/, {
          message: 'Time must be in the format HH:MM AM/PM (e.g., 08:00 AM, 11:59 PM)',
      })*/
    @IsNotEmpty()
    @IsString()
    openingTime: string


    @IsNotEmpty()
    @IsString()
    closingTime: string

    @IsNotEmpty()
    @IsString()
    location: string

    @IsOptional()
    @IsNumber()
    long: number

    @IsOptional()
    @IsNumber()
    lat: number

    logo: string
}
