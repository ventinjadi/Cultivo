-- Cultivo: execute no SQL Editor de um projeto Supabase próprio.
-- 1. Crie sua conta em Authentication > Users (sem cadastro público).
-- 2. Desative "Allow new users to sign up" em Authentication > Providers > Email.
-- 3. Execute este SQL. Em seguida, substitua o UUID do INSERT final pelo UID da sua conta.

create table if not exists public.cultivo_allowed_users (
  user_id uuid primary key references auth.users(id) on delete cascade
);

alter table public.cultivo_allowed_users enable row level security;
revoke all on public.cultivo_allowed_users from anon;
grant select on public.cultivo_allowed_users to authenticated;

drop policy if exists "cultivo_allowed_self" on public.cultivo_allowed_users;
create policy "cultivo_allowed_self"
on public.cultivo_allowed_users for select to authenticated
using (user_id = (select auth.uid()));

create table if not exists public.cultivo_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.cultivo_data enable row level security;
revoke all on public.cultivo_data from anon;
grant select, insert, update on public.cultivo_data to authenticated;

drop policy if exists "cultivo_select_owner" on public.cultivo_data;
create policy "cultivo_select_owner"
on public.cultivo_data for select to authenticated
using (
  user_id = (select auth.uid())
  and exists (select 1 from public.cultivo_allowed_users a
              where a.user_id = (select auth.uid()))
);

drop policy if exists "cultivo_insert_owner" on public.cultivo_data;
create policy "cultivo_insert_owner"
on public.cultivo_data for insert to authenticated
with check (
  user_id = (select auth.uid())
  and exists (select 1 from public.cultivo_allowed_users a
              where a.user_id = (select auth.uid()))
);

drop policy if exists "cultivo_update_owner" on public.cultivo_data;
create policy "cultivo_update_owner"
on public.cultivo_data for update to authenticated
using (
  user_id = (select auth.uid())
  and exists (select 1 from public.cultivo_allowed_users a
              where a.user_id = (select auth.uid()))
)
with check (
  user_id = (select auth.uid())
  and exists (select 1 from public.cultivo_allowed_users a
              where a.user_id = (select auth.uid()))
);

-- Após executar, autorize EXCLUSIVAMENTE seu usuário.
-- Exemplo (remova os comentários e substitua pelo seu UUID em Authentication > Users):
-- insert into public.cultivo_allowed_users(user_id)
-- values ('00000000-0000-0000-0000-000000000000')
-- on conflict do nothing;

-- Conferências: confirme que RLS está ativo e que só seu UID está autorizado.
-- select tablename, rowsecurity from pg_tables where schemaname='public' and tablename like 'cultivo_%';
-- select user_id from public.cultivo_allowed_users;
