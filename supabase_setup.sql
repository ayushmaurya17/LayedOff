-- ============================================================
-- LAYEDOFF — Supabase Database Setup
-- Run this entire file in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. PROFILES TABLE
create table if not exists profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  first_name text not null default '',
  last_name text default '',
  role text default '',
  yoe text default '',
  email text,
  created_at timestamptz default now()
);

-- Auto-create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, first_name, last_name, role, yoe, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'first_name', ''),
    coalesce(new.raw_user_meta_data->>'last_name', ''),
    coalesce(new.raw_user_meta_data->>'role', ''),
    coalesce(new.raw_user_meta_data->>'yoe', ''),
    new.email
  )
  on conflict (id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. POSTS TABLE
create table if not exists posts (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  content text not null,
  tag text default 'general',
  likes integer default 0,
  created_at timestamptz default now()
);

-- Like increment function (prevents client-side manipulation)
create or replace function increment_likes(post_id uuid, delta integer)
returns void as $$
begin
  update posts set likes = greatest(0, likes + delta) where id = post_id;
end;
$$ language plpgsql security definer;

-- 3. FEATURE REQUESTS TABLE
create table if not exists feature_requests (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete set null,
  user_email text,
  title text not null,
  description text default '',
  category text default 'Other',
  votes integer default 1,
  status text default 'pending',
  created_at timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS) — Important for security!
-- ============================================================

-- Profiles
alter table profiles enable row level security;
create policy "Public profiles are readable by everyone"
  on profiles for select using (true);
create policy "Users can update own profile"
  on profiles for update using (auth.uid() = id);

-- Posts
alter table posts enable row level security;
create policy "Posts are readable by everyone"
  on posts for select using (true);
create policy "Authenticated users can create posts"
  on posts for insert with check (auth.role() = 'authenticated');
create policy "Users can delete own posts"
  on posts for delete using (auth.uid() = user_id);

-- Feature Requests
alter table feature_requests enable row level security;
create policy "Feature requests readable by everyone"
  on feature_requests for select using (true);
create policy "Anyone can submit a feature request"
  on feature_requests for insert with check (true);
