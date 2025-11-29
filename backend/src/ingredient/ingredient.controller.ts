import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, ParseUUIDPipe } from '@nestjs/common';
import { IngredientService } from './ingredient.service';
import { CreateIngredientDto } from './dto/create-ingredient.dto';
import { UpdateIngredientDto } from './dto/update-ingredient.dto';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { DbNameGuard } from 'src/guards/dbname.guard';
import { RolesGuard } from 'src/guards/roles.guard';
import { UserType } from 'src/enums/user.roles';
import { Roles } from 'src/decorators/roles.decorator';
import { DbName } from 'src/decorators/building.decorator';
import { UUID } from 'crypto';

@Controller('ingredient')
@UseGuards(JwtAuthGuard, DbNameGuard, RolesGuard)
@Roles(UserType.Admin)
export class IngredientController {
  constructor(private readonly ingredientService: IngredientService) { }

  @Post()
  create(@Body() createIngredientDto: CreateIngredientDto, @DbName() dbName: string) {
    return this.ingredientService.create(createIngredientDto, dbName);
  }

  @Get()
  findAll(@DbName() dbName: string) {
    return this.ingredientService.findAll(dbName);
  }

  @Get(':id')
  getIngredientById(@Param('id', new ParseUUIDPipe) id: UUID, @DbName() dbName: string) {
    return this.ingredientService.getIngredientById(id, dbName);
  }
}
