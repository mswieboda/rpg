# RPG

## Installation

[install SFML](https://github.com/oprypin/crsfml#install-sfml) 2.5.1

if on a mac, you can use https://github.com/mswieboda/homebrew-sfml for `brew install mswieboda/homebrew-sfml/sfml@2.5`
if on mac silicon, you'll need to build SFML 2.5.1 from source following: https://www.sfml-dev.org/tutorials/2.5/compile-with-cmake.php
(will update here with correct instructions)

```
shards install
```

### Windows

if compiling/installing from Windows, please follow [`game_sf`](https://github.com/mswieboda/game_sf) windows instructions


### Linter

```
bin/ameba
```

or

```
bin/ameba --fix
bin/ameba --gen-config
```
etc, see [ameba](https://github.com/crystal-ameba/ameba)

## Compiling

### Dev / Test

```
make
```

or

```
make test
```

### Release

```
make release
```

### Packaging

#### Windows

creates Windows release build, packages and zips

```
make winpack
```

you'll need `7z` ([7zip](https://www.7-zip.org/) binary) installed ([download](https://www.7-zip.org/))

zips up SFML DLLs, assets, `run.bat` (basically the .exe) to `build/rpg-win.zip`

#### Mac

```
make macpack
```

creates Mac OSX release build, packages and zips

you'll need installed:
- `7zz` ([7zip](https://www.7-zip.org/) binary) via `brew install 7zip`
- `platypus` ([Platypus](https://sveinbjorn.org/platypus) binary) via `brew install --cask platypus` then in `Platypus > Preferences` install the command line tool

zips up SFML libs, ext libs, assets, `rpg.app` (created by [Platypus](https://sveinbjorn.org/platypus)) to `build/rpg-mac.zip`
