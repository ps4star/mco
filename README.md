# Minecraft Odin port stuff

Nowhere near functional but gets a window up and running at least (when it compiles).

# Setup

To setup, you need to extract the MC 1.19.0 JAR into `out/bin/jar_root`. Then take everything in the same directory as your Minecraft executable (`assets/`, `launcher/`, `profiles/`, `mods/`, etc) and throw it into `out/bin/app_root`

# Compile

`make pull_deps ODIN_DIR=/path/to/local/odin/git/root` - this grabs some necessary modified Odin GLFW bindings. `ODIN_DIR` must be the dir that you cloned odin into (contains `core/`, `vendor/`, etc)
`make compile_src`