import { Module } from '@nestjs/common';
import { HistoryService } from './history.service';
import { UsersModule } from 'src/users/users.module';
import { DatabaseModule } from 'src/database/database.module';

@Module({
    imports: [DatabaseModule, UsersModule],
    providers: [HistoryService],
    exports: [HistoryService],
})
export class HistoryModule { } 