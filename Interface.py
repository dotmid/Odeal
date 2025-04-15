from flask import Flask, render_template, request, redirect, url_for, session, flash
import sqlite3

app = Flask(__name__)
app.secret_key = '101_284_058'

def get_db_connection():
    conn = sqlite3.connect('odeal_discography.db')
    conn.row_factory = sqlite3.Row
    return conn



@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        conn = get_db_connection()
        user = conn.execute('SELECT * FROM User WHERE user_name = ? AND password = ?', (username, password)).fetchone()
        conn.close()
        if user:
            session['user_id'] = user['user_id']
            session['username'] = user['user_name']
            flash('Login successful!', 'success')
            return redirect(url_for('index'))
        else:
            flash('Invalid username or password.', 'danger')
    return render_template('login.html')


@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'info')
    return redirect(url_for('login'))

@app.route('/index')
def index():
    if 'user_id' not in session:
        flash('Please log in to access the website.', 'warning')
        return redirect(url_for('login'))
    conn = get_db_connection()
    albums = conn.execute('SELECT * FROM Album').fetchall()
    conn.close()
    return render_template('index.html', albums=albums)

@app.route('/album/<album_id>')
def album_details(album_id):
    if 'user_id' not in session:
        flash('Please log in to access the website.', 'warning')
        return redirect(url_for('login'))
    conn = get_db_connection()
    album = conn.execute('SELECT * FROM Album WHERE album_id = ?', (album_id,)).fetchone()
    songs = conn.execute('SELECT * FROM Song WHERE album_id = ?', (album_id,)).fetchall()
    conn.close()
    return render_template('album_details.html', album=album, songs=songs)

@app.route('/favourites')
def favourites():
    if 'user_id' not in session:
        flash('Please log in to access your favourites.', 'warning')
        return redirect(url_for('login'))
    user_id = session['user_id']
    conn = get_db_connection()
    favourites = conn.execute('SELECT * FROM Favourites WHERE user_id = ?', (user_id,)).fetchall()
    conn.close()
    return render_template('favourites.html', favourites=favourites, user_id=user_id)

@app.route('/add_favourite', methods=['POST'])
def add_favourite():
    if 'user_id' not in session:
        flash('Please log in to add favourites.', 'warning')
        return redirect(url_for('login'))
    song_id = request.form['song_id']
    user_id = session['user_id']
    conn = get_db_connection()
    song = conn.execute('SELECT song_title FROM Song WHERE song_id = ?', (song_id,)).fetchone()
    conn.execute('INSERT INTO Favourites (song_id, song_title, user_id) VALUES (?, ?, ?)',
                 (song_id, song['song_title'], user_id))
    conn.commit()
    conn.close()
    flash('Song added to favourites.', 'success')
    return redirect(url_for('favourites'))

@app.route('/remove_favourite', methods=['POST'])
def remove_favourite():
    if 'user_id' not in session:
        flash('Please log in to remove favourites.', 'warning')
        return redirect(url_for('login'))
    favourite_id = request.form['favourite_id']
    user_id = session['user_id']
    conn = get_db_connection()
    conn.execute('DELETE FROM Favourites WHERE favourite_id = ? AND user_id = ?', (favourite_id, user_id))
    conn.commit()
    conn.close()
    flash('Song removed from favourites.', 'info')
    return redirect(url_for('favourites'))

@app.route('/all_songs', methods=['GET', 'POST'])
def all_songs():
    if 'user_id' not in session:
        flash('Please log in to access the website.', 'warning')
        return redirect(url_for('login'))
    conn = get_db_connection()
    songs = None
    if request.method == 'POST':
        filter_type = request.form['filter_type']
        filter_value = request.form['filter_value']
        if filter_type == 'album':
            songs = conn.execute('''
                SELECT Song.song_id, Song.song_title, Album.album_name, Album.album_id 
                FROM Song 
                JOIN Album ON Song.album_id = Album.album_id
                WHERE Album.album_name LIKE ?
            ''', ('%' + filter_value + '%',)).fetchall()
        elif filter_type == 'producer':
            songs = conn.execute('''
                SELECT Song.song_id, Song.song_title, Album.album_name, Album.album_id 
                FROM Song 
                JOIN Album ON Song.album_id = Album.album_id
                WHERE Album.producer LIKE ?
            ''', ('%' + filter_value + '%',)).fetchall()
    else:
        songs = conn.execute('''
            SELECT Song.song_id, Song.song_title, Album.album_name, Album.album_id 
            FROM Song 
            JOIN Album ON Song.album_id = Album.album_id
        ''').fetchall()
    conn.close()
    return render_template('all_songs.html', songs=songs)

# displays the details of a song
@app.route('/song/<song_id>')
def song_details(song_id):
    if 'user_id' not in session:
        flash('Please log in to access the website.', 'warning')
        return redirect(url_for('login'))
    conn = get_db_connection()
    song = conn.execute('''
        SELECT Song.*, Album.album_name, Album.album_id 
        FROM Song 
        JOIN Album ON Song.album_id = Album.album_id 
        WHERE song_id = ?
    ''', (song_id,)).fetchone()
    lyrics = conn.execute('SELECT * FROM Lyrics WHERE song_id = ?', (song_id,)).fetchone()
    conn.close()
    return render_template('song_details.html', song=song, lyrics=lyrics)

@app.route('/collaborations')
def collaborations():
    if 'user_id' not in session:
        flash('Please log in to access the website.', 'warning')
        return redirect(url_for('login'))
    conn = get_db_connection()
    collaborations = conn.execute('''
        SELECT Song.song_title, Song.song_id, Collaborations.artist_name
        FROM Song
        JOIN Collaborations ON Song.song_id = Collaborations.song_id
    ''').fetchall()
    conn.close()
    return render_template('collaborations.html', collaborations=collaborations)

@app.route('/search', methods=['GET', 'POST'])
def search():
    if 'user_id' not in session:
        flash('Please log in to access the website.', 'warning')
        return redirect(url_for('login'))
    results = None
    search_term = None
    if request.method == 'POST':
        search_term = request.form['search_term']
        conn = get_db_connection()
        results = {
            'songs': [],
            'albums': [],
            'collaborations': [],
            'producers': []
        }

        # Search for songs by title
        song_results = conn.execute('''
            SELECT Song.song_title, Song.song_id, Album.album_name, Album.album_id
            FROM Song
            JOIN Album ON Song.album_id = Album.album_id
            WHERE Song.song_title LIKE ?
        ''', ('%' + search_term + '%',)).fetchall()
        results['songs'].extend(song_results)

        # Search for albums by name and include their songs
        album_results = conn.execute('''
            SELECT album_name, album_id
            FROM Album
            WHERE album_name LIKE ?
        ''', ('%' + search_term + '%',)).fetchall()
        for album in album_results:
            album_songs = conn.execute('''
                SELECT song_title, song_id
                FROM Song
                WHERE album_id = ?
            ''', (album['album_id'],)).fetchall()
            results['albums'].append({'album': album, 'songs': album_songs})

        # Search for collaborations by artist name and include their songs
        collab_results = conn.execute('''
            SELECT Collaborations.artist_name, Song.song_title, Song.song_id, Album.album_name, Album.album_id
            FROM Collaborations
            JOIN Song ON Collaborations.song_id = Song.song_id
            JOIN Album ON Song.album_id = Album.album_id
            WHERE Collaborations.artist_name LIKE ?
        ''', ('%' + search_term + '%',)).fetchall()
        results['collaborations'].extend(collab_results)

        # Search for songs by producer
        producer_results = conn.execute('''
            SELECT Song.song_title, Song.song_id, Album.album_name, Album.album_id
            FROM Song
            JOIN Album ON Song.album_id = Album.album_id
            WHERE Album.producer LIKE ?
        ''', ('%' + search_term + '%',)).fetchall()
        results['producers'].extend(producer_results)

        conn.close()

    return render_template('search.html', results=results, search_term=search_term)

if __name__ == '__main__':
    app.run(debug=True)
