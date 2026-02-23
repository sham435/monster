import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MonsterCodeGateway } from './monster-code.gateway';

@Module({
  imports: [],
  controllers: [AppController],
  providers: [AppService, MonsterCodeGateway],
})
export class AppModule {}
