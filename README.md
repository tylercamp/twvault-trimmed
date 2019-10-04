# twvault
This is a slightly-modified copy of the source code for my Tribal Wars Vault: https://forum.tribalwars.net/index.php?threads/vault.282252/

The only change is removal of anti-tamper and encryption features.

twvault is no longer being actively developed beyond bugfixes for major issues. I encourage any changes via pull request to this repo. Changes to the primary, private copy of this project will be occasionally folded back in to this repository.

# Getting Started
Requirements:

- Visual Studio
- dotnet core 2.2 SDK

Optional:

- Docker
- bash shell (eg git bash)

Use the resources in the `docker` folder of this repository to set up a local copy of the vault database.

**This repository has not been extensively tested beyond being able to start the web server.** There may be small errors when using the script itself; open an issue and I'll address them as they appear.

# Project Overview

## TW.ConfigurationFetcher
A WIP tool for automatically fetching config info for Tribal Wars game servers. Not extensively tested and not actively being used.

## TW.Testing
A tool for miscellaneous testing of different features. Not intended to actually be used. Can be checked as a reference for how to use some different utilities in the project.

## TW.Vault.App
The web server application for the vault. Provides .NET Web API controllers for all endpoints handled by the vault, as well as JavaScript files for the main `vault.js` file that is served.

### Controllers
Each class under `TW.Vault.App.Controllers` serves a different base endpoint, eg `AdminController` serves content for `/api/admin`, etc. Endpoints generally take the form `/api/{worldName}/...`. All controllers that provide app features will inherit from `BaseController`, which has utilities for retrieving info on:
- The current authenticated user (from headers)
- The Tribal Wars world that was requested and its config (from URL parameters)
- Translation utilities
- Database collection classes scoped to the current user and world (class `CurrentContextDbSets` and property `CurrentSets`)

Utility controllers such as `Script` and `Performance` don't provide TW-specific features and don't use this base class.

### Script files
#### Script Generation/Merging
A custom script "compiler" is used in `ScriptController` to merge files under `TW.Vault.App/wwwroot` into a single file. The root scripts are `wwwroot/main.js` and `wwwroot/vault.js`. `vault.js` is the primary entry-point. Scripts are merged by using the syntax in a script file:

```js
//# REQUIRE file.js
```

Contents of the required script are inserted using a basic text-replace, and each required file will only be included once in the final script.

#### Script Files Organization
```
- wwwroot/

- - lib/   - Misc. utility files

- - - lib.js   - Contains most utility functions, eg API querying, time parsing, translations

- - pages/ - Page-specific scripts for parsing data from different Tribal Wars pages

- - ui/    - Scripts for presenting UI. Each script in this folder provides UI for
             different pages, eg map and incomings. Any page that doesn't have its
             own specific UI will use the default Vault UI containing different
             tabs.
             
- - - vault/   - Scripts for UI in the main vault interface; each file (generally)
                 represents a different tab in the UI
```

## TW.Vault.Lib
Contains most of the TW-specific calculations and model types, as well as misc. utilities.

### TW.Vault.Lib.Features
Logic forming the base of many vault features, eg command planning, searching villages, and battle simulations.

### TW.Vault.Lib.Model
TW-specific model types and related calculations. (Does not contain DB model types.) Includes utilities for converting JSON <-> DB types, TW-specific entity data (eg troop attack/defense power, building construction times.)

### TW.Vault.Lib.Scaffold
Database model types and `DatabaseContext` which enable communication with a database.

### TW.Vault.Lib.Security
Utilities for security features in the vault.

## TW.Vault.MapDataFetcher
Utility for retrieving the latest village, player, tribe, and conquer data from all worlds in the provided database. Automatically refreshes data hourly and provides an endpoint for forcing an update.
