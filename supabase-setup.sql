-- Run this in Supabase SQL Editor.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  is_admin boolean not null default false
);

create table if not exists public.videos (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  category text,
  thumbnail_url text,
  storage_path text not null,
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by uuid references auth.users(id)
);

alter table public.profiles enable row level security;
alter table public.videos enable row level security;

-- Create a profile automatically whenever a user signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id) values (new.id) on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

-- Public visitors can only read approved video metadata.
create policy "Anyone can read approved videos" on public.videos
for select using (status = 'approved');

-- Create a private Storage bucket named videos in Storage settings.
-- The service-role API routes perform uploads and review operations server-side.
-- Do not expose SUPABASE_SERVICE_ROLE_KEY in any NEXT_PUBLIC variable.

-- After creating your own account, promote it to admin by running:
-- update public.profiles
-- set is_admin = true
-- where id = (select id from auth.users where email = 'YOUR_EMAIL_HERE');
