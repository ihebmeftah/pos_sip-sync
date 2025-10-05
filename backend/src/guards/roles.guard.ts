import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { LoggedUser } from 'src/auth/strategy/loggeduser';
import { ROLES_KEY } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';

@Injectable()
export class RolesGuard implements CanActivate {
    constructor(private reflector: Reflector) { }


    canActivate(context: ExecutionContext): boolean {
        const requiredRoles = this.reflector.getAllAndOverride<UserType[]>(ROLES_KEY, [
            context.getHandler(),
            context.getClass(),
        ],);
        if (!requiredRoles) return true;
        const request = context.switchToHttp().getRequest();
        const user = request.user as LoggedUser;
        console.log(`PATH [${request.method} ${request.path}]:`, 'Current role :', user.type, 'Required Roles: ', requiredRoles);
        const isAuthorized = requiredRoles.some((role) => user.type.includes(role));
        if (!isAuthorized) {
            throw new ForbiddenException(`Only ${requiredRoles} are authorized to access this route, current role is ${user.type}`);
        } else {
            return true;
        }
    }

}