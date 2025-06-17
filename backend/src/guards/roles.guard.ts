import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from 'src/decorators/roles.decorator';
import { UserRole } from 'src/enums/user.roles';

@Injectable()
export class RolesGuard implements CanActivate {
    constructor(private reflector: Reflector) { }


    canActivate(context: ExecutionContext): boolean {
        const requiredRoles = this.reflector.getAllAndOverride<UserRole[]>(ROLES_KEY, [
            context.getHandler(),
            context.getClass(),
        ],);
        if (!requiredRoles) return true;
        const request = context.switchToHttp().getRequest();
        const user = request.user;
        console.log('Current role :', user.role);
        console.log('Required Roles:', requiredRoles);
        const isAuthorized = requiredRoles.some((role) => user.role.includes(role));
        if (!isAuthorized) {
            throw new ForbiddenException(`Only ${requiredRoles} are authorized to access this route, current role is ${user.role}`);
        } else {
            return true;
        }
    }

}