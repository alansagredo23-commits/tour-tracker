-- ════════════════════════════════════════════════════════
-- NEXUS SALES OS · Unlimited VC — Supabase Schema
-- Run in: Supabase Dashboard → SQL Editor → New query
-- ════════════════════════════════════════════════════════

-- USERS
create table if not exists users (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz default now(),
  name         text not null,
  pin          text not null unique,
  avatar       text default '⚡',
  comm_rate    numeric default 4,
  close_target numeric default 70
);

-- CLIENTS
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

-- RLS
alter table users   enable row level security;
alter table clients enable row level security;

drop policy if exists "anon_users"   on users;
drop policy if exists "anon_clients" on clients;

create policy "anon_users"   on users   for all using (true) with check (true);
create policy "anon_clients" on clients for all using (true) with check (true);

-- Indexes
create index if not exists idx_clients_user_id on clients(user_id);
create index if not exists idx_clients_status  on clients(status);
create index if not exists idx_clients_date    on clients(date);
create index if not exists idx_users_pin       on users(pin);
