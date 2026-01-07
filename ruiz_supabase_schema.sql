-- Ruiz Supabase Schema (Postgres)
-- Run this in Supabase SQL Editor (or via migration).
-- NOTE: This creates tables in the public schema. Supabase Auth lives in auth.*

begin;

-- Extensions
create extension if not exists pgcrypto;

-- Enums
do $$ begin
  create type public.watch_type as enum ('smartwatch','classic');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.order_status as enum ('pending','confirmed','packed','shipped','delivered','cancelled','returned','refunded');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.shipment_status as enum ('not_assigned','in_transit','delivered','exception','returned');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.discount_type as enum ('percent','fixed');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.review_status as enum ('pending','approved','rejected');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.review_media_type as enum ('image','video');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.referral_status as enum ('pending','qualified','rewarded','void');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.shipping_rate_type as enum ('flat','weight');
exception when duplicate_object then null; end $$;

-- Roles & Profiles (Auth users are in auth.users)
create table if not exists public.roles (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  created_at timestamptz not null default now()
);

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text,
  full_name text,
  phone text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.user_roles (
  user_id uuid references auth.users(id) on delete cascade,
  role_id uuid references public.roles(id) on delete cascade,
  primary key (user_id, role_id)
);

-- Brands & Catalog
create table if not exists public.brands (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  brand_id uuid not null references public.brands(id) on delete restrict,
  watch_type public.watch_type not null,
  model text not null,
  slug text unique not null,
  title text not null,
  short_description text,
  highlights text[],
  default_warranty_months int not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.product_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  sku text unique not null,
  title text not null,
  color text,
  strap text,
  price_bdt numeric(12,2) not null,
  compare_at_bdt numeric(12,2),
  stock_qty int not null default 0,
  warranty_months int not null default 0,
  warranty_note text,
  specs jsonb not null default '{}'::jsonb,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_variants_product on public.product_variants(product_id);
create index if not exists idx_variants_price on public.product_variants(price_bdt);

create table if not exists public.product_images (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  url text not null,
  alt text,
  sort_order int not null default 0,
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

-- Collections
create table if not exists public.collections (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.product_collections (
  product_id uuid references public.products(id) on delete cascade,
  collection_id uuid references public.collections(id) on delete cascade,
  primary key (product_id, collection_id)
);

-- Coupons & Bundles
create table if not exists public.coupons (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  discount_type public.discount_type not null,
  amount numeric(12,2) not null,
  min_subtotal numeric(12,2),
  max_uses int,
  max_uses_per_user int,
  starts_at timestamptz,
  ends_at timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.bundles (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  description text,
  discount_type public.discount_type,
  amount numeric(12,2),
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.bundle_items (
  bundle_id uuid references public.bundles(id) on delete cascade,
  variant_id uuid references public.product_variants(id) on delete cascade,
  quantity int not null default 1,
  primary key (bundle_id, variant_id)
);

-- Addresses (for account users)
create table if not exists public.addresses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  label text,
  full_name text,
  phone text,
  address_line text not null,
  division text,
  district text,
  upazila text,
  thana text,
  area text,
  zip text,
  is_default boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_addresses_user on public.addresses(user_id);

-- Orders
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_number bigint generated always as identity unique,
  customer_id uuid references auth.users(id) on delete set null,
  customer_name text not null,
  customer_phone text not null,
  customer_email text,
  status public.order_status not null default 'pending',
  payment_method text not null default 'cod',
  coupon_id uuid references public.coupons(id) on delete set null,
  subtotal numeric(12,2) not null default 0,
  discount_total numeric(12,2) not null default 0,
  shipping_fee numeric(12,2) not null default 0,
  total numeric(12,2) not null default 0,
  shipping_address jsonb not null default '{}'::jsonb,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_orders_customer on public.orders(customer_id);
create index if not exists idx_orders_status on public.orders(status);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  variant_id uuid references public.product_variants(id) on delete set null,
  sku text,
  title text not null,
  unit_price numeric(12,2) not null,
  quantity int not null default 1,
  line_total numeric(12,2) not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_order_items_order on public.order_items(order_id);

create table if not exists public.order_status_history (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  status public.order_status not null,
  note text,
  created_at timestamptz not null default now()
);

-- Shipments / Tracking
create table if not exists public.shipments (
  id uuid primary key default gen_random_uuid(),
  order_id uuid unique not null references public.orders(id) on delete cascade,
  courier_name text,
  tracking_number text,
  tracking_url text,
  status public.shipment_status not null default 'not_assigned',
  last_event text,
  shipped_at timestamptz,
  delivered_at timestamptz,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

-- Returns
create table if not exists public.returns (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  status text not null default 'requested',
  reason text,
  created_at timestamptz not null default now()
);

-- Wishlist
create table if not exists public.wishlist_items (
  user_id uuid references auth.users(id) on delete cascade,
  product_id uuid references public.products(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, product_id)
);

-- Reviews (Phase 2, can enable now)
create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete set null,
  product_id uuid not null references public.products(id) on delete cascade,
  rating int not null check (rating between 1 and 5),
  title text,
  body text,
  is_verified boolean not null default false,
  status public.review_status not null default 'pending',
  created_at timestamptz not null default now()
);

create index if not exists idx_reviews_product on public.reviews(product_id);

create table if not exists public.review_media (
  id uuid primary key default gen_random_uuid(),
  review_id uuid not null references public.reviews(id) on delete cascade,
  media_type public.review_media_type not null,
  url text not null,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- Loyalty & Referral (Phase 2, can enable now)
create table if not exists public.loyalty_accounts (
  user_id uuid primary key references auth.users(id) on delete cascade,
  points_balance int not null default 0,
  updated_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create table if not exists public.loyalty_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  points_delta int not null,
  reason text,
  order_id uuid references public.orders(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.referral_codes (
  user_id uuid primary key references auth.users(id) on delete cascade,
  code text unique not null,
  created_at timestamptz not null default now()
);

create table if not exists public.referrals (
  id uuid primary key default gen_random_uuid(),
  referrer_user_id uuid not null references auth.users(id) on delete cascade,
  referee_user_id uuid references auth.users(id) on delete set null,
  referee_order_id uuid references public.orders(id) on delete set null,
  status public.referral_status not null default 'pending',
  created_at timestamptz not null default now()
);

-- Currency & Shipping Zones (Phase 2)
create table if not exists public.currencies (
  code text primary key,
  symbol text,
  is_active boolean not null default true
);

create table if not exists public.exchange_rates (
  id uuid primary key default gen_random_uuid(),
  base_code text not null references public.currencies(code) on delete cascade,
  quote_code text not null references public.currencies(code) on delete cascade,
  rate numeric(18,8) not null,
  effective_at timestamptz not null default now(),
  source text
);

create table if not exists public.shipping_zones (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  country_code text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.shipping_rates (
  id uuid primary key default gen_random_uuid(),
  zone_id uuid not null references public.shipping_zones(id) on delete cascade,
  rate_type public.shipping_rate_type not null default 'flat',
  flat_fee numeric(12,2),
  min_subtotal numeric(12,2),
  max_subtotal numeric(12,2),
  estimated_days_min int,
  estimated_days_max int,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

-- Site Settings & CMS blocks
create table if not exists public.site_settings (
  key text primary key,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.pages (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  title text not null,
  content jsonb not null default '{}'::jsonb,
  is_published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.homepage_sections (
  id uuid primary key default gen_random_uuid(),
  section_key text not null,
  title text,
  sort_order int not null default 0,
  is_enabled boolean not null default true,
  config jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

commit;


-- (Optional but recommended) case-insensitive email type
create extension if not exists citext;

create table if not exists public.coupon_entitlements (
  id uuid primary key default gen_random_uuid(),
  coupon_id uuid not null references public.coupons(id) on delete cascade,
  email citext not null,
  created_at timestamptz not null default now(),
  unique (coupon_id, email)
);

create index if not exists idx_coupon_entitlements_coupon_id
  on public.coupon_entitlements (coupon_id);

create index if not exists idx_coupon_entitlements_email
  on public.coupon_entitlements (email);
