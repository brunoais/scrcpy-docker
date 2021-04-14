# Scrcpy docker development and compilation environment

An unafiliated script set to, system agnostically, compile and run scrcpy.

# What is

Set of scripts and Dockerfiles simplifying and providing a stable environment to develop scrcpy for POSIX. Also provides means to run the scrcpy compiled inside the environment without constant recompile.

# What is for

1. Develop Scrcpy without worrying about preparing the environment
2. Use your developed/tweaked version by yourself without worry it may not install in your system


# Use warning

The scripts are **not** built to be rubust. They are not ready for edge cases. They won't make your PC explode but they may fail to do their job if you reach such situation.
Instead they are built to be balanced in a straightforward way.


# TODO

1. Prepare scripts and allow make it work with USB while keeping the system safe (in case of system-wiping level of mistakes)
2. Provide a stable environment to automatically package (may require interest from scrcpy's maker)
   1. Appimage
   2. Snap
   3. Flatpack
3. Make it idiot proof


# Requirements

1. Bash shell (only tested on bash)
2. Docker
   1. E.g. `apt install docker-ce`

### Auto-installed requirements by `setup.sh`
1. x11docker (installed by the setup script)
   1. For MacOS, I accept issues for x11docker alternatives

# Setup

Run `setup.sh` to setup the environment with some guidance.

All the values set by the setup are overridable by setting the relevant environment variables before calling the runners.  
You can find the most relevant variables in `.source.base.sh`.

# Scripts overview

* Settings
  * `setup.sh` sets up the settings with some guidance
  * `.source.base.sh` Base file for `.source.sh` only edit if you intent to make a PR
  * `.source.sh` file used as a source for environment variables
  * `.source_extra.sh` Extra commands for `.source.sh`
* DockerFiles
  * `Dockerfile_prepare` Prepares the environment for scrcpy compilation (part1) for running using `run_compile.sh`
    * If using provided scripts, compilation is done into RAM storage
  * `Dockerfile_compile` ensures part1 was run and pre-compiles scrcpy for running repeatedly using `run_compiled.sh`
* Build scripts
  * `build_compile.sh` Runs `Dockerfile_prepare` with the expected/example arguments
  * `build_compiled.sh` Runs `Dockerfile_compile` with the expected/example arguments
* Run scripts
  * In your environment:
    * `run_compile.sh` runs the result of `build_compile.sh` with the expected/example arguments
      * Note: you can add arguments to start with different parameters or even a completely different script (use `bash` as the first argument)
    *  `run_compiled.sh` runs the result of `build_compiled.sh` with the expected/example arguments
       * Note: you can add arguments to start with different parameters or even a completely different script (use `bash` as the first argument)
     * Inside docker environment:
       * `containerScripts/*` Scripts run inside Docker
       * `containerScripts/run.sh` The default starter script
* Extension scripts
  * Script files you may make yourself to extend functionality.  
      They are sourced so you can use them to add alias, functions, add/override environment variables or just run preconditions before all other code
    * In your environment:
      * `.source_extra.sh` Set or override before every script (except `setup.sh`)
    * Inside docker environment:
      * `containerScripts/after_compile.sh`: After compilation (when it's run)
      * `containerScripts/before_connect.sh`: Before adb tries to connect to the phone
      * `containerScripts/before_starting.sh`: Before scrcpy starts


# Usage examples

### Compile once and execute many times
(after initial setup)

Run once: `build_compiled.sh`
Then run every time you want scrcpy: `run_compiled.sh`

### scrcpy development
(after initial setup)

Run once: `build_compile.sh`
Then run every time you want to develop: `run_compile.sh`

In the container, (added by default to `.bash_history` by dockerfile) run `run.sh --compile` to compile scrcpy and run the compilation result.


# Caveats / known bugs

1. Cannot compile scrcpy's server yet. Something is wrong with the android sdk version.

