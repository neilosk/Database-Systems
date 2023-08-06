-- You will need to work with the ReleaseDate and Duration attributes, which have the type
-- date and time, respectively. The expression interval ’1 minute’ can be used to generate
-- a duration value to compare to, the expression extract(year from ReleaseDate) can be
-- used to get a year from a date, and extract(epoch from Duration) can be used to get
-- the total number of seconds in an interval.1
-- Answer each of the following questions using a single SQL query on the examination database. Enter the result of each query into the quiz on LearnIT. As before, queries should
-- adhere to the detailed guidelines given in Homework 1.

-- (A) In the database, 372 songs have a duration of at most 1 minute. How many songs
-- have a duration of over 1 hour?
	select count(*)
	from Songs S 
	where S.duration > interval '1 hour';
-- (B) What is the total duration, in seconds, of all songs in the database?
	select sum(num)
	from(
		select extract(epoch from Duration) as num
		from Songs
		)X;
-- (C) The database contains just 5 songs released in 1953. What is the largest number of
-- songs released in a single year?
-- Note: This is a very simple query. Try also to answer which year had the largest
-- number of songs. Observe how much harder this query is!
	select max(songs)
	from(
		select extract(year from S.ReleaseDate), count(*) as songs
		from Songs S
		group by extract(year from S.ReleaseDate)
		)X;

-- (D) The database contains 12 albums by the artist Queen. How many albums by the
-- artist Tom Waits are in the database?
	select count(distinct AA.AlbumId)
	from AlbumArtists AA
	join Artists A on A.artistId = AA.ArtistId
	where A.artist = 'Queen';
	
	select count(distinct AA.AlbumId)
	from AlbumArtists AA
	join Artists A on A.artistId = AA.ArtistId
	where A.artist = 'Tom Waits';
	

-- (E) The database contains 187 different albums with a genre whose name starts with
-- Ele (for example, some of these have the genre Electronica). How many different
-- albums have a genre whose name starts with Alt?
	select count(distinct AG.AlbumId)
	from AlbumGenres AG
	join Genres G on G.GenreId = AG.GenreId
	where G.Genre  like 'Ele%'

	select count(distinct AG.AlbumId)
	from AlbumGenres AG
	join Genres G on G.GenreId = AG.GenreId
	where G.Genre  like 'Alt%'
-- (F) For how many songs does there exist another different song in the database with the
-- same title?
-- Note: Which join method is used by PostgreSQL to evaluate this query? Does the join
-- method change if you have an index on Songs(Title, SongId)?
	select count(*)
	from (
		select distinct S1.songId
		from Songs S1
		join Songs S2 on S1.title = S2.title
		where S1.songId <> S2.songId
		)X;

-- (G) An album can have multiple genres. There are 1215 albums in the database that do
-- not have the genre Rock. How many albums do not have the genre HipHop?
	select count(*) 
from Albums 
where AlbumId not in (
	select AG.AlbumId 
	from Genres G
		join AlbumGenres AG on G.GenreId = AG.GenreId
	where genre='Rock'
);

-- Near miss: all albums with some genre other than rock
-- select count(distinct AG.albumId) 
-- from AlbumGenres AG 
-- 	join Genres G on G.GenreId = AG.GenreId
-- where G.genre <>'Rock';
-- -- 1222