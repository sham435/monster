import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Socket } from 'socket.io';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class MonsterCodeGateway implements OnGatewayConnection, OnGatewayDisconnect {
  
  handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
    client.emit('connected', { message: 'Welcome to Monster Code!' });
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('message')
  handleMessage(
    @MessageBody() data: { message: string },
    @ConnectedSocket() client: Socket,
  ): void {
    console.log(`Received message: ${data.message}`);
    
    // Simulate Monster Code processing
    setTimeout(() => {
      client.emit('response', {
        message: `Monster Code processed: "${data.message}"`,
        timestamp: new Date().toISOString(),
      });
    }, 1000);
  }

  @SubscribeMessage('code_request')
  handleCodeRequest(
    @MessageBody() data: { code: string; request: string },
    @ConnectedSocket() client: Socket,
  ): void {
    console.log(`Code request: ${data.request}`);
    
    // Simulate code analysis
    setTimeout(() => {
      client.emit('code_response', {
        explanation: `This code appears to be ${data.request}. Here's what it does: [simulated analysis]`,
        suggestions: [
          'Consider adding error handling',
          'Add type annotations for better type safety',
          'Consider using async/await for better readability'
        ],
        timestamp: new Date().toISOString(),
      });
    }, 1500);
  }

  @SubscribeMessage('git_workflow')
  handleGitWorkflow(
    @MessageBody() data: { action: string; branch?: string },
    @ConnectedSocket() client: Socket,
  ): void {
    console.log(`Git workflow request: ${data.action}`);
    
    // Simulate git workflow processing
    setTimeout(() => {
      client.emit('git_response', {
        message: `Monster Code will help you with git ${data.action}`,
        commands: [
          `git checkout -b ${data.branch || 'feature-branch'}`,
          'git add .',
          'git commit -m "Your commit message"',
          'git push origin feature-branch'
        ],
        timestamp: new Date().toISOString(),
      });
    }, 1200);
  }
}