# FROM alpine:latest
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine

ARG PUID=9999
ARG TS3URL=https://github.com/redin0s/TS3AudioBot/releases/download/0.12.3/TS3AudioBot_dotnet.tar.gz
ENV USER ts3bot


#install dependencies
RUN apk add --no-cache --update ffmpeg youtube-dl opus-dev

#Add bot user
RUN adduser --disabled-password -u "${PUID}" "${USER}"

RUN mkdir -p "/home/${USER}" \
    && cd "/home/${USER}" \
    && wget $TS3URL -O ts3audiobot.tar.gz \
    && tar xzf ts3audiobot.tar.gz \
    && rm ts3audiobot.tar.gz

RUN chown -R "${USER}" "/home/${USER}"

#Fix error with localisation
# ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

COPY ts3audiobot.toml bot.toml setup.sh "/home/${USER}/"

USER "${USER}"
WORKDIR "/home/${USER}"

CMD ./setup.sh && dotnet ./TS3AudioBot.dll --non-interactive
