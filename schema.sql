-- ============================================================
-- Tour Tracker · Unlimited VC — Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- ── USERS ────────────────────────────────────────────────────
create table if not exists users (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz default now(),
  name         text not null,
  pin          text not null unique,
  avatar       text default '💼',
  comm_rate    numeric default 4,
  close_target numeric default 70
);

-- ── CLIENTS ──────────────────────────────────────────────────
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

-- ── ROW LEVEL SECURITY ───────────────────────────────────────
alter table users   enable row level security;
alter table clients enable row level security;

-- Allow anon key full access (internal team tool)
-- For production with real auth, replace these with user-scoped policies

drop policy if exists "anon full access users"   on users;
drop policy if exists "anon full access clients" on clients;

create policy "anon full access users"
  on users for all
  using (true)
  with check (true);

create policy "anon full access clients"
  on clients for all
  using (true)
  with check (true);

-- ── INDEXES (performance) ─────────────────────────────────────
create index if not exists clients_user_id_idx  on clients(user_id);
create index if not exists clients_status_idx   on clients(status);
create index if not exists clients_date_idx     on clients(date);
create index if not exists users_pin_idx        on users(pin);

-- ── DONE ──────────────────────────────────────────────────────
-- You should now see 'users' and 'clients' tables in your
-- Supabase Table Editor. Go back to the app and start adding reps!
