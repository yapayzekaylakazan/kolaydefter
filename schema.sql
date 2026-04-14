-- KolayDefter veritabanı şeması

create table txns (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  tip text not null check (tip in ('gelir','gider')),
  tutar numeric(12,2) not null check (tutar > 0),
  tarih date not null,
  kategori text not null,
  aciklama text default '',
  tekrar_key text default null,
  created_at timestamptz default now()
);

create table butce (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  kat text not null,
  limit_tutar numeric(12,2) not null check (limit_tutar > 0),
  unique(user_id, kat)
);

create table tekrar (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  tip text not null check (tip in ('gelir','gider')),
  tutar numeric(12,2) not null check (tutar > 0),
  kategori text not null,
  aciklama text default '',
  gun int not null check (gun between 1 and 31),
  aktif boolean default true,
  created_at timestamptz default now()
);

create table toptanci (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  ad text not null,
  kisi text default '',
  tel text default '',
  borc numeric(12,2) default 0,
  kategori text default '',
  created_at timestamptz default now()
);

create table toptanci_hareketler (
  id bigint generated always as identity primary key,
  toptanci_id bigint references toptanci(id) on delete cascade not null,
  user_id uuid references auth.users(id) on delete cascade not null,
  tarih date not null,
  tutar numeric(12,2) not null,
  tip text not null check (tip in ('borc','odeme')),
  aciklama text default '',
  created_at timestamptz default now()
);

create table kartlar (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  ad text not null,
  limit_tutar numeric(12,2) not null,
  borc numeric(12,2) default 0,
  ekstre_gun int default 1,
  son_odeme_gun int default 20,
  created_at timestamptz default now()
);

create table kart_harcamalar (
  id bigint generated always as identity primary key,
  kart_id bigint references kartlar(id) on delete cascade not null,
  user_id uuid references auth.users(id) on delete cascade not null,
  tarih date not null,
  tutar numeric(12,2) not null,
  aciklama text default '',
  created_at timestamptz default now()
);

-- RLS aktif et
alter table txns enable row level security;
alter table butce enable row level security;
alter table tekrar enable row level security;
alter table toptanci enable row level security;
alter table toptanci_hareketler enable row level security;
alter table kartlar enable row level security;
alter table kart_harcamalar enable row level security;

-- RLS politikaları
create policy "users_own_txns" on txns for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users_own_butce" on butce for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users_own_tekrar" on tekrar for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users_own_toptanci" on toptanci for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users_own_toptanci_hareketler" on toptanci_hareketler for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users_own_kartlar" on kartlar for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users_own_kart_harcamalar" on kart_harcamalar for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Index'ler (performans)
create index txns_user_tarih on txns(user_id, tarih desc);
create index toptanci_user on toptanci(user_id);
create index kartlar_user on kartlar(user_id);
