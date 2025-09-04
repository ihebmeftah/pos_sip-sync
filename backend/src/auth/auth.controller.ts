import { Controller, Post, Body, Get, UseGuards, UseInterceptors, UploadedFiles } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login_dto';
import { JwtAuthGuard } from './guard/auth.guard';
import { RegisterDto } from './dto/register_dto';
import { CurrUser } from 'src/decorators/curr-user.decorator';
import { LoggedUser } from './strategy/loggeduser';
import { CustomFileUploadInterceptor } from 'src/utils/custom-file-upload';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post('login')
  login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Post('register')
  @UseInterceptors(
    CustomFileUploadInterceptor([
      { name: 'image', maxCount: 1 },
    ], './uploads/users')
  )
  register(
    @Body() registerDto: RegisterDto,
    @UploadedFiles() files: { photo?: Express.Multer.File[] }

  ) {
    if (files.photo && files.photo.length > 0) {
      registerDto.photo = files.photo[0].path;
    }
    return this.authService.register(registerDto);
  }
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async verify(@CurrUser() user: LoggedUser) {
    return user;
  }
}
