#!/bin/sh

#### Variables that should be set
# PORT where to host the webserver
# ADMIN_UID admin uid
# ADMIN_TOKEN admin token
# BOT_NAME bot name
# BOT_IDENT bot identity key
# BOT_TS3_ADDRESS server address to which to connect
# MUSIC_URL url from which to download a zip file containing the music that you want to store
# RULES contents of the rules.toml file, PLEASE I'M SORRY DON'T JUDGE ME

CONFIG=ts3audiobot.toml
CRULE=rights.toml
TMPFILE=music.tar.gz

function srep {
    # $1 is the key to search, $2 is the value to insert, $3 is the file
    sed -i -e "/$1 =/ s/= .*/= $2/" "$3"
}

function surround {
    echo -ne "\\\"$1\\\""
}
srep "port" "$PORT" "$CONFIG"
srep "admin" $(surround $ADMIN_UID) "$CONFIG"
srep "token" $(surround $ADMIN_TOKEN) "$CONFIG"

#make bot folder
mkdir -p "bots/$BOT_NAME/music"
mv bot.toml "bots/$BOT_NAME/"

srep "name" $(surround $BOT_NAME) "bots/$BOT_NAME/bot.toml"
srep "key" $(surround $BOT_IDENT) "bots/$BOT_NAME/bot.toml"
srep "address" $(surround $BOT_TS3_ADDRESS) "bots/$BOT_NAME/bot.toml"

echo $RULES > "$CRULE"

if [ -n "$MUSIC_URL" ]; then
    ## Do something like downloading the stuff
    wget "$MUSIC_URL" -O "$TMPFILE"
    tar xzf "$TMPFILE" -C "bots/$BOT_NAME/bot.toml"
fi
