#!/bin/sh

#### Variables that should be set
# ENV_URL url to download the archive that contains the env variables (tar.gz)
# ENV_PW archive password
# PORT where to host the webserver
# ADMIN_UID admin uid
# ADMIN_TOKEN admin token
# BOT_NAME bot name
# BOT_IDENT bot identity key
# BOT_TS3_ADDRESS server address to which to connect
# MUSIC_URL url from which to download a zip file containing the music that you want to store
# RULES contents of the rules.toml file, PLEASE I'M SORRY DON'T JUDGE ME
###
# The archive is encrypted with these flags
# -aes-256-cbc -pbkdf2 -md sha512 -salt -iter 10000
# why? just because
###

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

if [ -n "$ENV_URL" ]; then
    echo "ENV_URL found getting the tokens..."
    wget "$ENV_URL" -O "tokens.tar.gz"
    openssl enc -d -aes-256-cbc -pbkdf2 -md sha512 -salt -iter 10000 -pass pass:$ENV_PW -in "tokens.tar.gz" -out "tokensdec.tar.gz"
    tar xzf "tokensdec.tar.gz"
    rm "tokens.tar.gz" "tokensdec.tar.gz"
    set -a; . ./tokens.env ; set +a
fi

srep "port" "$PORT" "$CONFIG"
srep "admin" $(surround $ADMIN_UID) "$CONFIG"
srep "token" $(surround $ADMIN_TOKEN) "$CONFIG"

#make bot folder
mkdir -p "bots/$BOT_NAME/music"
mv bot.toml "bots/$BOT_NAME/"

srep "name" $(surround $BOT_NAME) "bots/$BOT_NAME/bot.toml"
srep "key" $(surround $BOT_IDENT) "bots/$BOT_NAME/bot.toml"
srep "address" $(surround $BOT_TS3_ADDRESS) "bots/$BOT_NAME/bot.toml"

echo -e $RULES > "$CRULE"

if [ -n "$MUSIC_URL" ]; then
    ## Do something like downloading the stuff
    wget "$MUSIC_URL" -O "$TMPFILE"
    tar xzf "$TMPFILE" -C "bots/$BOT_NAME/bot.toml"
fi
