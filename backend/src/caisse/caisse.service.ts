import { Injectable } from '@nestjs/common';
import { Caisse } from './entities/caisse.entity';
import * as moment from 'moment';
import { RepositoryFactory } from 'src/database/repository-factory.service';

@Injectable()
export class CaisseService {
  constructor(
    private readonly repositoryFactory: RepositoryFactory,
  ) { }

  async getCaisseOfDay(dbName: string) {
    const caisseRepo = await this.repositoryFactory.getRepository(dbName, Caisse);
    // Get current time
    const now = moment()
    // Format day as DD-MM-YYYY (using the opening day)
    const dayFormatted = now.format('DD-MM-YYYY');
    // Check if there's an active caisse in progress
    const activeCaisse = await caisseRepo.findOne({
      where: {
        day: dayFormatted,
      },
    });
    if (activeCaisse) return activeCaisse;
    const createCaisse = caisseRepo.create({
      day: dayFormatted,
    });
    return await caisseRepo.save(createCaisse);
  }

  async findAll(dbName: string) {
    const caisseRepo = await this.repositoryFactory.getRepository(dbName, Caisse);
    return await caisseRepo.find();
  }
}
