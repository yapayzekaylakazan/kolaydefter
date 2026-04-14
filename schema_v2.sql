-- KolayDefter v2 - Ek tablolar

-- Fatura takibi
create table faturalar (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  ad text not null,
  tutar numeric(12,2) not null,
  son_odeme_gun int not null check (son_odeme_gun between 1 and 31),
  kategori text default 'Fatura',
  odendi boolean default false,
  odendi_tarih date,
  renk text default '#378ADD',
  aktif boolean default true,
  created_at timestamptz default now()
);

-- Birikim hedefleri
create table hedefler (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  ad text not null,
  hedef_tutar numeric(12,2) not null,
  mevcut_tutar numeric(12,2) default 0,
  bitis_tarihi date,
  renk text default '#27500A',
  created_at timestamptz default now()
);

-- Döviz & Altın portföy
create table portfolyo (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  tip text not null, -- USD, EUR, ALTIN, BTC vs
  miktar numeric(16,4) not null,
  alis_fiyati numeric(12,2),
  alis_tarihi date,
  aciklama text default '',
  created_at timestamptz default now()
);

-- RLS
alter table faturalar enable row level security;
alter table hedefler enable row level security;
alter table portfolyo enable row level security;

create policy "users_own_faturalar" on faturalar for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users_own_hedefler" on hedefler for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users_own_portfolyo" on portfolyo for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
