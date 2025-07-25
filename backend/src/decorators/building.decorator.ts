import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const BuildingId = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.headers['buildingid'] || request.headers['buildingId'];
  },
);

export const DbName = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.headers['dbname'] || request.headers['dbName'];
  },
);