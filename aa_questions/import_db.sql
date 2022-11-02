PRAGMA foreign_keys = ON;
--users table
    --fname and lname   attribute
    DROP TABLE IF EXISTS question_likes;
    DROP TABLE IF EXISTS replies;
    DROP TABLE IF EXISTS question_follows;
    DROP TABLE IF EXISTS questions;
    DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

INSERT INTO
    users (fname, lname)
VALUES
    ('John', 'Doe'),
    ('Eugene', 'ONeill');

--questions table
    --title and body, associated author as a foreign key


CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
    questions (title, body, author_id)
VALUES
    ('Tuition', 'What is the price of hybrid program', (SELECT id FROM users WHERE lname = 'Doe')),
    ('Duration', 'What is the length of the program', (SELECT id FROM users WHERE lname = 'ONeill'));

--question_follows table
    --many to many relationship  Questions and Users
    --This is an example of a join table; the rows in question_follows are used to join users to questions and vice versa.


CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
    question_follows (user_id, question_id)
VALUES
    ((SELECT id FROM users WHERE fname = 'John' AND lname = 'Doe'),
    (SELECT id FROM questions WHERE title = 'Tuition')),

    ((SELECT id FROM users WHERE fname = 'Eugene' AND lname = 'ONeill'),
    (SELECT id FROM questions WHERE title = 'Duration'));


--replies table
    --

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,
--"Top level" replies don't have any parent, but all replies have a subject question.   WE SKIPPED THIS PART

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

INSERT INTO 
    replies(question_id,  parent_reply_id, user_id, body )
VALUES
    (1, NULL, 1, 'The price for hybrid is 20k'),
    (2, NULL, 2, 'The duration of the program is 4 months');



--question_likes


CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    liker_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (liker_id) REFERENCES users(id)
);
INSERT INTO 
    question_likes (question_id, liker_id)
VALUES
    (1, 1),
    (1, 2);






    






