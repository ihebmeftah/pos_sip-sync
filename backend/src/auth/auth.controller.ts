import { Controller, Post, Body, Get, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login_dto';
import { JwtAuthGuard } from './guard/auth.guard';
import { RegisterDto } from './dto/register_dto';
import { CurrUser } from 'src/decorators/curr-user.decorator';
import { LoggedUser } from './strategy/loggeduser';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post('login')
  login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Post('register')
  register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async verify(@CurrUser() user: LoggedUser) {
    return user;
  }
}
