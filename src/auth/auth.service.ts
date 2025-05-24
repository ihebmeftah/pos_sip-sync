import { BadRequestException, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { LoginDto } from './dto/login_dto';
import { AdminService } from 'src/admin/admin.service';
import { EmployerService } from 'src/employer/employer.service';
import { UserRole } from 'src/enums/user.roles';
import { UserBase } from 'src/database/base/user.base';
import { CustomerService } from 'src/customer/customer.service';
import { RegisterDto } from './dto/register_dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly adminService: AdminService,
    private readonly employerService: EmployerService,
    private readonly customerService: CustomerService,
  ) { }

  async login(loginDto: LoginDto) {
    let role: UserRole = UserRole.Employer;
    let user: UserBase | null;
    user = await this.adminService.findOneByEmail(loginDto.email).then((user) => {
      if (user) {
        role = UserRole.Admin;
        return user;
      }
      return null;
    });
    user ??= await this.customerService.findOneByEmail(loginDto.email).then((user) => {
      if (user) {
        role = UserRole.Client;
        return user;
      }
      return null;
    });
    user ??= await this.employerService.findOneByEmail(loginDto.email).then((user) => {
      if (user) {
        role = UserRole.Employer;
        return user;
      }
      return null;
    });
    if (!user) throw new NotFoundException(`User with this email ${loginDto.email} not found`);
    if (!user.active) {
      throw new UnauthorizedException("User is not active");
    }
    const isMatch = loginDto.password == user.password //await compare(loginDto.password, account.password);
    if (isMatch) {
      const payload = {
        role,
        ...user,
      };
      return {
        token: this.jwtService.sign(payload),
        role,
        ...user,
      };
    }
    throw new BadRequestException("Password incorrect");;
  }

  async register(registerDto: RegisterDto) {
    let role: UserRole = UserRole.Admin;
    let user: UserBase | null;
    if (registerDto.role.toLowerCase() == "client") {
      user = await this.customerService.create(registerDto);
      role = UserRole.Client;
    } else if (registerDto.role.toLowerCase() == "owner") {
      user = await this.adminService.create(registerDto);
    } else {
      throw new BadRequestException("Role not found");
    }
    if (!user) throw new NotFoundException(`User with this email ${registerDto.email} exists`);
    if (!user.active) {
      throw new UnauthorizedException("User is not active");
    }
    const payload = {
      role,
      ...user,
    };
    return {
      token: this.jwtService.sign(payload),
      role,
      ...user,
    };
  }

}
