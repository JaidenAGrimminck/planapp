import server from './server.js';

import { DatabaseDriver } from './db.js';

const dbDriver = new DatabaseDriver(true);

server.start().catch(err => {
    console.error('Failed to start the server:', err);
    process.exit(1);
});