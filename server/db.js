import { DatabaseSync } from "node:sqlite";
import crypto from "node:crypto";
import bcrypt from "bcrypt";

const USER_TABLE_FORMAT = {
    id: "INTEGER PRIMARY KEY",
    email: "TEXT NOT NULL UNIQUE",
    pwd: "TEXT NOT NULL",
    name: "TEXT NOT NULL",
    createdAt: "DATETIME DEFAULT CURRENT_TIMESTAMP",
    updatedAt: "DATETIME DEFAULT CURRENT_TIMESTAMP",
    lastLogin: "DATETIME",
    // paths generated is an array
    pathsGenerated: "TEXT NOT NULL"
}

const PATH_TABLE_FORMAT = {
    id: "INTEGER PRIMARY KEY",
    generatedBy: "INTEGER NOT NULL",
    path: "TEXT NOT NULL", // use a JSON string encoded to base64

}

const SALT_ROUNDS = 12;

export class DatabaseDriver {
    constructor(initialize = false) {
        this.db = new DatabaseSync("./db.sqlite", {
            mode: "open",
            verbose: console.log,
            fileMustExist: false,
            timeout: 5000,
        })

        if (initialize) {
            this.initialize();
        }
        
    }

    initialize() {
        this.createUserTable();
        this.createSessionTable();
        this.createPathTable();
    }

    getSession(sessionId) {
        return (
            this.db
                .prepare("SELECT * FROM sessions WHERE id = ?")
                .get(sessionId) || null
        );
    }

    createUserTable() {
        //check if table is created
        const tableExists = this.db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='users'").get();
        if (!tableExists) {
            //create table if it does not exist
            const sql = `
                CREATE TABLE users (
                ${Object.entries(USER_TABLE_FORMAT)
                    .map(([col, def]) => `${col} ${def}`)
                    .join(",\n")}
                )
            `;
            this.db.exec(sql);
            console.log("Users table created successfully.");
        } else {
            console.log("Users table already exists.");

            // check if the table has the correct columns (allow for updating schema)
            const columns = this.db.prepare("PRAGMA table_info(users)").all();
            const columnNames = columns.map(col => col.name);
            const missingColumns = Object.keys(USER_TABLE_FORMAT).filter(col => !columnNames.includes(col));

            if (missingColumns.length > 0) {
                console.warn(`Users table is missing columns: ${missingColumns.join(", ")}`);

                // add the missing columns here
                missingColumns.forEach(col => {
                    const addColumnQuery = `ALTER TABLE users ADD COLUMN ${col} ${USER_TABLE_FORMAT[col]}`;
                    this.db.exec(addColumnQuery);
                    console.log(`Added missing column: ${col}`);
                });
            }
        }
    }

    createSessionTable() {
        const tableExists = this.db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='sessions'").get();
        if (!tableExists) {
            this.db.exec(`
                CREATE TABLE sessions (
                id TEXT PRIMARY KEY,
                userId INTEGER NOT NULL,
                createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (userId) REFERENCES users(id)
                )
            `);
            console.log("Sessions table created successfully.");
        } else {
            console.log("Sessions table already exists.");
        }
    }

    createPathTable() {
        const tableExists = this.db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name='paths'").get();
        if (!tableExists) {
            let tb = 'CREATE TABLE paths (\n';

            for (const [col, def] of Object.entries(PATH_TABLE_FORMAT)) {
                tb += `  ${col} ${def},\n`;
            }
            this.db.exec(tb.slice(0, -2) + '\n)'); // remove last comma and add closing parenthesis
            console.log("Paths table created successfully.");
        } else {
            console.log("Paths table already exists.");
        }
    }

    async addUser(email, pwd, name) {
        // sanitize inputs
        email = email.trim();
        pwd = pwd.trim();
        name = name.trim();

        const hash = await bcrypt.hash(pwd, SALT_ROUNDS)

        const insertQuery = `
            INSERT INTO users (email, pwd, name, createdAt, updatedAt)
            VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        `;
        
        //console.log(email, hash, name);

        this.db.prepare(insertQuery).run(email, hash, name);
        console.log("User added successfully.");
    }

    clearTable() {
        this.db.exec("DELETE FROM users");
        console.log("Users table cleared.");
    }

    getUserByEmail(email) {
        return (
            this.db
                .prepare("SELECT * FROM users WHERE email = ?")
                .get(email.trim()) || null
        );
    }

    getPathByUser(userId) {
        const paths = this.db
                .prepare("SELECT * FROM paths WHERE userId = ?")
                .all(userId) || [];

        return (
            paths.map(path => {
                return JSON.parse(Buffer.from(path.path, 'base64').toString('utf-8'));
            })
        );
    }

    createUserSession(userId) {
        const uuid = crypto.randomUUID();
        const insert = `
            INSERT INTO sessions (id, userId)
            VALUES (?, ?)
        `;
        this.db.prepare(insert).run(uuid, userId);
        return uuid;
    }

    updateLastLogin(userId) {
        this.db
        .prepare("UPDATE users SET lastLogin = CURRENT_TIMESTAMP WHERE id = ?")
        .run(userId);
    }

    getUserById(userId) {
        return (
            this.db
                .prepare("SELECT * FROM users WHERE id = ?")
                .get(userId) || null
        );
    }
    
    removeSession(sessionId) {
        this.db.prepare("DELETE FROM sessions WHERE id = ?").run(sessionId);
        console.log(`Session ${sessionId} removed successfully.`);
    }
}
