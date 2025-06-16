import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { JWTStrategy } from 'src/auth/strategy/jwt.strategy';
import { UsersModule } from 'src/users/users.module';


@Module({
  imports: [
    JwtModule.register({
      secret: 'HAD_12X#@', signOptions: {
        expiresIn: '12h',
      },
    }),
    UsersModule,
    PassportModule,
  ],
  controllers: [AuthController],
  providers: [AuthService, JWTStrategy],
})
export class AuthModule { }
