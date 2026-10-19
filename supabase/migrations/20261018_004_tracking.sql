-- Water logs
create table if not exists public.water_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  amount_ml int not null,
  logged_at timestamptz default now()
);
alter table public.water_logs enable row level security;
create policy "Users manage own water_logs" on public.water_logs for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Food logs
create table if not exists public.food_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  label text not null,
  protein_g numeric(6,1) default 0,
  calories int default 0,
  cost_bdt int default 0,
  logged_at timestamptz default now()
);
alter table public.food_logs enable row level security;
create policy "Users manage own food_logs" on public.food_logs for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Weight logs
create table if not exists public.weight_logs (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  weight_kg numeric(5,1) not null,
  logged_at timestamptz default now()
);
alter table public.weight_logs enable row level security;
create policy "Users manage own weight_logs" on public.weight_logs for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
