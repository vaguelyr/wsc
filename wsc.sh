#!/bin/bash
# vague

# settings
client_id=NmW1FlPaiL94ueEu7oziOWjYEzZzQDcK # from youtube-dl
user_id=286953612
#make_artist_dirs="false"
make_artist_dirs="true"

page=$(wget -O - "https://api.soundcloud.com/users/$user_id/followings?client_id=$client_id")
echo $page

# Access the api to make a giant list of all the followings
followings_list=""
while true ; do
	# get the followings
	followings=$(echo $page | sed -e 's/,/\n/g' | grep permalink_url | grep http.*[^\"] -o )
	followings_list="$followings_list $followings"

	# get next page
	next_page_link=$(echo $page | grep next_href\":\".*[^\"}] -o | grep http.* -o)
	if [ -z "$next_page_link" ] ; then
		echo out of pages
		break
	fi
	page=$(wget -O - $next_page_link)
done

# Download all the followings

echo got $followings_list
echo downloading

mkdir -p tracks
cd tracks || { echo cant cd into download directory. quitting ; exit; }

for artist in $( echo $followings_list | sed -e 's|\ |\n|g')  ; do
	echo downloading $artist
	if [ "$make_artist_dirs" = "true" ] ; then
		name=$(echo $artist | sed -e 's|.*com/||')
		mkdir -p "$name"
		pushd "$name" || { echo cant cd into download directory. quitting ; exit; }
	fi
	youtube-dl "$artist"
	popd
done

