import express from 'express';
import { DatabaseDriver } from '../db.js';

const router = express.Router();
const db = new DatabaseDriver();

router.use(express.json());
router.use(express.urlencoded({ extended: true }));

// middleman for session validation
router.use((req, res, next) => {
    const sessionId = req.cookies.sessionId;
    if (!sessionId) {
        return res.status(401).json({ error: 'Not authenticated' });
    }
    const sess = db.getSession(sessionId);
    if (!sess) {
        return res.status(401).json({ error: 'Invalid session' });
    }
    req.session = sess; // attach session to request for downstream use

    const user = db.getUserById(sess.userId);

    if (!user) {
        return res.status(401).json({ error: 'User not found' });
    }

    req.user = user; // attach user to request
    next();
});

router.get("/generate", async (req, res) => {
    const user = req.user;

    

    

    

})