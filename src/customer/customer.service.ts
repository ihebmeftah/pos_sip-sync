import { ConflictException, Injectable } from '@nestjs/common';
import { CreateCustomerDto } from './dto/create-customer.dto';
import { UpdateCustomerDto } from './dto/update-customer.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Customer } from './entities/customer.entity';
import { UUID } from 'crypto';

@Injectable()
export class CustomerService {
  constructor(
    @InjectRepository(Customer)
    private customerRepo: Repository<Customer>,) { }
  async create(createCustomerDto: CreateCustomerDto) {
    if (await this.existsCustomerByEmail(createCustomerDto.email))
      throw new ConflictException("Customer with this email already exists");
    if (await this.existsCustomerByPhone(createCustomerDto.phone))
      throw new ConflictException("Customer with this phone already exists");
    const createdCustomer = this.customerRepo.create(createCustomerDto);
    return await this.customerRepo.save(createdCustomer);
  }

 

  findOne(id: number) {
    return `This action returns a #${id} customer`;
  }

  private async existsCustomerByEmail(email: string) {
    return await this.customerRepo.existsBy({ email });
  }

  private async existsCustomerByPhone(phone: string) {
    return await this.customerRepo.existsBy({ phone });
  }
  async findOneByEmail(email: string) {
    return await this.customerRepo.findOneBy({ email });
  }
}
