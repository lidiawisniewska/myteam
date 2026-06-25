# Deploying MyTeam to Railway

This app is configured to run on [Railway](https://railway.app) with managed
PostgreSQL and auto-deploys from GitHub.

## What's already set up in the repo

- **PostgreSQL in production** — `pg` gem (production group), `sqlite3` for
  local dev/test only. `config/database.yml` reads `DATABASE_URL` in production.
- **`Procfile`** — runs `rails db:prepare` (creates/migrates the DB) then boots Puma.
- **`config/environments/production.rb`** — serves static assets via Puma,
  forces SSL behind Railway's proxy (`assume_ssl` + `force_ssl`), logs to STDOUT.
- **Puma** binds to Railway's `$PORT` automatically.

---

## 1. One-time local step: update the lockfile, then push

The Gemfile changed (added `pg`, pinned Ruby), so refresh `Gemfile.lock` and push.

```bash
# Add the Linux platform so Railway can resolve native gems (e.g. pg)
bundle lock --add-platform x86_64-linux

bundle install
```

If `bundle install` fails locally because PostgreSQL isn't installed (pg needs
`libpq`), you don't need Postgres locally — just skip building it while still
writing it to the lock:

```bash
bundle config set --local without 'production'
bundle install            # updates Gemfile.lock with pg, without compiling it
```

Then commit and push to GitHub:

```bash
git add -A && git commit -m "Configure app for Railway/Postgres deploy"
git push origin master
```

---

## 2. Create the Railway project

1. Go to **railway.app → New Project → Deploy from GitHub repo** and pick `myteam`.
2. In the project, click **New → Database → Add PostgreSQL**.
3. Open your **app service → Variables** and add the variables below.

### Environment variables (app service)

| Variable | Value | Why |
|---|---|---|
| `RAILS_MASTER_KEY` | *(contents of `config/master.key`)* | Decrypts credentials. Run `cat config/master.key` locally and paste the value. **Never commit this file.** |
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Reference variable linking the app to the Postgres add-on. |
| `RAILS_ENV` | `production` | Run in production mode. |
| `RAILS_LOG_TO_STDOUT` | `true` | So logs show up in Railway. |
| `BUNDLE_WITHOUT` | `development:test` | Skip dev/test gems at build (don't compile sqlite3 in prod). |

> If you ever see a `secret_key_base` error, it means credentials didn't load.
> Fallback: generate one with `bin/rails secret` and set it as `SECRET_KEY_BASE`.

---

## 3. Deploy

Railway builds automatically (Nixpacks detects Rails, runs `bundle install` and
`assets:precompile`), then starts the `web` process from the `Procfile`, which
migrates the database and boots Puma.

- **Get a URL:** app service → **Settings → Networking → Generate Domain**.
- Every `git push` to `master` now redeploys automatically.

---

## 4. Load the demo data (once)

`db:prepare` builds the schema but doesn't seed. To populate the demo
candidates/users, run a one-off command against the deployed app:

- **Railway dashboard:** app service → **⋯ → Run a command** → `bundle exec rails db:seed`
- **or Railway CLI:** `railway run bundle exec rails db:seed`

Then log in at your Railway URL with **admin@example.com / password123**.

---

## Known limitation: CV uploads aren't persistent

Uploaded CVs use Active Storage's local disk service, and Railway's filesystem
resets on each deploy — so uploaded files disappear on redeploy. The seed data's
placeholder CVs are recreated whenever you reseed. To make uploads durable later,
either mount a Railway **volume** at `/app/storage` or switch Active Storage to an
S3-compatible bucket. The Postgres database itself **is** persistent.
