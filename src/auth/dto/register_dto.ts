import { IsNotEmpty, IsString, IsIn } from "class-validator";
import { CreateUserDto } from "src/database/base/dto/create-user.dto";

export class RegisterDto extends CreateUserDto {
    @IsNotEmpty()
    @IsString()
    @IsIn(["Client", "Owner"])
    role: "Client" | "Owner";
}