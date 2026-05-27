import fs from 'fs';
import path from 'path';
import { createLogger, format, transports } from 'winston';

const logsDir = path.resolve(process.cwd(), 'logs');
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

export const logger = createLogger({
  level: process.env.LOG_LEVEL || 'info',
  defaultMeta: {
    service: 'backend-api',
    env: process.env.NODE_ENV || 'development',
  },
  format: format.combine(
    format.timestamp(),
    format.errors({ stack: true }),
    format.json()
  ),
  transports: [
    new transports.Console(),
    new transports.File({ filename: path.join(logsDir, 'error.log'), level: 'error' }),
    new transports.File({ filename: path.join(logsDir, 'combined.log') }),
  ],
});
