import { Injectable, CanActivate, ExecutionContext, BadRequestException } from '@nestjs/common';

@Injectable()
export class DbNameGuard implements CanActivate {
    canActivate(context: ExecutionContext): boolean {
        const request = context.switchToHttp().getRequest();
        const dbName = request.headers['dbname'] || request.headers['dbName'];
        if (!dbName) {
            throw new BadRequestException('dbName is required in headers');
        }
        return true;
    }
}
