import { Injectable } from "@nestjs/common";
import { PassportStrategy } from "@nestjs/passport";
import { Strategy, ExtractJwt } from "passport-jwt";
import { LoggedUser } from "./loggeduser";

@Injectable()
export class JWTStrategy extends PassportStrategy(Strategy) {
    constructor() {
        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            ignoreExpiration: false,
            secretOrKey: 'HAD_12X#@',
        });
    }

    async validate(payload: LoggedUser): Promise<LoggedUser> {
        return {
            id: payload.id,
            email: payload.email,
            role: payload.role,
        };
    }
}