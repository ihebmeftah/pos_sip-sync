import { Controller, Get } from '@nestjs/common';
import { DbName } from './decorators/building.decorator';

@Controller()
export class AppController {

  @Get()
  getHello(): string {
    return "Iheb's NestJS API is running!";
  }

  @Get('test-tenant')
  testTenant(@DbName() dbName: string): object {
    return {
      message: 'Multi-tenant test successful',
      dbName: dbName,
      timestamp: new Date().toISOString()
    };
  }
}
