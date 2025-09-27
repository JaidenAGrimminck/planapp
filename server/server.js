import express from 'express';
import { DatabaseDriver } from './db.js';

import UserRoutes from './routes/users.js';

const app = express();

// use cookie-parser and helmet for security
import cookieParser from 'cookie-parser';
import helmet from 'helmet';

app.use(cookieParser());
app.use(helmet());

const port = process.env.PORT || 3000;

const dbDriver = new DatabaseDriver();

app.get('/', (req, res) => {
    res.json({ message: 'Welcome to the server!' });
});

app.use('/users', UserRoutes);

export default {
    async start() {
        app.listen(port, () => {
            console.log(`Server is running on http://localhost:${port}`);
        });
    }
}