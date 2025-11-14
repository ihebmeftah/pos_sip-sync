import { IsNotEmpty, IsNumber, IsOptional, IsString, IsISO8601 } from "class-validator"

/**
 * CreateBuildingDto
 * 
 * Example payload:
 * {
 *   "name": "Main Building",
 *   "dbName": "main_building_db",
 *   "openingTime": "2025-11-14T08:00:00.000Z",  // ISO 8601 format
 *   "closingTime": "2025-11-14T22:00:00.000Z",  // ISO 8601 format
 *   "location": "123 Main St",
 *   "long": -73.935242,
 *   "lat": 40.730610
 * }
 */
export class CreateBuildingDto {
    @IsNotEmpty()
    @IsString()
    name: string

    @IsNotEmpty()
    @IsString()
    dbName: string

    @IsNotEmpty()
    @IsISO8601()
    openingTime: string

    @IsNotEmpty()
    @IsISO8601()
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
    photos: string[]
}
