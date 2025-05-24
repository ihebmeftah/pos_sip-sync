import { Controller, Post, Body, Get, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login_dto';
import { JwtAuthGuard } from './guard/auth.guard';
import { register } from 'module';
import { RegisterDto } from './dto/register_dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post()
  login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Post('register')
  register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async verify(@Request() req) {
    /// { userId, email , role}
    return req.user;
  }
}
