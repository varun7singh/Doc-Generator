import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { Transport } from '@nestjs/microservices';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter(),
    { cors: true },
  );
  try {
    app.connectMicroservice({
      transport: Transport.RMQ,
      options: {
        urls: [process.env.RMQ_URL],
        queue: process.env.RMQ_QUEUE,
        noAck: false,
        queueOptions: {
          durable: process.env.RMQ_QUEUE_DURABLE === 'true' ? true : false,
        },
      },
    });
  } catch (error) {
    console.log(error);
  }
  const globalPrefix = 'api';
  app.setGlobalPrefix(globalPrefix);

  const config = new DocumentBuilder()
    .setTitle('Doc Generator')
    .setDescription('Doc Gen APIs')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('swagger', app, document);

  try {
    await app.startAllMicroservices();
  } catch (error) {
    console.log(error);
  }
  await app.listen(3000, '0.0.0.0');
  console.log(
    `Application is running on: ${await app.getUrl()}/${globalPrefix}`,
  );
}
bootstrap();
