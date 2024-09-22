--Social media database

-- Enable foreign key enforcement
PRAGMA foreign_keys = ON;

-- Users table
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) NOT NULL,
    fullname VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    pfp TEXT NOT NULL, 
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Posts table
CREATE TABLE Posts (
    post_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    post_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  	likes INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Comments table
CREATE TABLE Comments (
    comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    content TEXT NOT NULL,
    com_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    likes INTEGER DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- Likes table
CREATE TABLE Likes (
    like_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    comment_id INTEGER,
    like_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (comment_id) REFERENCES Comments(comment_id)
);

-- Shares table
CREATE TABLE Shares (
    share_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    share_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- Follows table
CREATE TABLE Follows (
    follower_id INTEGER NOT NULL,
    following_id INTEGER NOT NULL,
    follow_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, following_id),
    FOREIGN KEY (follower_id) REFERENCES Users(user_id),
    FOREIGN KEY (following_id) REFERENCES Users(user_id)
);



-- Trigger to increment the 'likes' column in the 'Comments' table when a like is added to a comment
CREATE TRIGGER increment_comment_likes
AFTER INSERT ON Likes
WHEN NEW.comment_id IS NOT NULL
BEGIN
   UPDATE Comments
   SET likes = likes + 1
   WHERE comment_id = NEW.comment_id;
END;

-- Trigger to prevent a user from following themselves
CREATE TRIGGER prevent_self_follow
BEFORE INSERT ON Follows
WHEN NEW.follower_id = NEW.following_id
BEGIN
   SELECT RAISE(ABORT, 'Users cannot follow themselves.');
END;

-- Trigger to automatically remove all associated likes when a post is deleted
CREATE TRIGGER delete_likes_on_post_delete
AFTER DELETE ON Posts
BEGIN
   DELETE FROM Likes WHERE post_id = OLD.post_id;
END;

-- Trigger to automatically remove all associated comments when a post is deleted
CREATE TRIGGER delete_comments_on_post_delete
AFTER DELETE ON Posts
BEGIN
   DELETE FROM Comments WHERE post_id = OLD.post_id;
END;

-- Trigger to automatically remove all associated likes when a comment is deleted
CREATE TRIGGER delete_likes_on_comment_delete
AFTER DELETE ON Comments
BEGIN
   DELETE FROM Likes WHERE comment_id = OLD.comment_id;
END;
-- Enable foreign key enforcement
PRAGMA foreign_keys = ON;

--SECURITY
-- Security Measure 1: Ensure that each email in the Users table is unique
CREATE UNIQUE INDEX unique_email_idx ON Users(email);

-- Security Measure 2: Prevent self-following by disallowing a user from following themselves
CREATE TRIGGER prevent_self_follow
BEFORE INSERT ON Follows
WHEN NEW.follower_id = NEW.following_id
BEGIN
    SELECT RAISE(ABORT, 'Users cannot follow themselves.');
END;

-- Security Measure 3: Ensure that usernames are unique
CREATE UNIQUE INDEX unique_username_idx ON Users(username);

-- Security Measure 4: Enforce password strength during user registration (to be handled in the application layer)
-- This SQL trigger assumes that the application hashes passwords and checks password strength.
-- Password strength requirements are implemented in the application layer but are mentioned here for reference.

-- Security Measure 5: Track failed login attempts and lock accounts after a certain number of failures
-- Assuming there is a `failed_attempts` and `account_locked` column in the Users table.

-- Increment failed login attempts
CREATE TRIGGER increment_failed_attempts_on_failed_login
AFTER UPDATE ON Users
WHEN NEW.password != hash_password('correct_password') -- Password verification is done in the application
BEGIN
   UPDATE Users
   SET failed_attempts = failed_attempts + 1
   WHERE user_id = NEW.user_id;
END;

-- Lock the account if failed attempts exceed 5
CREATE TRIGGER lock_account_after_failed_attempts
AFTER UPDATE ON Users
WHEN NEW.failed_attempts >= 5
BEGIN
   UPDATE Users
   SET account_locked = 1
   WHERE user_id = NEW.user_id;
END;

-- Reset failed attempts on successful login
CREATE TRIGGER reset_failed_attempts_on_successful_login
AFTER UPDATE ON Users
WHEN NEW.failed_attempts > 0 AND NEW.password = hash_password('correct_password') -- Handled in the app logic
BEGIN
   UPDATE Users
   SET failed_attempts = 0
   WHERE user_id = NEW.user_id;
END;

-- Security Measure 6: Restrict account deletions, preventing deletion of the last admin account
-- Assuming there's a column 'is_admin' in the Users table that flags admin users.
CREATE TRIGGER prevent_last_admin_deletion
BEFORE DELETE ON Users
WHEN OLD.is_admin = 1 AND (SELECT COUNT(*) FROM Users WHERE is_admin = 1) = 1
BEGIN
   SELECT RAISE(ABORT, 'Cannot delete the last admin user.');
END;

-- Security Measure 7: Log all deletion actions (Posts, Comments, Users) into an Audit_Log table for record-keeping
CREATE TABLE IF NOT EXISTS Audit_Log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_type TEXT NOT NULL,
    affected_table TEXT NOT NULL,
    record_id INTEGER NOT NULL,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER NOT NULL
);

-- Log deletions of posts
CREATE TRIGGER log_post_deletion
AFTER DELETE ON Posts
BEGIN
   INSERT INTO Audit_Log (action_type, affected_table, record_id, user_id)
   VALUES ('DELETE', 'Posts', OLD.post_id, OLD.user_id);
END;

-- Log deletions of comments
CREATE TRIGGER log_comment_deletion
AFTER DELETE ON Comments
BEGIN
   INSERT INTO Audit_Log (action_type, affected_table, record_id, user_id)
   VALUES ('DELETE', 'Comments', OLD.comment_id, OLD.user_id);
END;

-- Log deletions of users
CREATE TRIGGER log_user_deletion
AFTER DELETE ON Users
BEGIN
   INSERT INTO Audit_Log (action_type, affected_table, record_id, user_id)
   VALUES ('DELETE', 'Users', OLD.user_id, OLD.user_id);
END;





