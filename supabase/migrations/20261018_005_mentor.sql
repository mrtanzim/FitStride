-- Mentor messages history
create table if not exists public.mentor_messages (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  role text not null check (role in ('user', 'mentor')),
  content text not null,
  card_json jsonb,
  created_at timestamptz default now()
);
alter table public.mentor_messages enable row level security;
create policy "Users manage own mentor_messages" on public.mentor_messages
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Usage counters for rate limiting
create table if not exists public.usage_counters (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  day date not null default current_date,
  mentor_messages int default 0,
  unique(user_id, day)
);
alter table public.usage_counters enable row level security;
create policy "Users view own usage" on public.usage_counters
  for select using (auth.uid() = user_id);
-- Insert/update done via service role in edge function only
