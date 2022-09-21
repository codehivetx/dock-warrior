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
- `timew/` (this is the `TIMEWARRIORDB` variable)

### config

The `/config` volume is intended to be mounted readonly, and has subdirectories for each component:

- `task/`

The file `/config/task/taskrc` (no initial dot) is used as the TASKRC

- `timew/`

This isn't currently used, because timew keeps the data and config in the same spot.

## MIGRATING

to migrate from a 'desktop' installation:

0. create the `data` and `config` directories
1. copy `~/.taskrc` to `config/task/taskrc`
2. edit `taskrc` to set `data.location=/data/task`
3. you might want to disable any task hooks for now (TODO)
4. copy `~/.task/` directory to become `data/task/` 
5. copy `~/.timewarrior/` directory to become `data/timew/`


## AUTHOR

Steven R. Loomis, [@srl295](https://srl295.github.io) of [@codehivetx](https://github.com/codehivetx)
