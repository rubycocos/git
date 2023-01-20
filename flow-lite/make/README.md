# Notes on make, rake, & co.


## Options

debug:

```
make:
  -d                          Print lots of debugging information.
  --debug[=FLAGS]             Print various types of debugging information.

rake:
  ?
```


file:

```
make:
  -f FILE, --file=FILE, --makefile=FILE    Read FILE as a makefile.

rake:
  -f, --rakefile [FILENAME]                Use FILENAME as the rakefile to search for.
```







## Make

make command line options - `$ make -h`:

```
Usage: make [options] [target] ...
Options:
  -b, -m                      Ignored for compatibility.
  -B, --always-make           Unconditionally make all targets.
  -C DIRECTORY, --directory=DIRECTORY
                              Change to DIRECTORY before doing anything.
  -d                          Print lots of debugging information.
  --debug[=FLAGS]             Print various types of debugging information.
  -e, --environment-overrides
                              Environment variables override makefiles.
  -f FILE, --file=FILE, --makefile=FILE
                              Read FILE as a makefile.
  -h, --help                  Print this message and exit.
  -i, --ignore-errors         Ignore errors from commands.
  -I DIRECTORY, --include-dir=DIRECTORY
                              Search DIRECTORY for included makefiles.
  -j [N], --jobs[=N]          Allow N jobs at once; infinite jobs with no arg.
  -k, --keep-going            Keep going when some targets can't be made.
  -l [N], --load-average[=N], --max-load[=N]
                              Don't start multiple jobs unless load is below N.
  -L, --check-symlink-times   Use the latest mtime between symlinks and target.
  -n, --just-print, --dry-run, --recon
                              Don't actually run any commands; just print them.
  -o FILE, --old-file=FILE, --assume-old=FILE
                              Consider FILE to be very old and don't remake it.
  -p, --print-data-base       Print make's internal database.
  -q, --question              Run no commands; exit status says if up to date.
  -r, --no-builtin-rules      Disable the built-in implicit rules.
  -R, --no-builtin-variables  Disable the built-in variable settings.
  -s, --silent, --quiet       Don't echo commands.
  -S, --no-keep-going, --stop
                              Turns off -k.
  -t, --touch                 Touch targets instead of remaking them.
  -v, --version               Print the version number of make and exit.
  -w, --print-directory       Print the current directory.
  --no-print-directory        Turn off -w, even if it was turned on implicitly.
  -W FILE, --what-if=FILE, --new-file=FILE, --assume-new=FILE
                              Consider FILE to be infinitely new.
  --warn-undefined-variables  Warn when an undefined variable is referenced.
```



## Rake

rake command line options - `$rake -h`:

```
rake [-f rakefile] {options} targets...

Options are ...
        --backtrace=[OUT]            Enable full backtrace.  OUT can be stderr (default) or stdout.
        --comments                   Show commented tasks only
        --job-stats [LEVEL]          Display job statistics. LEVEL=history displays a complete job list
        --rules                      Trace the rules resolution.
        --suppress-backtrace PATTERN Suppress backtrace lines matching regexp PATTERN. Ignored if --trace is on.
    -A, --all                        Show all tasks, even uncommented ones (in combination with -T or -D)
    -B, --build-all                  Build all prerequisites, including those which are up-to-date.
    -D, --describe [PATTERN]         Describe the tasks (matching optional PATTERN), then exit.
    -e, --execute CODE               Execute some Ruby code and exit.
    -E, --execute-continue CODE      Execute some Ruby code, then continue with normal task processing.
    -f, --rakefile [FILENAME]        Use FILENAME as the rakefile to search for.
    -G, --no-system, --nosystem      Use standard project Rakefile search paths, ignore system wide rakefiles.
    -g, --system                     Using system wide (global) rakefiles (usually '~/.rake/*.rake').
    -I, --libdir LIBDIR              Include LIBDIR in the search path for required modules.
    -j, --jobs [NUMBER]              Specifies the maximum number of tasks to execute in parallel. (default is number of CPU cores + 4)
    -m, --multitask                  Treat all tasks as multitasks.
    -n, --dry-run                    Do a dry run without executing actions.
    -N, --no-search, --nosearch      Do not search parent directories for the Rakefile.
    -P, --prereqs                    Display the tasks and dependencies, then exit.
    -p, --execute-print CODE         Execute some Ruby code, print the result, then exit.
    -q, --quiet                      Do not log messages to standard output.
    -r, --require MODULE             Require MODULE before executing rakefile.
    -R, --rakelibdir RAKELIBDIR,     Auto-import any .rake files in RAKELIBDIR. (default is 'rakelib')
        --rakelib
    -s, --silent                     Like --quiet, but also suppresses the 'in directory' announcement.
    -t, --trace=[OUT]                Turn on invoke/execute tracing, enable full backtrace. OUT can be stderr (default) or stdout.
    -T, --tasks [PATTERN]            Display the tasks (matching optional PATTERN) with descriptions, then exit. -AT combination displays all of tasks contained no description.
    -v, --verbose                    Log message to standard output.
    -V, --version                    Display the program version.
    -W, --where [PATTERN]            Describe the tasks (matching optional PATTERN), then exit.
    -X, --no-deprecation-warnings    Disable the deprecation warnings.
    -h, -H, --help                   Display this help message.

```
