# MyTeam — Claude Context

## What this app does
In-house recruitment tool. HR users add candidates (name, email, team, CV upload). On creation, the app auto-enriches the candidate profile using their email address, pulling in LinkedIn, Twitter, company, bio, etc.

## Key architecture decisions

### Email enrichment: People Data Labs (not Clearbit)
- Clearbit was shut down in April 2025 (acquired by HubSpot).
- Enrichment now uses the **People Data Labs (PDL) Person Enrichment API**.
- Logic lives in `app/lib/candidate_enrichment.rb`.
- API key is read from `Rails.application.credentials.people_data_labs_api_key` — add it via `bin/rails credentials:edit`.
- PDL free tier: 1,000 records/month.
- PDL docs: https://docs.peopledatalabs.com/docs/person-enrichment-api

### File uploads: ActiveStorage (not Paperclip)
- Paperclip was deprecated in 2018 and removed.
- CVs are now stored via Rails ActiveStorage (`has_one_attached :cv` on `Candidate`).
- The old Paperclip columns (`cv_file_name`, `cv_content_type`, etc.) are still in the DB schema but unused — ActiveStorage uses its own `active_storage_blobs` and `active_storage_attachments` tables.
- In views, CV links use `rails_blob_path(candidate.cv, disposition: 'attachment')`.

### JavaScript: Importmap + Turbo (not Webpacker)
- Webpacker was removed in Rails 7. This app now uses `importmap-rails` + `turbo-rails`.
- Delete/sign-out actions use `button_to` with `method: :delete` (Turbo requires a form, not a link, for non-GET requests).
- No Node.js or npm needed.

### Rails version
- Upgraded from Rails 5.2 → 8.1 (Ruby 3.4.8).
- `config.load_defaults 8.1` is set in `config/application.rb`.

## Auth
Devise with `:trackable` module. The tracking columns (`sign_in_count`, `current_sign_in_at`, etc.) exist in the `users` table.

## Team-based access
Candidates are scoped by `team` column. Users with team `'Admin'` see all candidates; others see only candidates in their team. Logic is in `Candidate.team_picker(current_user)`.
