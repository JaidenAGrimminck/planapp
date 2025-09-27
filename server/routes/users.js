import express from 'express';
import bcrypt from 'bcrypt';
import { DatabaseDriver } from '../db.js';

const router = express.Router();
const db = new DatabaseDriver();

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

function setSessionCookie(res, sessionId) {
    const isProd = process.env.NODE_ENV === 'production'; //test if in production environment
    res.cookie('sessionId', sessionId, {
        httpOnly: true,
        secure:   isProd,
        sameSite: 'Strict',
        maxAge: 7 * 24 * 60 * 60 * 1000 // 1 week should be good enough (TODO: maybe increase since this is an app and not a website)
    });
}

router.post('/signup', async (req, res) => {
    const { email, pwd, name } = req.body;
    if (!email || !pwd || !name) {
        return res.status(400).json({ error: 'Email, password, and name are required.' });
    }
    
    try {
        // check for existing user
        if (db.getUserByEmail(email)) {
        return res.status(409).json({ error: 'Email already in use.' });
        }

        await db.addUser(email, pwd, name);
        const user = db.getUserByEmail(email);

        const sessionId = db.createUserSession(user.id);
        setSessionCookie(res, sessionId);

        return res.status(201).json({ message: 'Signup successful.' });
    } catch (err) {
        console.error('Signup error:', err);
        return res.status(500).json({ error: 'Internal error.' });
    }
});

router.post('/login', async (req, res) => {
    const { email, pwd } = req.body;
    if (!email || !pwd) {
        return res.status(400).json({ error: 'Email and password are required.' });
    }

    try {
        const user = db.getUserByEmail(email);
        if (!user) {
            return res.status(401).json({ error: 'Invalid credentials.' });
        }

        const match = await bcrypt.compare(pwd, user.pwd);
        if (!match) {
            return res.status(401).json({ error: 'Invalid credentials.' });
        }

        // update last login + create session
        db.updateLastLogin(user.id);
        const sessionId = db.createUserSession(user.id);
        setSessionCookie(res, sessionId);

        return res.json({ message: 'Login successful.' });
    } catch (err) {
        console.error('Login error:', err);
        return res.status(500).json({ error: 'Internal error.' });
    }
});

// checks the user data
router.get('/me', (req, res) => {
    const sessionId = req.cookies.sessionId;
    if (!sessionId) return res.status(401).json({ error: 'Not authenticated' });

    const sess = db.getSession(sessionId);
    if (!sess) return res.status(401).json({ error: 'Invalid session' });

    const user = db.getUserById(sess.userId);
    res.json({ id: user.id, email: user.email, name: user.name });
});


router.get('/logout', (req, res) => {
    const sessionId = req.cookies.sessionId;
    if (!sessionId) return res.status(401).json({ error: 'Not authenticated' });
    const sess = db.getSession(sessionId);
    if (!sess) return res.status(401).json({ error: 'Invalid session' });

    // delete session
    db.removeSession(sessionId);
    res.clearCookie('sessionId');
    res.json({ message: 'Logged out successfully.' });
});

export default router;