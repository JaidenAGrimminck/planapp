import os
import json
import sqlite3



class DatabaseDriver(object):
    """
    Database driver for the Task app.
    Handles with reading and writing data with the database.
    """

    def __init__(self):
        self.conn = sqlite3.connect("todo.db")
        self.create_task_table()

    def create_task_table(self):
        try:
            self.conn.execute("""
                CREATE TABLE task (
                    ID INTEGER PRIMARY KEY AUTOINCREMENT,
                    DESCRIPTION TEXT NOT NULL,
                    DONE BOOLEAN NOT NULL
                );
            """)
        except Exception as e:
            print(e)