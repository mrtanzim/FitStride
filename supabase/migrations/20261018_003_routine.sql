create table if not exists public.routine_days (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  weekday int not null check (weekday between 0 and 6),
  title text not null,
  muscle_groups text[] default '{}',
  is_rest bool default false,
  created_at timestamptz default now()
);
alter table public.routine_days enable row level security;
create policy "Users manage own routine_days" on public.routine_days for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create table if not exists public.routine_exercises (
  id uuid default gen_random_uuid() primary key,
  routine_day_id uuid references public.routine_days(id) on delete cascade not null,
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  sets int not null default 3,
  reps text not null default '10',
  last_weight_kg numeric(6,2) default 0,
  position int not null default 0,
  created_at timestamptz default now()
);
alter table public.routine_exercises enable row level security;
create policy "Users manage own routine_exercises" on public.routine_exercises for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
