# Factorio [![Docker Repository on Quay](https://quay.io/repository/games_on_k8s/factorio/status "Docker Repository on Quay")](https://quay.io/repository/games_on_k8s/factorio)

A Docker image for the [Factorio](https://www.factorio.com/) dedicated server.

## Versions

See [tags](https://quay.io/repository/games_on_k8s/factorio?tab=tags) on Quay for options. If you don't see a version _after_ 0.14.4 that you are looking for, file an issue and or a pull request.

## Usage

The simplest example runs Factorio with default settings. We also mount a volume so that your saves will be retained:
```
docker run -d \
  -v [PATH]:/opt/factorio/saves \
  -p [PORT]:34197/udp \
  quay.io/games_on_k8s/factorio:0.14.14
```
* Where [PATH] is a folder where you'll put your saves. If there already is a save in it with the string "save", that one will be taken by default, otherwise, a new one will be made.
* Where [PORT] is the port number to listen for client connections on.

## Environment Variable Reference

This Docker image uses environment variables to configure the Factorio server. The `gen_config.py` dumps a server-settings.json before the server starts. Here are the possible values (bolded values are the ones you'll generally always want to change):

| Env Var                          | Description  
| ---------------------------------|--------------
| **FACTORIO_SERVER_NAME**             | The name to show in-game and in the server browser (if public).  
| **FACTORIO_DESCRIPTION**             | Server description for the server browser (if public).       
| **FACTORIO_MAX_PLAYERS**             | Maximum number of players allowed, admins can join even a full server. 0 means unlimited.      
| FACTORIO_PUBLISH_ON_LAN               | If `true`, make this game available on the server's LAN. Defaults to `true`.
| FACTORIO_IS_PUBLIC               | If `true`, advertise this server on the Factorio game browser. You'll also need to set FACTORIO_USER_USERNAME and FACTORIO_USER_PASSWORD. Defaults to `false`.
| FACTORIO_USER_USERNAME           | If this server is public, a Factorio username to auth the server with.
| FACTORIO_USER_PASSWORD           | The Factorio user's matching password.
| FACTORIO_GAME_PASSWORD           | If set, this password will be required to join.
| FACTORIO_REQUIRE_USER_VERIFICATION | When set to true, the server will only allow clients that have a valid Factorio.com account
| FACTORIO_MAX_UPLOAD_KBPS         | Default value is `0`. `0` means unlimited.
| FACTORIO_IGNORE_PLAYER_LIMIT_FOR_RETURNERS | If `true`, players who have joined the server before are always allowed. Even if the player limit has been reached. `false` (default) enforces the player limit for all cases.
| FACTORIO_ALLOW_COMMANDS          | Allows or disallows console commands. Must be one of: `true`, `false`, or `admins-only` (default).
| FACTORIO_AUTOSAVE_INTERVAL       | Autosave interval in minutes. Defaults to `10`.
| FACTORIO_AUTOSAVE_SLOTS          | Server autosave slots, it is cycled through when the server autosaves. Defaults to `5`.
| FACTORIO_AUTOKICK_INTERVAL       | How many minutes until someone is kicked when doing nothing, `0` for never. Defaults to `0`.
| FACTORIO_AUTO_PAUSE              | Whether should the server be paused when no players are present. `true` (default) or `false`.
| FACTORIO_ONLY_ADMINS_PAUSE       | Only allow admins to pause the game if `true` (default), `false` allows everyone.
| FACTORIO_AUTOSAVE_ONLY_ON_SERVER | Whether autosaves should be saved only on server or also on all connected clients. `true` (default) or `false`.
| FACTORIO_ADMINS                  | A commaa-separated list of usernames who are set as admins.
| FACTORIO_PORT                    | Port number to run game server on. Default is 34197.
| FACTORIO_RCON_PORT               | Port number to run RCON on. Default is 27015.
| FACTORIO_RCON_PASSWORD           | The password to use for RCON. Omitting this will cause one to be auto-generated and emitted to stdout.
## Troubleshooting

### Authorization Error

If your container exits with the following error:
```
Info HttpSharedState.cpp:83: Status code: 401
Info AuthServerConnector.cpp:40: Error in communication with auth server: code(401) message({
  "message": "Username and password don't match",
  "status": 401
})
Info AuthServerConnector.cpp:68: Auth server authorization error (Username and password don't match)
Error Util.cpp:57: Unknown error
```
Check supplied Username and Password for mistakes.

## Cutting a new release

For maintainers with write access to Quay, here's how to cut a new release:
```
./make_release.sh 0.14.15
```
This will download the correct archive, build a Docker image, and run it locally. Test against the built image, then CTRL+C out of the server. The script will prompt you through the rest of the release process.

**NOTE: If the env vars have changed in the release compared to what is currently in the repo, you'll need to adjust gen_config.py and this README.md accordingly.**

Once the Docker image is pushed, make sure any changes to this repo are committed then create a new tag matching the version number of the release.

````
git commit -am "Made some changes. Woohoo."
git push
git tag 0.14.15 && git push --tags
```
