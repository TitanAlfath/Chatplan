-- DDL for Chat Plan PostgreSQL Database

CREATE TABLE users (
    id VARCHAR PRIMARY KEY,
    email VARCHAR UNIQUE NOT NULL,
    name VARCHAR,
    avatar VARCHAR
);
CREATE INDEX ix_users_id ON users (id);
CREATE INDEX ix_users_email ON users (email);

CREATE TABLE activities (
    id VARCHAR PRIMARY KEY,
    user_id VARCHAR NOT NULL,
    title VARCHAR,
    date VARCHAR,
    time VARCHAR,
    description VARCHAR,
    status VARCHAR DEFAULT 'Sedang Berjalan',
    priority VARCHAR DEFAULT 'Sedang',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX ix_activities_id ON activities (id);
CREATE INDEX ix_activities_user_id ON activities (user_id);
CREATE INDEX ix_activities_title ON activities (title);

CREATE TABLE chat_history (
    id VARCHAR PRIMARY KEY,
    user_id VARCHAR NOT NULL,
    role VARCHAR NOT NULL,
    message VARCHAR NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE INDEX ix_chat_history_id ON chat_history (id);
CREATE INDEX ix_chat_history_user_id ON chat_history (user_id);
