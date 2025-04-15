CREATE TABLE User (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_name VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL
);

CREATE TABLE Album (
    album_id VARCHAR(10) PRIMARY KEY,
    album_name VARCHAR(225) NOT NULL,
    release_date DATE NOT NULL,
    producer VARCHAR(225) NOT NULL
);

CREATE TABLE Song (
    song_id VARCHAR(15) PRIMARY KEY,
    album_id VARCHAR(10),
    track_number INTEGER NOT NULL,
    song_title VARCHAR(225) NOT NULL,
    duration VARCHAR(50),
    producer VARCHAR(225),
    FOREIGN KEY (album_id) REFERENCES Album(album_id)
);

CREATE TABLE Collaborations (
    collab_id VARCHAR(255) PRIMARY KEY,
    song_id VARCHAR(15),
    artist_name VARCHAR(225) NOT NULL,
    FOREIGN KEY (song_id) REFERENCES Song(song_id)
);

CREATE TABLE Lyrics (
    lyric_id VARCHAR(20) PRIMARY KEY,
    song_id VARCHAR(15),
    song_title VARCHAR(225) NOT NULL,
    lyrics_text VARCHAR(999) NOT NULL,
    FOREIGN KEY (song_id) REFERENCES Song(song_id)
);

CREATE TABLE Favourites (
    favourite_id INTEGER PRIMARY KEY AUTOINCREMENT,
    song_id VARCHAR(15),
    song_title VARCHAR(225) NOT NULL,
    user_id INTEGER,
    isFavourite BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (song_id) REFERENCES Song(song_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
);

--insertions--
--Insert User Data--
INSERT INTO User (user_name,password) VALUES
('Ahmid', '12345'),('TA', '12345');

-- Insert Album Data
INSERT INTO Album (album_id, album_name, release_date, producer) VALUES
('THN2023', 'Thoughts I Never Said', '2023-11-24', 'Edbl, Charlie Pitts, Kent, Fred Cox, Emil'),
('LST2024', 'Lustropolis', '2024-11-15', 'Charlie Pitts, Harry Westlake, Dan Hylton, Ezra Skys'),
('SAZ2024', 'Sunday At Zuri''s', '2024-07-05', 'OVMBR');

-- Insert Song Data for "Thoughts I Never Said" EP
INSERT INTO Song (song_id, album_id, track_number, song_title, duration, producer) VALUES
('THN2023_1', 'THN2023', 1, 'Intro (Landmine)', '1:08', 'Edbl'),
('THN2023_2', 'THN2023', 2, 'All That It Takes', '3:30', 'Charlie Pitts'),
('THN2023_3', 'THN2023', 3, 'You, The World Vs Me', '2:03', 'Kent'),
('THN2023_4', 'THN2023', 4, 'On the Ground', '3:22', 'Fred Cox'),
('THN2023_5', 'THN2023', 5, 'Bedroom Weather', '3:20', 'Fred Cox'),
('THN2023_6', 'THN2023', 6, 'Water', '2:21', 'Emil'),
('THN2023_7', 'THN2023', 7, 'Rigormortis', '2:20', 'Charlie Pitts'),
('THN2023_8', 'THN2023', 8, 'Fine By Myself', '2:43', 'Kent'),
('THN2023_9', 'THN2023', 9, 'Gave You My All', '3:01', 'Emil');

-- Insert Song Data for "Lustropolis" Album
INSERT INTO Song (song_id, album_id, track_number, song_title, duration, producer) VALUES
('LST2024_1', 'LST2024', 1, 'Can''t Stay', '2:41', 'Charlie Pitts'),
('LST2024_2', 'LST2024', 2, 'Modern Day Suicide', '2:31', 'Harry Westlake'),
('LST2024_3', 'LST2024', 3, 'Temptress', '2:56', 'Dan Hylton'),
('LST2024_4', 'LST2024', 4, 'You''re Stuck', '4:04', 'Ezra Skys'),
('LST2024_5', 'LST2024', 5, 'SHOWBIZ', '2:48', 'Charlie Pitts'),
('LST2024_6', 'LST2024', 6, 'HBTS (Haven''t Been The Same)', '3:03', 'Harry Westlake'),
('LST2024_7', 'LST2024', 7, 'Blame U', '2:49', 'Dan Hylton'),
('LST2024_8', 'LST2024', 8, 'Karma', '2:56', 'Emil');

-- Insert Song Data for "Sunday At Zuri's" EP
INSERT INTO Song (song_id, album_id, track_number, song_title, duration, producer) VALUES
('SAZ2024_1', 'SAZ2024', 1, 'Sondela', '1:47', 'OVMBR'),
('SAZ2024_2', 'SAZ2024', 2, 'Soh-Soh', '3:04', 'OVMBR'),
('SAZ2024_3', 'SAZ2024', 3, 'Onome', '3:18', 'OVMBR'),
('SAZ2024_4', 'SAZ2024', 4, 'Free Me', '3:20', 'OVMBR');

-- Insert Collaboration Data
INSERT INTO Collaborations (collab_id, song_id, artist_name) VALUES
('OxEmil', 'THN2023_9', 'Emil'),
('OxSummerWalker', 'LST2024_4', 'Summer Walker'),
('OxSummerWalker_1', 'LST2024_8', 'Summer Walker');

-- Insert Lyrics Data
INSERT INTO Lyrics (lyric_id, song_id, song_title, lyrics_text) VALUES
('THN2023_1Ly', 'THN2023_1', 'Intro (Landmine)', 'Landmine, stepping through memories
A place that''s never been safe for me'),
('THN2023_2Ly', 'THN2023_2', 'All That It Takes', 'All that it takes is a moment
Just to realize what you mean to me'),
('THN2023_3Ly', 'THN2023_3', 'You, The World Vs Me', 'You, the world vs me
Fighting battles nobody else can see'),
('THN2023_4Ly', 'THN2023_4', 'On the Ground', 'On the ground, feeling weightless
Don''t know how I''ll face this'),
('THN2023_5Ly', 'THN2023_5', 'Bedroom Weather', 'Bedroom weather, it''s storming in my mind
Trying to keep it all together'),
('THN2023_6Ly', 'THN2023_6', 'Water', 'Water running through my veins
Never thought I''d feel this way'),
('THN2023_7Ly', 'THN2023_7', 'Rigormortis', 'Rigormortis, I can''t move
Locked in place, but still with you'),
('THN2023_8Ly', 'THN2023_8', 'Fine By Myself', 'Fine by myself, I thought I''d be okay
But it''s harder every day'),
('THN2023_9Ly', 'THN2023_9', 'Gave You My All', 'Gave you my all, and you took it away
Now I''m left with nothing to say'),
('LST2024_1Ly', 'LST2024_1', 'Can''t Stay', 'Can''t stay, but I''m still holding on
Trying to find a place where I belong'),
('LST2024_2Ly', 'LST2024_2', 'Modern Day Suicide', 'Modern day suicide, thoughts running wild
Trying to escape the pain inside'),
('LST2024_3Ly', 'LST2024_3', 'Temptress', 'Temptress, leading me astray
But I can''t help but follow your way'),
('LST2024_4Ly', 'LST2024_4', 'You''re Stuck', 'You''re stuck in my mind, can''t get you out
Summer days and endless doubt'),
('LST2024_5Ly', 'LST2024_5', 'SHOWBIZ', 'SHOWBIZ, lights flashing bright
But nothing compares to you tonight'),
('LST2024_6Ly', 'LST2024_6', 'HBTS (Haven''t Been The Same)', 'HBTS, I haven''t been the same
Since you walked out and left me in the rain'),
('LST2024_7Ly', 'LST2024_7', 'Blame U', 'Blame U, but it''s all on me
Couldn''t see what was meant to be'),
('SAZ2024_1Ly', 'SAZ2024_1', 'Sondela', 'Sondela, bring me closer
I just want to feel you over'),
('SAZ2024_2Ly', 'SAZ2024_2', 'Soh-Soh', 'Soh-Soh, don''t let go
We''ve got nowhere else to go'),
('SAZ2024_3Ly', 'SAZ2024_3', 'Onome', 'Onome, you''re my only
Never thought I''d feel so lonely'),
('SAZ2024_4Ly', 'SAZ2024_4', 'Free Me', 'Free me from these chains
I just want to feel again');


-- Insert Favourites Data
INSERT INTO Favourites (song_id, song_title, user_id) VALUES
('LST2024_1', 'Can''t Stay', 1),
('LST2024_7', 'Blame U', 1),
('SAZ2024_2', 'Soh-Soh', 1),
('THN2023_8', 'Fine By Myself', 2),
('THN2023_2', 'All That It Takes', 1),
('SAZ2024_4', 'Free Me', 2);
