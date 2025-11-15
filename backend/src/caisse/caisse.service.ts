import { Injectable, BadRequestException } from '@nestjs/common';
import { Caisse } from './entities/caisse.entity';
import { BuildingService } from '../building/building.service';
import * as moment from 'moment';
import { RepositoryFactory } from 'src/database/repository-factory.service';

@Injectable()
export class CaisseService {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
    private readonly buildingService: BuildingService,
  ) { }

  async create(dbName: string) {
    const caisseRepo = await this.repositoryFactory.getRepository(dbName, Caisse);
    const building = await this.buildingService.findByDbName(dbName);
    // Get current time
    const now = moment();
    // Format day as DD-MM-YYYY (using the opening day)
    const dayFormatted = now.format('DD-MM-YYYY');
    // Check if there's an active caisse in progress
    const activeCaisse = await caisseRepo.findOne({
      where: {
        day: dayFormatted,
      },
    });
    if (activeCaisse) return activeCaisse;

    // Check if there's a previous caisse for this building
    const latestCaisse = await caisseRepo.find({
      order: {
        createdAt: 'DESC',
      },
    });
    if (latestCaisse.length > 0) {
      const previousCloseTime = moment(latestCaisse[0].close);
      // Prevent creating a new caisse before the previous caisse's closing time has passed
      if (now.isBefore(previousCloseTime)) {
        throw new BadRequestException(
          `Cannot create a new caisse before the previous caisse closes at ${previousCloseTime.format('DD/MM/YYYY HH:mm')}. Please wait until the previous shift has completed.`
        );
      }
    }
    // Extract time from building's opening and closing timestamps
    const openingMoment = moment(building.openingTime);
    const closingMoment = moment(building.closingTime);
    const openingHour = openingMoment.hours();
    const closingHour = closingMoment.hours();
    // Determine if this is an overnight shift (e.g., 7:00 to 3:00)
    const isOvernightShift = closingHour < openingHour;
    // Create start datetime: today's date with opening time
    const start = now.clone()
      .hours(openingMoment.hours())
      .minutes(openingMoment.minutes())
      .seconds(0)
      .milliseconds(0)
      .toDate();
    // Create close datetime
    let close: Date;
    if (isOvernightShift) {
      // If closing time is earlier than opening time, it means we close the next day
      close = now.clone()
        .add(1, 'day')
        .hours(closingMoment.hours())
        .minutes(closingMoment.minutes())
        .seconds(0)
        .milliseconds(0)
        .toDate();
    } else {
      // Same day closing
      close = now.clone()
        .hours(closingMoment.hours())
        .minutes(closingMoment.minutes())
        .seconds(0)
        .milliseconds(0)
        .toDate();
    }

    const caisse = caisseRepo.create({
      day: dayFormatted,
      start,
      close,
    });
    return await caisseRepo.save(caisse);
  }

  async findAll(dbName: string) {
    const caisseRepo = await this.repositoryFactory.getRepository(dbName, Caisse);
    return await caisseRepo.find();
  }
}
