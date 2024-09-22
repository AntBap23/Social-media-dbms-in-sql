Social Media DBMS - Project README


Overview
This project is a Social Media Database Management System (DBMS) built using SQLite. The database manages key social media functionalities, including users, posts, comments, likes, shares, and follows. It supports user interactions and tracks various activities within a scalable, efficient database structure.

Features
The system includes the following key features:

Users: Users can register with unique usernames and emails. The system also handles profile pictures and secure passwords.

Posts: Users can create, edit, and delete posts, with associated timestamps and like counts.

Comments: Users can comment on posts, with multi-layered comment threads.

Likes: Users can like posts or comments, and the like counts are dynamically updated.

Shares: Users can share posts, with the share history logged.

Follows: Users can follow and unfollow others, with self-follow prevention.

Triggers: Various triggers are implemented to maintain data integrity, security, and automated processes.

Database Structure
Tables

Users Table

Stores user information, including usernames, emails, profile pictures, and password hashes.
Enforces unique usernames and emails.
Columns:
user_id: Primary key.
username: Unique.
fullname: User’s full name.
email: Unique.
password: Hashed password.
pfp: Profile picture URL.
date_joined: Timestamp.


Posts Table

Stores posts created by users.
Tracks like counts and post creation date.
Columns:
post_id: Primary key.
user_id: Foreign key referencing Users.
content: Post content.
post_date: Timestamp.
likes: Like count.


Comments Table

Stores comments on posts.
Tracks like counts and comment creation date.
Columns:
comment_id: Primary key.
user_id: Foreign key referencing Users.
post_id: Foreign key referencing Posts.
content: Comment content.
com_date: Timestamp.
likes: Like count.


Likes Table

Tracks likes on posts and comments.
Columns:
like_id: Primary key.
user_id: Foreign key referencing Users.
post_id: Foreign key referencing Posts.
comment_id: Foreign key referencing Comments (nullable).
like_date: Timestamp.


Shares Table

Tracks shares of posts.
Columns:
share_id: Primary key.
user_id: Foreign key referencing Users.
post_id: Foreign key referencing Posts.
share_date: Timestamp.
Follows Table


Tracks user follow relationships.
Prevents self-following.
Columns:
follower_id: Foreign key referencing Users.
following_id: Foreign key referencing Users.
follow_date: Timestamp.

Triggers and Security Measures
Increment comment likes: Automatically increases the likes count in the Comments table when a comment is liked.
Prevent self-follow: Stops users from following themselves.
Cascade deletion: Automatically deletes related likes and comments when a post or comment is deleted.
Unique constraints: Ensures that emails and usernames are unique.
Password security: Password strength and hashing are handled by the application layer.
Audit log: Logs all deletion actions for posts, comments, and users into an Audit_Log table for security and tracking.
Account lockout: Tracks failed login attempts and locks accounts after too many failures.
Setup and Installation
Prerequisites
SQLite: Ensure SQLite is installed. You can download it from SQLite Downloads.
Cloning the Repository
Clone the GitHub repository to your local machine:

bash
Copy code
git clone https://github.com/AntBap23/social-media-dbms-in-sql.git
cd social-media-dbms-in-sql
Database Initialization
Run the schema.sql script to create the necessary tables:

bash
Copy code
sqlite3 social_media.db < schema.sql
Optionally, you can populate the database with sample data:

bash
Copy code
sqlite3 social_media.db < sample_data.sql
Example Queries
Add a new user:

sql
Copy code
INSERT INTO Users (username, fullname, email, password, pfp) 
VALUES ('johndoe', 'John Doe', 'john@example.com', 'hashed_password', 'profile_pic.jpg');
Create a new post:

sql
Copy code
INSERT INTO Posts (user_id, content) 
VALUES (1, 'Hello world!');
Like a post:

sql
Copy code
INSERT INTO Likes (user_id, post_id) 
VALUES (1, 2);
Follow a user:

sql
Copy code
INSERT INTO Follows (follower_id, following_id) 
VALUES (1, 2);

Future Enhancements
Implement RESTful APIs to interact with the database from web or mobile applications.
Add support for video and audio media.
Implement user authentication with token-based sessions.
Add notifications for likes, follows, and comments.
Improve database performance by adding indexes on frequently queried columns.
Contributions
Contributions are welcome! Fork the repository, make your changes, and submit a pull request.
