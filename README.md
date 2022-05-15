# Dockerized Jottacloud Client
Docker of Jottacloud client side backup daemon with jotta-cli and jottad inside.

Jottacloud is a Cloud Storage (backup) service provider, which offers [unlimited storage space](https://www.jottacloud.com/en/pricing.html) for personal use.

Support platforms: linux/amd64, linux/arm64

**IMPORTANT: Upstream BREAKING CHANGES in 0.12 (Version 0.12.50392 - 2021-10-26)**
https://docs.jottacloud.com/en/articles/1461561-release-notes-for-jottacloud-cli

## Repository
- GitHub: [bluet/docker-jottacloud](https://github.com/bluet/docker-jottacloud/)
- DockerHub: [bluet/jottacloud](https://hub.docker.com/r/bluet/jottacloud)

```
docker pull bluet/jottacloud
```

## Use
`docker run bluet/jottacloud`
```
docker run \
   -e JOTTA_TOKEN=XXXXX \
   -e JOTTA_DEVICE=YYYY \
   -v /dockerdata/jottacloud/config:/data/jottad \
   -v /home/:/backup/home \
   bluet/jottacloud
```
```
docker run \
   -e JOTTA_TOKEN=XXXXX \
   -e JOTTA_DEVICE=YYYY \
   -e JOTTA_SCANINTERVAL=12h \
   -e LOCALTIME=ZZZ/ZZZ \
   -v /data/jottacloud/config:/data/jottad \
   -v /data/jottacloud/ignore:/data/jottad/.ignore \
   -v /data/jottacloud/jotta-cli.env:/data/jotta-cli/jotta-cli.env \
   -v /home/:/backup/home \
   --name jottacloud \
   bluet/jottacloud
```

For debugging:
```
docker run -it bluet/jottacloud bash
```
```
docker exec -it jottacloud bash
```

## Volume mount-point
Path | Description
------------ | -------------
/data/jottad | Config and data. In order to keep login status and track backup progress, please use a persistent volume.
/data/jottad/.ignore | exclude pattern
/data/jotta-cli/jotta-cli.env | jotta-cli.env
/backup/ | Data you want to backup. ex, `-v /home/:/backup/home/`, or -v `/backup/:/backup/`.

## ENV
Name | Value
------------ | -------------
JOTTA_TOKEN | Your `Personal login token`. Please obtain it from Jottacloud dashboard [Settings -> Security](https://www.jottacloud.com/web/secure). This will only show once and can only be used in a short time, so please use persistent volume on `/var/lib/jottad/` to save your login status.
JOTTA_DEVICE | Device name of the backup machine.  Used for identifying which machine these backup data belongs to.
JOTTA_SCANINTERVAL | Interval time of the scan-and-backup. Can be `1h`, `30m`, or `0` for realtime monitoing.
LOCALTIME | Local timezone. ex, `Asia/Taipei`
STARTUP_TIMEOUT | how many second to wait before retry startup.


## Exclude
**IMPORTANT: Upstream BREAKING CHANGES in 0.12 (Version 0.12.50392 - 2021-10-26). .jottaignore no longer works.**
https://docs.jottacloud.com/en/articles/1461561-release-notes-for-jottacloud-cli
It's recommend to exclude some files/folders from being upload, to avoid [triggering speed limit](https://docs.jottacloud.com/en/articles/3271114-reduced-upload-speed) or for security reasons.  
To do so, jotta-cli supports two different ways:
- Global excludes
   - Mount or edit `/config/.ignore` directly.
- Folder specific excludes
  - Put a `.jottaignore` in that folder.

You can also check my sample [.jottaignore](https://github.com/bluet/docker-jottacloud/blob/main/.jottaignore) file.

**Syntax / Pattern**: `.ignore`, `ignorefile`, and `.jottaignore` are `.gitignore` compatible.  You can check templates in [github/gitignore](https://github.com/github/gitignore) or use [Gitignore.io](https://gitignore.io) to generate one for you.

**NOTE**: Adding a new pattern will also apply to files already backup. If you already have a backup which contains `/foo/bar/` and later adds a new pattern `bar/` in ignore list, the `bar/` folder will be removed from all your previous backups and moved to Trash.

## Result
![2021-05-21 09-37-19 的螢幕擷圖](https://user-images.githubusercontent.com/51141/119069168-32407a80-ba18-11eb-824d-82a60d13437a.png)

# Detailed official configuration guide of jotta-cli
- [Jottacloud CLI Configuration
](https://docs.jottacloud.com/en/articles/2750154-jottacloud-cli-configuration)
- [Ignoring files and folders from backup with Jottacloud CLI](https://docs.jottacloud.com/en/articles/1437235-ignoring-files-and-folders-from-backup-with-jottacloud-cli)

## Credit
This is a fork with fixes from [maaximal/jottadocker](https://github.com/maaximal/jottadocker)
