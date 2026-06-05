# 📊 Tour Tracker · Unlimited VC

Sales performance dashboard for timeshare/vacation club sales teams. Tracks tours, commissions, close rates, and payroll cycles.

---

## 🚀 Stack

| Layer    | Tech                          |
|----------|-------------------------------|
| Frontend | Vanilla HTML + React (via CDN) + Babel |
| Backend  | Supabase (Postgres + REST API) |
| Hosting  | Vercel (static deploy)        |

---

## 🗃️ Supabase Schema

Run this SQL in your Supabase project's **SQL Editor**:

```sql
-- USERS table
create table if not exists users (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz default now(),
  name        text not null,
  pin         text not null unique,
  avatar      text default '💼',
  comm_rate   numeric default 4,
  close_target numeric default 70
);

-- CLIENTS table
create table if not exists clients (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz default now(),
  user_id      uuid references users(id) on delete cascade,
  name         text not null,
  date         date,
  tier         text default 'Silver',
  value        numeric default 0,
  status       text default 'Tour',
  sale_type    text default 'Liner',
  payment_type text default 'normal',
  notes        text default ''
);

-- Enable Row Level Security (optional but recommended)
alter table users   enable row level security;
alter table clients enable row level security;

-- Allow anon reads/writes (app uses anon key + PIN auth)
create policy "anon full access users"   on users   for all using (true) with check (true);
create policy "anon full access clients" on clients for all using (true) with check (true);
```

---

## 🔑 Environment / Config

All config lives directly in `index.html` (no build step needed):

```js
var SUPA_URL = "https://your-project.supabase.co";
var SUPA_KEY = "your-anon-key";
```

Replace those two values with your own from **Supabase → Settings → API**.

---

## 📦 Deploy to Vercel

### Option A — Vercel CLI
```bash
npm i -g vercel
vercel --prod
```

### Option B — GitHub Integration (recommended)
1. Push this repo to GitHub
2. Go to [vercel.com](https://vercel.com) → **New Project**
3. Import your GitHub repo
4. Framework Preset: **Other**
5. Root Directory: `/` (leave default)
6. Click **Deploy** — done in ~30 seconds

---

## ✨ Features

- **PIN-based auth** — no email/password, just a 4-digit PIN per rep
- **Client management** — add tours, update status, add notes
- **Commission calculator** — auto-calculates gross, cancellation fund, net payout
- **Payroll cycles** — Wed→Tue cycle, pay on second Thursday after close
- **Scoreboard** — live team rankings by volume or close rate
- **Period filtering** — Today / This Week / This Month / Last Month / This Year / All Time
- **Role-based commissions:**
  - Liner: 4%
  - Front to Mid: 5%
  - Closer: 6% normal / 8% DP50
  - Front to Back: 8% normal / 10% DP50 / 12% Cash100

---

## 📁 File Structure

```
tour-tracker/
├── index.html      ← entire app (HTML + React + logic)
├── vercel.json     ← Vercel deploy config
├── .gitignore
└── README.md
```

No `package.json`, no build step, no bundler. All dependencies load via CDN at runtime.

---

## 🔄 Updating the App

1. Edit `index.html`
2. `git add . && git commit -m "your message" && git push`
3. Vercel auto-deploys in ~20 seconds

The app uses `localStorage` to cache the compiled JS. Update `CACHE_KEY` in `index.html` (e.g. `uvc_v68`) whenever you push a new version to force clients to recompile.

---

## 🛡️ Security Notes

- The Supabase **anon key** is public by design — it's safe to expose in client code
- Row Level Security policies above allow full anon access (suitable for internal team tools)
- For stricter security, implement Supabase Auth and update RLS policies accordingly

---

Made with ❤️ for Unlimited VC sales teams.
