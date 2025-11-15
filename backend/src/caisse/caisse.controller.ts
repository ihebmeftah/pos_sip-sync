import { Controller, Get, Post, UseGuards } from '@nestjs/common';
import { CaisseService } from './caisse.service';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { DbNameGuard } from 'src/guards/dbname.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { Roles } from 'src/decorators/roles.decorator';
import { UserType } from 'src/enums/user.roles';
import { DbName } from 'src/decorators/building.decorator';

@Controller('caisse')
@UseGuards(JwtAuthGuard, RolesGuard, DbNameGuard)
export class CaisseController {
  constructor(private readonly caisseService: CaisseService) { }
  @Post("create")
  async createCaisse(
    @DbName() db: string,
  ) {
    return this.caisseService.create(db);
  }
  @Get()
  @Roles(UserType.Admin)
  findAll(
    @DbName() db: string
  ) {
    return this.caisseService.findAll(db);
  }
}
