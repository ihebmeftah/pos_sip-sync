import { UUID } from "crypto";
import { UserRole } from "src/enums/user.roles";

export interface LoggedUser {
    id: UUID;
    email: string;
    role: UserRole;
}