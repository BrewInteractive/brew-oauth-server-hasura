# TMRW-ID BACKEND API GATEWAY

## Run

The following command can be executed to up a local hasura environment:

```bash
docker-compose up -d
```

## Applying Migrations

Hasura service in our docker environment applies found migrations in its migration folder automatically on start.

So, after getting changes from master branch with:

```bash
git pull
```

Containers should be up with:

```bash
docker-compose up -d
```

or if they are already up, just restart them:

```bash
docker-compose restart
```

That's all. All migrations will be applied in your local server.

## Reaching Hasura Console

### Windows

```powershell
cd tmrw-id
npx hasura console --admin-secret secret --api-host http://localhost --api-port 9693
```

## Squashing Migrations

The following command can be executed to squash migrations into one migration from version `1589810113314`

```bash
docker-compose exec hasura hasura-cli migrate squash --name "<name>" --from 1589810113314
```

For detailed information see:

[Hasura CLI: hasura migrate squash](https://hasura.io/docs/1.0/graphql/manual/hasura-cli/hasura_migrate_squash.html)
