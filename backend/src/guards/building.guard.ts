import { Injectable, CanActivate, ExecutionContext, BadRequestException } from '@nestjs/common';

@Injectable()
export class BuildingIdGuard implements CanActivate {
    canActivate(context: ExecutionContext): boolean {
        const request = context.switchToHttp().getRequest();
        const buildingId = request.headers['buildingid'] || request.headers['buildingId'];
        if (!buildingId) {
            throw new BadRequestException('buildingId is required in headers');
        }
        return true;
    }
}