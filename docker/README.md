# Installing Vault DB via Docker

Requirements:
- Docker
- pgAdmin (to test your installation, though not required)
- Bash shell (ie git bash)

### Installing Postgres to Docker

Run: `sh postgres-prepare.sh`

### Testing Postgres Connection

Open pgAdmin and connect using:
- Username: `u_vault`
- Password: `vaulttest`
- Port: `5432`
- Hostname: `localhost`

If you connect successfully, it worked and postgres is running. There should be a database named `vault` on the connected server.

### Installing Vault Schema

Make sure the DB is running first by checking for a successful connection.

Run: `sh postgres-install-vault.sh`

This will delete any previous `vault` database, create a new one, and generate the appropriate tables/schemas. Can be used to clear out old data.

Connect to the database via pgAdmin and you should see the schemas: `feature`, `security`, `tw`, `tw_provided`.

### Starting Database

The database won't start automatically when docker is started up. Run this to start it manually: `docker start vaultdb`

### Deleting Database

Run: `sh postgres-delete.sh`

# Connection String

Your local connection string will be:

```
Server=localhost; Port=5432; Database=vault; User Id=u_vault; Password=vaulttest
```

This should already be in use in the relevant projects' `appsettings.json` files.

# Loading World Data

Database generation pre-loads the default English translation and various world configurations. It does not include data for those worlds, ie villages, players, etc.

Run the `TW.Vault.MapDataFetcher`, which will auto-pull and populate that information for each registered world.

So long as it's not running through IIS, a command prompt will appear with the progress of the data scraping. Once you see the message "Finished in Xms", you can stop the data fetcher.

Connect to the database via pgAdmin and check the contents of the table `tw_provided.player` - it should be populated with rows.

# Accessing the Vault Script

The Vault server doesn't support HTTPS natively - instead, it's hidden behind an NGINX reverse-proxy on the server that handles HTTPS. Send me your IP and I'll add a rule
to redirect certain endpoints to your IP.

When running the Vault from Visual Studio, make sure that it runs using the application directly, and not through IIS Express.

# Creating Users

You'll first create an Access Group, and then a User. Both are tables in the `security` schema.

With pgAdmin, edit the data for the `access_group` table and fill out the data accordingly. World ID should match a row in the `tw_provided.world` table. Save your changes.

Edit the data for the `user` table and fill out the data accordingly. Some notes:
- `permissions_level` should be `1` (normal) or `2` (admin)
- `enabled` should explicitly be set to `true`
- `auth_token` needs to be generated, ie https://www.guidgenerator.com/
- `transaction_time` can be set to `now()`
- `is_read_only` should explicitly be set to `false`
- `access_group_id` should match the ID of the group you made previously

Save your changes.

Log on to the world you made the user for, and run:

`javascript:window.vaultToken='your-auth-token';$.getScript('https://v.tylercamp.me/{some-base}/script/main.js)`

The script should load fine, and you should be able to upload and use the vault normally.