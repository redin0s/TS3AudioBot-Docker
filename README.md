# Docker for TS3AudioBot

This is not a "Plug and Play" type of solution, I made this specifically for my own need in order to deploy the [TS3AudioBot](https://github.com/Splamy/TS3AudioBot) on a free provider. This is awful, use it as an example of how not to do things, this is just a hacky solution without modifying too much code that fits my needs.

# Guide

You can modify `bot.toml` and `ts3audiobot.toml` in order to change the default configs, `setup.sh` is a script that changes the contents of the files based on the environment variables that are set.

Currently these are the environment variables.

- ENV_URL (tar.gz) file encrypted that contains a `tokens.env` with all the mentioned environment variables
- ENV_PW password to decrypt the file

the file is encrypted with openssl with the following flags `-aes-256-cbc -pbkdf2 -md sha512 -salt -iter 10000`

- PORT where to host the webserver
- ADMIN_UID must be the same as the admin uid in the rights.toml file, it's necessary for making a default api token
- ADMIN_TOKEN "password" for the api token
- BOT_NAME name of the bot in TS3
- BOT_IDENT key for the client identity
- BOT_TS3_ADDRESS TS3 server address
- MUSIC_URL a tar.gz file that contains all the music that should be inside the bot
- RULES contents of the rights.toml, there is probably a cleaner and maintainable way, but this works (don't judge me pls :) )
