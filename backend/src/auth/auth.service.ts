import { BadRequestException, Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { LoginDto } from './dto/login_dto';
import { RegisterDto } from './dto/register_dto';
import { UsersService } from '../users/users.service';
import { LoggedUser } from './strategy/loggeduser';
import { Employer } from 'src/users/entities/employer.entity';
import { User } from 'src/users/entities/user.entity';

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
        type: [user.type],
      };
      return {
        token: this.jwtService.sign(payload),
        ...user,
      };
    }
    throw new UnauthorizedException("Password incorrect");;
  }

  async register(registerDto: RegisterDto) {
    const registred = await this.UsersService.createAdmin(registerDto)
    if (!registred) throw new NotFoundException(`User with this email ${registerDto.email} exists`);
    if (!registred.active) {
      throw new UnauthorizedException("User is not active");
    }
    const payload: LoggedUser = {
      id: registred.id,
      email: registred.email,
      type: [registred.type],
    };
    return {
      token: this.jwtService.sign(payload),
      ...registred,
    };
  }
}
