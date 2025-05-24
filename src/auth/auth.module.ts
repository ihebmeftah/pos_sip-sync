import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { JWTStrategy } from 'src/auth/strategy/jwt.strategy';
import { EmployerModule } from 'src/employer/employer.module';
import { AdminModule } from 'src/admin/admin.module';
import { CustomerModule } from 'src/customer/customer.module';

@Module({
  imports: [
    JwtModule.register({
      secret: 'HAD_12X#@', signOptions: {
        expiresIn: '12h',
      },
    }),
    EmployerModule,
    AdminModule,
    CustomerModule,
    PassportModule,
  ],
  controllers: [AuthController],
  providers: [AuthService, JWTStrategy],
})
export class AuthModule { }
