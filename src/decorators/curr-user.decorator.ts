import { createParamDecorator, ExecutionContext } from "@nestjs/common";
import { LoggedUser } from "src/auth/strategy/loggeduser";

export const CurrUser = createParamDecorator(
    (data: unknown, ctx: ExecutionContext): LoggedUser => {
        const request = ctx.switchToHttp().getRequest();
        return request.user as LoggedUser;
    }
);