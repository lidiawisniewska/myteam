# Deploying MyTeam to Railway

This app is configured to run on [Railway](https://railway.app) with managed
PostgreSQL and auto-deploys from GitHub.

## What's already set up in the repo

- **PostgreSQL in every environment** — `pg` gem for dev/test/production (dev/prod
  parity). `config/database.yml` uses local Postgres for dev/test and
  `DATABASE_URL` in production.
- **`Procfile`** — runs `rails db:prepare` (creates/migrates the DB) then boots Puma.
- **`config/environments/production.rb`** — serves static assets via Puma,
  forces SSL behind Railway's proxy (`assume_ssl` + `force_ssl`), logs to STDOUT.
- **Puma** binds to Railway's `$PORT` automatically.

---

## 1. One-time local step: move local dev to Postgres, then push

The app now uses PostgreSQL everywhere, so set it up locally too.

```bash
# Install + start Postgres (macOS / Homebrew)
brew install postgresql@16
brew services start postgresql@16

# Add the Linux platform so Railway can resolve native gems (e.g. pg)
bundle lock --add-platform x86_64-linux
bundle install

# Create and seed your local Postgres database
bin/rails db:create db:migrate db:seed
bin/rails server   # check http://localhost:3000 works on Postgres
```

If your local Postgres needs an explicit user/password, set `PGUSER` /
`PGPASSWORD` (and `PGHOST` if not localhost) — `database.yml` reads them.

Then commit and push to GitHub:

```bash
git add -A && git commit -m "Use PostgreSQL in all environments; configure Railway deploy"
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
| `BUNDLE_WITHOUT` | `development:test` | Skip dev/test-only gems (byebug, capybara, selenium, web-console) at build. |

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
