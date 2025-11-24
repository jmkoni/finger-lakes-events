# Repository Guidelines

## Project Structure & Module Organization
This is a Rails 7 app. Core domain code lives in `app/` (`app/models`, `app/controllers`, `app/views`, plus `app/javascript` for Stimulus/ESBuild assets). Shared utilities belong in `lib/`. Configuration stays in `config/` (routes, initializers, credentials) and database schema lives in `db/` (migrations, seeds). Tests and fixtures reside in `test/`, while static files go under `public/`. Keep docs and operational notes at the repo root (e.g., this guide, `README.md`).

## Build, Test, and Development Commands
- `bundle install && yarn install` — install Ruby gems and JS packages defined in `Gemfile` and `package.json`.
- `rails db:setup` — creates databases, runs migrations, seeds starter data.
- `rails s` — boots Puma using `config/puma.rb`; use for local feature work.
- `rails c` — open a console for quick model checks or ad‑hoc data fixes.
- `rails test` / `rails test:system` — run unit/integration suites and browser-driven system specs.
- `bundle exec standardrb --fix` — format Ruby code; run before commits to avoid style churn.

## Coding Style & Naming Conventions
Ruby files use two-space indentation and StandardRB defaults (no extra `;`, no parentheses unless needed). Classes/modules follow `CamelCase`, methods and variables use `snake_case`, and database columns favor descriptive names such as `starts_at`. Prefer service objects or POROs in `app/services` (create if missing) when controller logic grows beyond a few lines. Keep views slim by pushing presentation helpers into `app/helpers`.

## Testing Guidelines
Write Minitest cases beside the code they verify (e.g., `app/models/user.rb` -> `test/models/user_test.rb`). Name test methods with intent (`test_creates_event_slug`). For UI flows, add system specs under `test/system/` and tag slow paths with `:selenium` only when necessary. Aim to cover new branches or callbacks; if coverage is impractical, document reasoning in the PR.

## Commit & Pull Request Guidelines
Git history shows short, lowercase, imperative subjects (`fix linting issue`, `lint`). Follow that style and keep commits scoped to a single concern (logic change, migration, styling). PRs should summarize intent, list setup steps (e.g., `rails db:migrate`), link related issues, and include screenshots or console output for UI/API changes. Mention any skipped tests or TODOs so reviewers can assess risk quickly.
