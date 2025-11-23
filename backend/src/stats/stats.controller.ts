import { Controller, Get, UseGuards } from '@nestjs/common';
import { StatsService } from './stats.service';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { DbNameGuard } from 'src/guards/dbname.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { UserType } from 'src/enums/user.roles';
import { Roles } from 'src/decorators/roles.decorator';
import { DbName } from 'src/decorators/building.decorator';

@Controller('stats')
@UseGuards(JwtAuthGuard, DbNameGuard, RolesGuard)
@Roles(UserType.Admin)
export class StatsController {
  constructor(private readonly statsService: StatsService) { }
  @Get()
  async getStats(
    @DbName() dbname: string,
  ) {
    return this.statsService.getStats(dbname);
  }
}
