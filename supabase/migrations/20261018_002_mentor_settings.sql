create table if not exists public.mentor_settings (
  user_id uuid references auth.users(id) on delete cascade primary key,
  personality text not null default 'strict' check (personality in ('friendly','strict','savage')),
  locked_until timestamptz,
  savage_opt_in bool default false,
  updated_at timestamptz default now()
);
alter table public.mentor_settings enable row level security;
create policy "Users can view own mentor settings" on public.mentor_settings for select using (auth.uid() = user_id);
create policy "Users can insert own mentor settings" on public.mentor_settings for insert with check (auth.uid() = user_id);
-- Update is done via Edge Function only (service role), not directly by client
