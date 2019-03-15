Youtube-dl can do quite a lot, but it doesn't cover the edge case where you want to download all the artists a user is following.

Youtube-dl can download everything a specific artist has, but it can't handle processing a list of them given a user's soundcloud followings page.

Usage:
	./wsc.sh

Dependencies:
	youtube-dl

Options: (Edit the script, they're at the top)
	user_id=
		The user id of the soundcloud account you want to download
		the followings for.
	make_artist_dirs="true"
		Download the list of artists from the followings page into
		individual folders or not.


Problems:
	Another thing to keep in mind is that soundcloud api isn't the most stable. 
Occasionally the api will break and return a 500: Internal Server Error.

The api documentation shows:

https://developers.soundcloud.com/docs/api/guide#errors
500 Internal Server Error
Uh-oh. Something went wrong on our side. We're sorry. We keep track of these, and we'll try to fix it!

When this happens, the api is usually broken until the session expires, which might take several days.

Work arounds:
	Try adding 'sleep 1h' after the youtube-dl call in the main loop.
	This will make it wait an hour after youtube-dl processes all the tracks for a single artist from the list.
	This will also significantly increase your download time, but has proven to be the most stable.
	

