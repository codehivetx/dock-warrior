# dock-warrior
Docker environment for taskwarrior/timewarrior/etc.

## HISTORY

So, taskwarrior + timewarrior + bugwarrior and other stuff runs my business. I just do the coding.  In 2022, I had to abruptly switch to a backup system.  Rather than reinstall everything yet again and migrate the data, I thought I'd dockerize everything.

## HOWTO

Build with `docker build -t srl295/dock-warrior:dev .`

Then run with (script alias recommended!)

```shell
$ export DOCK_WARRIOR_CONFIG=/somewhere/config
$ export DOCK_WARRIOR_DATA=/somewhere/data
$ alias dock-warrior="docker run -v ${DOCK_WARRIOR_CONFIG}:/config:ro -v ${DOCK_WARRIOR_DATA}:/data:rw --"
$ alias dock-warrior-task="dock-warrior task"
```

now if you do `dock-warrior-task` it runs `task` inside of the container.

## SETUP

### data

The `/data` volume has subdirectories for each component:

- `task/` (this is the `TASKDATA` variable)
- `timew/`

### config

The `/config` volume is intended to be mounted readonly, and has subdirectories for each component:

- `task/`

The file `/config/task/taskrc` (no initial dot) is used as the TASKRC

- `timew/`

## AUTHOR

Steven R. Loomis, [@srl295](https://srl295.github.io) of [@codehivetx](https://github.com/codehivetx)
