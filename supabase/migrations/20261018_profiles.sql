-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Profiles table
create table if not exists public.profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  display_name text,
  age integer check (age between 14 and 99),
  height_cm numeric(5,1),
  weight_kg numeric(5,1),
  goal text check (goal in ('hypertrophy', 'deficit', 'endurance')),
  experience_level text check (experience_level in ('novice', 'intermediate', 'advanced', 'proficient', 'elite')),
  training_place text check (training_place in ('gym', 'home')),
  daily_budget_bdt integer default 650,
  foods_eaten text[] default '{}',
  foods_avoided text[] default '{}',
  water_target_ml integer default 3200,
  protein_target_g integer default 120,
  onboarded boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can insert own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, split_part(new.email, '@', 1));
  return new;
end;
$$ language plpgsql security definer;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
