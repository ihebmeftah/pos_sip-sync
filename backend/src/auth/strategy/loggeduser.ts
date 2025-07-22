import { UUID } from "crypto";
import { UserType } from "src/enums/user.roles";

export interface LoggedUser {
    id: UUID;
    email: string;
    type: UserType[];
    role?: string
}