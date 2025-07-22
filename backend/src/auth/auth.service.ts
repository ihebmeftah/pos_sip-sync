import { BadRequestException, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { LoginDto } from './dto/login_dto';
import { RegisterDto } from './dto/register_dto';
import { UsersService } from '../users/users.service';
import { LoggedUser } from './strategy/loggeduser';
import { User } from 'src/users/entities/user.entity';
import { Employer } from 'src/users/entities/employer.entity';
import { Admin } from 'src/users/entities/admin.entity';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly UsersService: UsersService,
  ) { }

  async login(loginDto: LoginDto) {
    const user = await this.UsersService.findUserByEmail(loginDto.email);
    if (!user.active) {
      throw new UnauthorizedException("User is not active");
    }
    const isMatch = loginDto.password == user.password
    //await compare(loginDto.password, account.password);
    if (isMatch) {
      const payload: LoggedUser = {
        id: user.id,
        email: user.email,
        type: user.type,
      };
      return {
        token: this.jwtService.sign(payload),
        ...user,
      };
    }
    throw new UnauthorizedException("Password incorrect");;
  }

  async register(registerDto: RegisterDto) {
    let registred: Admin | Employer;
    /*    if (registerDto.role.toLowerCase() == "client") {
         // user = await this.customerService.create(registerDto);
         role = UserRole.Client;
       } else  */
    if (registerDto.role.toLowerCase() == "owner") {
      registred = await this.UsersService.createAdmin(registerDto);
    } else {
      throw new BadRequestException("Role not found");
    }
    if (!registred) throw new NotFoundException(`User with this email ${registerDto.email} exists`);
    if (!registred.user.active) {
      throw new UnauthorizedException("User is not active");
    }
    const payload: LoggedUser = {
      id: registred.id,
      email: registred.user.email,
      type: registred.user.type,
    };
    return {
      token: this.jwtService.sign(payload),
      ...registred.user,
    };
  }
}
