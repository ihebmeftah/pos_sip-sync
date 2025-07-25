import { Module } from '@nestjs/common';
import { CategroyService } from './categroy.service';
import { CategroyController } from './categroy.controller';
import { BuildingModule } from 'src/building/building.module';
import { DatabaseModule } from 'src/database/database.module';

@Module({
  imports: [
    DatabaseModule,
    BuildingModule,
  ],
  controllers: [CategroyController],
  providers: [CategroyService],
  exports: [CategroyService],
})
export class CategroyModule { }
