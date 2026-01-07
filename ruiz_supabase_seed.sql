-- Ruiz Supabase Seed Data
begin;
insert into public.roles (name) values
  ('super_admin'),
  ('catalog_manager'),
  ('order_manager'),
  ('content_manager'),
  ('customer')
on conflict (name) do nothing;
-- Collections
insert into public.collections (name, slug) values
  ('Accessories','accessories'),
  ('Classic Watches','classic-watches'),
  ('Gift Picks','gift-picks'),
  ('Premium','premium'),
  ('Sale','sale'),
  ('Smart Watches','smart-watches'),
  ('Under ৳X','under-takax'),
  ('Women','women')
on conflict (slug) do nothing;

-- Currencies
insert into public.currencies (code, symbol) values
  ('BDT','৳'),
  ('USD','$')
on conflict (code) do nothing;

-- Exchange rate seed (manual placeholder)
insert into public.exchange_rates (base_code, quote_code, rate, source)
values ('BDT','USD', 0.0091, 'manual_seed')
on conflict do nothing;

-- Shipping zones & rates
insert into public.shipping_zones (name, country_code) values
  ('Bangladesh','BD'),
  ('International','INT')
on conflict do nothing;

-- Simple flat rates (you can edit later)
insert into public.shipping_rates (zone_id, rate_type, flat_fee, estimated_days_min, estimated_days_max)
select id, 'flat', 60, 0, 1 from public.shipping_zones where country_code='BD'
on conflict do nothing;

insert into public.shipping_rates (zone_id, rate_type, flat_fee, estimated_days_min, estimated_days_max)
select id, 'flat', 1200, 5, 12 from public.shipping_zones where country_code='INT'
on conflict do nothing;

-- Site settings
insert into public.site_settings (key, value) values ('brand_name', '"Ruiz"'::jsonb)
on conflict (key) do update set value=excluded.value, updated_at=now();
insert into public.site_settings (key, value) values ('tagline', '"Ruiz — Style in every second."'::jsonb)
on conflict (key) do update set value=excluded.value, updated_at=now();
insert into public.site_settings (key, value) values ('support_phone', '"01571339897"'::jsonb)
on conflict (key) do update set value=excluded.value, updated_at=now();
insert into public.site_settings (key, value) values ('whatsapp', '"01571339897"'::jsonb)
on conflict (key) do update set value=excluded.value, updated_at=now();
insert into public.site_settings (key, value) values ('language', '"en"'::jsonb)
on conflict (key) do update set value=excluded.value, updated_at=now();
insert into public.site_settings (key, value) values ('default_currency', '"BDT"'::jsonb)
on conflict (key) do update set value=excluded.value, updated_at=now();
insert into public.site_settings (key, value) values ('theme', '{"mode": "light", "style": "minimal_white"}'::jsonb)
on conflict (key) do update set value=excluded.value, updated_at=now();
insert into public.site_settings (key, value) values ('delivery_targets', '{"dhaka_hours": 12, "outside_days": 1}'::jsonb)
on conflict (key) do update set value=excluded.value, updated_at=now();

-- Brands
insert into public.brands (name, slug) values
  ('Amazfit','amazfit'),
  ('Apple','apple'),
  ('CMF','cmf'),
  ('Casio','casio'),
  ('Citizen','citizen'),
  ('Daniel Wellington','daniel-wellington'),
  ('Fitbit','fitbit'),
  ('Fossil','fossil'),
  ('Garmin','garmin'),
  ('Huawei','huawei'),
  ('Invicta','invicta'),
  ('MVMT','mvmt'),
  ('Noise','noise'),
  ('OnePlus','oneplus'),
  ('Orient','orient'),
  ('Samsung','samsung'),
  ('Seiko','seiko'),
  ('Skagen','skagen'),
  ('Timex','timex'),
  ('Tissot','tissot'),
  ('Titan','titan'),
  ('Xiaomi','xiaomi'),
  ('realme','realme')
on conflict (slug) do nothing;

-- Products
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='casio'), 'classic', 'A168', 'casio-a168', 'Casio A168', 'Retro digital | Lightweight | Everyday wear', array['Retro digital','Lightweight','Everyday wear','Iconic look'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='casio'), 'classic', 'Edifice EFR-556', 'casio-edifice-efr-556', 'Casio Edifice EFR-556', 'Chronograph style | Premium finish | Sporty look', array['Chronograph style','Premium finish','Sporty look','Solid build'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='casio'), 'classic', 'Edifice EFV-100', 'casio-edifice-efv-100', 'Casio Edifice EFV-100', 'Premium finish | Solid build | Sporty classic', array['Premium finish','Solid build','Sporty classic','Everyday durability'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='casio'), 'classic', 'Enticer MTP-1374', 'casio-enticer-mtp-1374', 'Casio Enticer MTP-1374', 'Multi-dial look | Classic styling | Daily wear', array['Multi-dial look','Classic styling','Daily wear','Comfort fit'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='casio'), 'classic', 'MTP-VD01', 'casio-mtp-vd01', 'Casio MTP-VD01', 'Everyday classic | Durable build | Clear dial', array['Everyday classic','Durable build','Clear dial','Comfort strap options'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='casio'), 'classic', 'MTP-VT01', 'casio-mtp-vt01', 'Casio MTP-VT01', 'Minimal dial | Lightweight | Everyday wear', array['Minimal dial','Lightweight','Everyday wear','Comfort fit'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='citizen'), 'classic', 'Eco-Drive Chandler', 'citizen-eco-drive-chandler', 'Citizen Eco-Drive Chandler', 'Eco-Drive | Durable build | Everyday wear', array['Eco-Drive','Durable build','Everyday wear','Premium feel'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='citizen'), 'classic', 'Eco-Drive Corso', 'citizen-eco-drive-corso', 'Citizen Eco-Drive Corso', 'Eco-Drive | Dress style | Premium finish', array['Eco-Drive','Dress style','Premium finish','Gift-worthy'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='daniel-wellington'), 'classic', 'Classic Sheffield', 'daniel-wellington-classic-sheffield', 'Daniel Wellington Classic Sheffield', 'Minimal design | Formal-ready | Slim profile', array['Minimal design','Formal-ready','Slim profile','Gift-worthy'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='fossil'), 'classic', 'Grant Chronograph', 'fossil-grant-chronograph', 'Fossil Grant Chronograph', 'Chronograph look | Premium feel | Formal-ready', array['Chronograph look','Premium feel','Formal-ready','Gift-worthy'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='fossil'), 'classic', 'Neutra', 'fossil-neutra', 'Fossil Neutra', 'Minimal style | Premium feel | Everyday wear', array['Minimal style','Premium feel','Everyday wear','Gift-worthy'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='invicta'), 'classic', 'Pro Diver', 'invicta-pro-diver', 'Invicta Pro Diver', 'Dive style | Bold look | Everyday wear', array['Dive style','Bold look','Everyday wear','Solid build'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='mvmt'), 'classic', 'Classic', 'mvmt-classic', 'MVMT Classic', 'Modern minimal | Everyday wear | Gift-worthy', array['Modern minimal','Everyday wear','Gift-worthy','Clean dial'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='orient'), 'classic', 'Bambino', 'orient-bambino', 'Orient Bambino', 'Classic dress watch | Automatic movement | Vintage vibe', array['Classic dress watch','Automatic movement','Vintage vibe','Formal-ready'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='seiko'), 'classic', '5 Sports (SRPD)', 'seiko-5-sports-srpd', 'Seiko 5 Sports (SRPD)', 'Automatic movement | Sporty look | Heritage design', array['Automatic movement','Sporty look','Heritage design','Everyday durability'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='skagen'), 'classic', 'Signatur', 'skagen-signatur', 'Skagen Signatur', 'Minimal Scandinavian | Slim profile | Formal-ready', array['Minimal Scandinavian','Slim profile','Formal-ready','Gift-worthy'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='timex'), 'classic', 'Expedition Scout', 'timex-expedition-scout', 'Timex Expedition Scout', 'Outdoor style | Durable build | Everyday wear', array['Outdoor style','Durable build','Everyday wear','Comfort strap'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='timex'), 'classic', 'Weekender 40mm', 'timex-weekender-40mm', 'Timex Weekender 40mm', 'Casual classic | Easy readability | Everyday wear', array['Casual classic','Easy readability','Everyday wear','Comfort strap'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='tissot'), 'classic', 'PRX Quartz', 'tissot-prx-quartz', 'Tissot PRX Quartz', 'Iconic design | Premium finish | Bracelet style', array['Iconic design','Premium finish','Bracelet style','Gift-worthy'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='titan'), 'classic', 'Neo', 'titan-neo', 'Titan Neo', 'Clean design | Everyday wear | Comfort fit', array['Clean design','Everyday wear','Comfort fit','Gift-worthy'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='amazfit'), 'smartwatch', 'Bip 3 Pro', 'amazfit-bip-3-pro', 'Amazfit Bip 3 Pro', 'GPS | Long battery life | Health tracking', array['GPS','Long battery life','Health tracking','50+ sports modes'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='amazfit'), 'smartwatch', 'Bip 5', 'amazfit-bip-5', 'Amazfit Bip 5', 'Large display | Bluetooth calling | Health tracking', array['Large display','Bluetooth calling','Health tracking','Long battery life'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='amazfit'), 'smartwatch', 'GTR Mini', 'amazfit-gtr-mini', 'Amazfit GTR Mini', 'AMOLED display | GPS | Health tracking', array['AMOLED display','GPS','Health tracking','Classic round design'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='amazfit'), 'smartwatch', 'GTS 4 Mini', 'amazfit-gts-4-mini', 'Amazfit GTS 4 Mini', 'AMOLED display | GPS | Health tracking', array['AMOLED display','GPS','Health tracking','Slim design'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='apple'), 'smartwatch', 'Watch SE (2nd Gen) 40mm', 'apple-watch-se-2nd-gen-40mm', 'Apple Watch SE (2nd Gen) 40mm', 'WatchOS | Fitness tracking | Notifications', array['WatchOS','Fitness tracking','Notifications','Apple ecosystem'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='apple'), 'smartwatch', 'Watch Series 8 45mm', 'apple-watch-series-8-45mm', 'Apple Watch Series 8 45mm', 'WatchOS | Advanced sensors | Notifications', array['WatchOS','Advanced sensors','Notifications','Premium build'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='cmf'), 'smartwatch', 'Watch Pro', 'cmf-watch-pro', 'CMF Watch Pro', 'AMOLED display | Bluetooth calling | Health tracking', array['AMOLED display','Bluetooth calling','Health tracking','Modern design'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='fitbit'), 'smartwatch', 'Versa 3', 'fitbit-versa-3', 'Fitbit Versa 3', 'Health tracking | GPS | Notifications', array['Health tracking','GPS','Notifications','App ecosystem'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='garmin'), 'smartwatch', 'Forerunner 55', 'garmin-forerunner-55', 'Garmin Forerunner 55', 'GPS running watch | Training metrics | Long battery', array['GPS running watch','Training metrics','Long battery','Sports tracking'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='huawei'), 'smartwatch', 'Band 8', 'huawei-band-8', 'Huawei Band 8', 'Slim & light | Health tracking | Long battery life', array['Slim & light','Health tracking','Long battery life','Multiple workout modes'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='huawei'), 'smartwatch', 'Watch Fit 2', 'huawei-watch-fit-2', 'Huawei Watch Fit 2', 'AMOLED display | Bluetooth calling | Fitness coaching', array['AMOLED display','Bluetooth calling','Fitness coaching','Health tracking'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='noise'), 'smartwatch', 'ColorFit Pro 4', 'noise-colorfit-pro-4', 'Noise ColorFit Pro 4', 'Large display | Fitness tracking | Notifications', array['Large display','Fitness tracking','Notifications','Multiple sports modes'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='oneplus'), 'smartwatch', 'Nord Watch', 'oneplus-nord-watch', 'OnePlus Nord Watch', 'Large display | Fitness tracking | Notifications', array['Large display','Fitness tracking','Notifications','Multiple sports modes'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='samsung'), 'smartwatch', 'Galaxy Watch4 40mm', 'samsung-galaxy-watch4-40mm', 'Samsung Galaxy Watch4 40mm', 'Wear OS | Health sensors | Apps support', array['Wear OS','Health sensors','Apps support','Premium build'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='samsung'), 'smartwatch', 'Galaxy Watch5 44mm', 'samsung-galaxy-watch5-44mm', 'Samsung Galaxy Watch5 44mm', 'Wear OS | Improved battery | Health sensors', array['Wear OS','Improved battery','Health sensors','Premium build'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='samsung'), 'smartwatch', 'Galaxy Watch6 40mm', 'samsung-galaxy-watch6-40mm', 'Samsung Galaxy Watch6 40mm', 'Wear OS | Advanced tracking | Premium display', array['Wear OS','Advanced tracking','Premium display','Apps support'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='xiaomi'), 'smartwatch', 'Mi Watch Lite 2', 'xiaomi-mi-watch-lite-2', 'Xiaomi Mi Watch Lite 2', 'GPS | AMOLED display | Health tracking', array['GPS','AMOLED display','Health tracking','Multiple sports modes'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='xiaomi'), 'smartwatch', 'Redmi Watch 3 Active', 'xiaomi-redmi-watch-3-active', 'Xiaomi Redmi Watch 3 Active', 'Bluetooth calling | Large display | Fitness tracking', array['Bluetooth calling','Large display','Fitness tracking','Multiple sports modes'], 6, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='xiaomi'), 'smartwatch', 'Redmi Watch 4', 'xiaomi-redmi-watch-4', 'Xiaomi Redmi Watch 4', 'AMOLED display | Bluetooth calling (model dependent) | Health tracking', array['AMOLED display','Bluetooth calling (model dependent)','Health tracking','Multi-sport modes'], 12, true)
on conflict (slug) do nothing;
insert into public.products (brand_id, watch_type, model, slug, title, short_description, highlights, default_warranty_months, is_active)
values ((select id from public.brands where slug='realme'), 'smartwatch', 'Watch 3 Pro', 'realme-watch-3-pro', 'realme Watch 3 Pro', 'Bluetooth calling | Fitness tracking | Large display', array['Bluetooth calling','Fitness tracking','Large display','Multiple sports modes'], 6, true)
on conflict (slug) do nothing;

-- Product variants (200)
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-4'), 'RUIZ-1001', 'Xiaomi Redmi Watch 4 (Black, Silicone Strap)', 'Black', 'Silicone Strap', 7090.00, 7444.00, 30, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-4'), 'RUIZ-1002', 'Xiaomi Redmi Watch 4 (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 7290.00, 8384.00, 8, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-4'), 'RUIZ-1003', 'Xiaomi Redmi Watch 4 (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 7290.00, 7654.00, 20, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-4'), 'RUIZ-1004', 'Xiaomi Redmi Watch 4 (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 7240.00, 7602.00, 45, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-4'), 'RUIZ-1005', 'Xiaomi Redmi Watch 4 (Green, Silicone Strap)', 'Green', 'Silicone Strap', 7290.00, 7654.00, 19, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-3-active'), 'RUIZ-1006', 'Xiaomi Redmi Watch 3 Active (Black, Silicone Strap)', 'Black', 'Silicone Strap', 3490.00, 4013.00, 12, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-3-active'), 'RUIZ-1007', 'Xiaomi Redmi Watch 3 Active (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 3690.00, 4244.00, 41, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-3-active'), 'RUIZ-1008', 'Xiaomi Redmi Watch 3 Active (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 3640.00, 4186.00, 8, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-3-active'), 'RUIZ-1009', 'Xiaomi Redmi Watch 3 Active (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 3840.00, 4224.00, 42, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-redmi-watch-3-active'), 'RUIZ-1010', 'Xiaomi Redmi Watch 3 Active (Green, Silicone Strap)', 'Green', 'Silicone Strap', 3640.00, 4186.00, 54, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-mi-watch-lite-2'), 'RUIZ-1011', 'Xiaomi Mi Watch Lite 2 (Black, Silicone Strap)', 'Black', 'Silicone Strap', 5090.00, 5854.00, 33, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-mi-watch-lite-2'), 'RUIZ-1012', 'Xiaomi Mi Watch Lite 2 (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 5340.00, 5607.00, 53, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-mi-watch-lite-2'), 'RUIZ-1013', 'Xiaomi Mi Watch Lite 2 (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 5140.00, 5911.00, 41, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-mi-watch-lite-2'), 'RUIZ-1014', 'Xiaomi Mi Watch Lite 2 (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 5340.00, 6141.00, 36, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='xiaomi-mi-watch-lite-2'), 'RUIZ-1015', 'Xiaomi Mi Watch Lite 2 (Green, Silicone Strap)', 'Green', 'Silicone Strap', 5240.00, 5764.00, 49, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-3-pro'), 'RUIZ-1016', 'Amazfit Bip 3 Pro (Black, Silicone Strap)', 'Black', 'Silicone Strap', 4890.00, 5624.00, 57, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-3-pro'), 'RUIZ-1017', 'Amazfit Bip 3 Pro (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 4990.00, 5240.00, 34, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-3-pro'), 'RUIZ-1018', 'Amazfit Bip 3 Pro (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 4840.00, 5324.00, 13, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-3-pro'), 'RUIZ-1019', 'Amazfit Bip 3 Pro (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 5090.00, 5344.00, 15, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-3-pro'), 'RUIZ-1020', 'Amazfit Bip 3 Pro (Green, Silicone Strap)', 'Green', 'Silicone Strap', 4990.00, 5738.00, 22, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-5'), 'RUIZ-1021', 'Amazfit Bip 5 (Black, Silicone Strap)', 'Black', 'Silicone Strap', 7140.00, 7497.00, 14, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-5'), 'RUIZ-1022', 'Amazfit Bip 5 (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 7190.00, 7909.00, 58, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-5'), 'RUIZ-1023', 'Amazfit Bip 5 (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 7290.00, 8384.00, 28, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-5'), 'RUIZ-1024', 'Amazfit Bip 5 (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 7440.00, 8556.00, 46, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-bip-5'), 'RUIZ-1025', 'Amazfit Bip 5 (Green, Silicone Strap)', 'Green', 'Silicone Strap', 7340.00, 8074.00, 30, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gts-4-mini'), 'RUIZ-1026', 'Amazfit GTS 4 Mini (Black, Silicone Strap)', 'Black', 'Silicone Strap', 9990.00, 10490.00, 9, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gts-4-mini'), 'RUIZ-1027', 'Amazfit GTS 4 Mini (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 10390.00, 10910.00, 11, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gts-4-mini'), 'RUIZ-1028', 'Amazfit GTS 4 Mini (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 10240.00, 11776.00, 6, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gts-4-mini'), 'RUIZ-1029', 'Amazfit GTS 4 Mini (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 10340.00, 11374.00, 43, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gts-4-mini'), 'RUIZ-1030', 'Amazfit GTS 4 Mini (Green, Silicone Strap)', 'Green', 'Silicone Strap', 10290.00, 11319.00, 35, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gtr-mini'), 'RUIZ-1031', 'Amazfit GTR Mini (Black, Silicone Strap)', 'Black', 'Silicone Strap', 11090.00, 12199.00, 58, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gtr-mini'), 'RUIZ-1032', 'Amazfit GTR Mini (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 11390.00, 12529.00, 14, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gtr-mini'), 'RUIZ-1033', 'Amazfit GTR Mini (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 11240.00, 12926.00, 60, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gtr-mini'), 'RUIZ-1034', 'Amazfit GTR Mini (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 11240.00, 12364.00, 54, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='amazfit-gtr-mini'), 'RUIZ-1035', 'Amazfit GTR Mini (Green, Silicone Strap)', 'Green', 'Silicone Strap', 11140.00, 12811.00, 56, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-watch-fit-2'), 'RUIZ-1036', 'Huawei Watch Fit 2 (Black, Silicone Strap)', 'Black', 'Silicone Strap', 12990.00, 14289.00, 52, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-watch-fit-2'), 'RUIZ-1037', 'Huawei Watch Fit 2 (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 13190.00, 13850.00, 55, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-watch-fit-2'), 'RUIZ-1038', 'Huawei Watch Fit 2 (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 13240.00, 14564.00, 56, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-watch-fit-2'), 'RUIZ-1039', 'Huawei Watch Fit 2 (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 13340.00, 14007.00, 19, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-watch-fit-2'), 'RUIZ-1040', 'Huawei Watch Fit 2 (Green, Silicone Strap)', 'Green', 'Silicone Strap', 13290.00, 15283.00, 44, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-band-8'), 'RUIZ-1041', 'Huawei Band 8 (Black, Silicone Strap)', 'Black', 'Silicone Strap', 4990.00, 5738.00, 12, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-band-8'), 'RUIZ-1042', 'Huawei Band 8 (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 5340.00, 5607.00, 32, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-band-8'), 'RUIZ-1043', 'Huawei Band 8 (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 5290.00, 5819.00, 30, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-band-8'), 'RUIZ-1044', 'Huawei Band 8 (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 5240.00, 5502.00, 14, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='huawei-band-8'), 'RUIZ-1045', 'Huawei Band 8 (Green, Silicone Strap)', 'Green', 'Silicone Strap', 5340.00, 6141.00, 35, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch4-40mm'), 'RUIZ-1046', 'Samsung Galaxy Watch4 40mm (Black, Silicone Strap)', 'Black', 'Silicone Strap', 18990.00, 19940.00, 5, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch4-40mm'), 'RUIZ-1047', 'Samsung Galaxy Watch4 40mm (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 19190.00, 21109.00, 60, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch4-40mm'), 'RUIZ-1048', 'Samsung Galaxy Watch4 40mm (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 19140.00, 21054.00, 37, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch4-40mm'), 'RUIZ-1049', 'Samsung Galaxy Watch4 40mm (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 19390.00, 20360.00, 8, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch4-40mm'), 'RUIZ-1050', 'Samsung Galaxy Watch4 40mm (Green, Silicone Strap)', 'Green', 'Silicone Strap', 19340.00, 22241.00, 31, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch5-44mm'), 'RUIZ-1051', 'Samsung Galaxy Watch5 44mm (Black, Silicone Strap)', 'Black', 'Silicone Strap', 24990.00, 28738.00, 37, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch5-44mm'), 'RUIZ-1052', 'Samsung Galaxy Watch5 44mm (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 25190.00, 26450.00, 16, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch5-44mm'), 'RUIZ-1053', 'Samsung Galaxy Watch5 44mm (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 25140.00, 27654.00, 48, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch5-44mm'), 'RUIZ-1054', 'Samsung Galaxy Watch5 44mm (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 25240.00, 29026.00, 8, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch5-44mm'), 'RUIZ-1055', 'Samsung Galaxy Watch5 44mm (Green, Silicone Strap)', 'Green', 'Silicone Strap', 25340.00, 27874.00, 40, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch6-40mm'), 'RUIZ-1056', 'Samsung Galaxy Watch6 40mm (Black, Silicone Strap)', 'Black', 'Silicone Strap', 30090.00, 34604.00, 37, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch6-40mm'), 'RUIZ-1057', 'Samsung Galaxy Watch6 40mm (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 30390.00, 34948.00, 56, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch6-40mm'), 'RUIZ-1058', 'Samsung Galaxy Watch6 40mm (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 30240.00, 34776.00, 17, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch6-40mm'), 'RUIZ-1059', 'Samsung Galaxy Watch6 40mm (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 30390.00, 33429.00, 9, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='samsung-galaxy-watch6-40mm'), 'RUIZ-1060', 'Samsung Galaxy Watch6 40mm (Green, Silicone Strap)', 'Green', 'Silicone Strap', 30240.00, 31752.00, 54, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-se-2nd-gen-40mm'), 'RUIZ-1061', 'Apple Watch SE (2nd Gen) 40mm (Black, Silicone Strap)', 'Black', 'Silicone Strap', 35990.00, 39589.00, 13, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-se-2nd-gen-40mm'), 'RUIZ-1062', 'Apple Watch SE (2nd Gen) 40mm (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 36340.00, 39974.00, 15, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-se-2nd-gen-40mm'), 'RUIZ-1063', 'Apple Watch SE (2nd Gen) 40mm (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 36290.00, 41734.00, 30, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-se-2nd-gen-40mm'), 'RUIZ-1064', 'Apple Watch SE (2nd Gen) 40mm (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 36340.00, 38157.00, 26, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-se-2nd-gen-40mm'), 'RUIZ-1065', 'Apple Watch SE (2nd Gen) 40mm (Green, Silicone Strap)', 'Green', 'Silicone Strap', 36240.00, 41676.00, 44, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-series-8-45mm'), 'RUIZ-1066', 'Apple Watch Series 8 45mm (Black, Silicone Strap)', 'Black', 'Silicone Strap', 55990.00, 58790.00, 10, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-series-8-45mm'), 'RUIZ-1067', 'Apple Watch Series 8 45mm (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 56290.00, 59104.00, 57, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-series-8-45mm'), 'RUIZ-1068', 'Apple Watch Series 8 45mm (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 56240.00, 61864.00, 14, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-series-8-45mm'), 'RUIZ-1069', 'Apple Watch Series 8 45mm (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 56340.00, 59157.00, 22, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='apple-watch-series-8-45mm'), 'RUIZ-1070', 'Apple Watch Series 8 45mm (Green, Silicone Strap)', 'Green', 'Silicone Strap', 56140.00, 61754.00, 6, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='realme-watch-3-pro'), 'RUIZ-1071', 'realme Watch 3 Pro (Black, Silicone Strap)', 'Black', 'Silicone Strap', 5990.00, 6290.00, 21, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='realme-watch-3-pro'), 'RUIZ-1072', 'realme Watch 3 Pro (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 6390.00, 7029.00, 22, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='realme-watch-3-pro'), 'RUIZ-1073', 'realme Watch 3 Pro (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 6140.00, 6447.00, 21, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='realme-watch-3-pro'), 'RUIZ-1074', 'realme Watch 3 Pro (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 6340.00, 7291.00, 53, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='realme-watch-3-pro'), 'RUIZ-1075', 'realme Watch 3 Pro (Green, Silicone Strap)', 'Green', 'Silicone Strap', 6240.00, 6864.00, 56, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='oneplus-nord-watch'), 'RUIZ-1076', 'OnePlus Nord Watch (Black, Silicone Strap)', 'Black', 'Silicone Strap', 7190.00, 8268.00, 17, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='oneplus-nord-watch'), 'RUIZ-1077', 'OnePlus Nord Watch (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 7340.00, 8441.00, 36, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='oneplus-nord-watch'), 'RUIZ-1078', 'OnePlus Nord Watch (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 7240.00, 8326.00, 18, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='oneplus-nord-watch'), 'RUIZ-1079', 'OnePlus Nord Watch (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 7240.00, 7964.00, 27, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='oneplus-nord-watch'), 'RUIZ-1080', 'OnePlus Nord Watch (Green, Silicone Strap)', 'Green', 'Silicone Strap', 7240.00, 7964.00, 15, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='cmf-watch-pro'), 'RUIZ-1081', 'CMF Watch Pro (Black, Silicone Strap)', 'Black', 'Silicone Strap', 9190.00, 10568.00, 23, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='cmf-watch-pro'), 'RUIZ-1082', 'CMF Watch Pro (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 9190.00, 9650.00, 22, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='cmf-watch-pro'), 'RUIZ-1083', 'CMF Watch Pro (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 9340.00, 10274.00, 20, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='cmf-watch-pro'), 'RUIZ-1084', 'CMF Watch Pro (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 9240.00, 9702.00, 26, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='cmf-watch-pro'), 'RUIZ-1085', 'CMF Watch Pro (Green, Silicone Strap)', 'Green', 'Silicone Strap', 9140.00, 9597.00, 37, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='garmin-forerunner-55'), 'RUIZ-1086', 'Garmin Forerunner 55 (Black, Silicone Strap)', 'Black', 'Silicone Strap', 26990.00, 29689.00, 42, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='garmin-forerunner-55'), 'RUIZ-1087', 'Garmin Forerunner 55 (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 27190.00, 28550.00, 42, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='garmin-forerunner-55'), 'RUIZ-1088', 'Garmin Forerunner 55 (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 27340.00, 30074.00, 53, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='garmin-forerunner-55'), 'RUIZ-1089', 'Garmin Forerunner 55 (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 27440.00, 31556.00, 14, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='garmin-forerunner-55'), 'RUIZ-1090', 'Garmin Forerunner 55 (Green, Silicone Strap)', 'Green', 'Silicone Strap', 27290.00, 31383.00, 49, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fitbit-versa-3'), 'RUIZ-1091', 'Fitbit Versa 3 (Black, Silicone Strap)', 'Black', 'Silicone Strap', 22190.00, 25518.00, 58, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fitbit-versa-3'), 'RUIZ-1092', 'Fitbit Versa 3 (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 22190.00, 23300.00, 6, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fitbit-versa-3'), 'RUIZ-1093', 'Fitbit Versa 3 (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 22290.00, 24519.00, 40, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fitbit-versa-3'), 'RUIZ-1094', 'Fitbit Versa 3 (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 22240.00, 24464.00, 21, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fitbit-versa-3'), 'RUIZ-1095', 'Fitbit Versa 3 (Green, Silicone Strap)', 'Green', 'Silicone Strap', 22340.00, 25691.00, 10, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='noise-colorfit-pro-4'), 'RUIZ-1096', 'Noise ColorFit Pro 4 (Black, Silicone Strap)', 'Black', 'Silicone Strap', 5590.00, 5870.00, 59, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='noise-colorfit-pro-4'), 'RUIZ-1097', 'Noise ColorFit Pro 4 (Silver, Silicone Strap)', 'Silver', 'Silicone Strap', 5840.00, 6424.00, 59, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='noise-colorfit-pro-4'), 'RUIZ-1098', 'Noise ColorFit Pro 4 (Blue, Silicone Strap)', 'Blue', 'Silicone Strap', 5640.00, 6486.00, 45, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Blue", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='noise-colorfit-pro-4'), 'RUIZ-1099', 'Noise ColorFit Pro 4 (Rose Gold, Silicone Strap)', 'Rose Gold', 'Silicone Strap', 5840.00, 6716.00, 52, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Rose Gold", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='noise-colorfit-pro-4'), 'RUIZ-1100', 'Noise ColorFit Pro 4 (Green, Silicone Strap)', 'Green', 'Silicone Strap', 5790.00, 6080.00, 36, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Green", "strap": "Silicone Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vd01'), 'RUIZ-1101', 'Casio MTP-VD01 (Black, Leather Strap)', 'Black', 'Leather Strap', 4140.00, 4554.00, 50, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vd01'), 'RUIZ-1102', 'Casio MTP-VD01 (Brown, Leather Strap)', 'Brown', 'Leather Strap', 4190.00, 4818.00, 17, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vd01'), 'RUIZ-1103', 'Casio MTP-VD01 (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 4590.00, 5049.00, 9, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vd01'), 'RUIZ-1104', 'Casio MTP-VD01 (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 4790.00, 5269.00, 18, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vd01'), 'RUIZ-1105', 'Casio MTP-VD01 (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 4790.00, 5030.00, 52, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vt01'), 'RUIZ-1106', 'Casio MTP-VT01 (Black, Leather Strap)', 'Black', 'Leather Strap', 3690.00, 4059.00, 12, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vt01'), 'RUIZ-1107', 'Casio MTP-VT01 (Brown, Leather Strap)', 'Brown', 'Leather Strap', 3840.00, 4224.00, 6, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vt01'), 'RUIZ-1108', 'Casio MTP-VT01 (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 4140.00, 4554.00, 51, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vt01'), 'RUIZ-1109', 'Casio MTP-VT01 (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 4290.00, 4504.00, 25, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-mtp-vt01'), 'RUIZ-1110', 'Casio MTP-VT01 (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 4290.00, 4934.00, 5, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-enticer-mtp-1374'), 'RUIZ-1111', 'Casio Enticer MTP-1374 (Black, Leather Strap)', 'Black', 'Leather Strap', 5640.00, 6204.00, 60, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-enticer-mtp-1374'), 'RUIZ-1112', 'Casio Enticer MTP-1374 (Brown, Leather Strap)', 'Brown', 'Leather Strap', 5790.00, 6080.00, 22, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-enticer-mtp-1374'), 'RUIZ-1113', 'Casio Enticer MTP-1374 (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 5990.00, 6290.00, 22, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-enticer-mtp-1374'), 'RUIZ-1114', 'Casio Enticer MTP-1374 (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 6340.00, 6657.00, 56, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-enticer-mtp-1374'), 'RUIZ-1115', 'Casio Enticer MTP-1374 (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 6490.00, 7463.00, 18, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efv-100'), 'RUIZ-1116', 'Casio Edifice EFV-100 (Black, Leather Strap)', 'Black', 'Leather Strap', 10140.00, 11661.00, 53, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efv-100'), 'RUIZ-1117', 'Casio Edifice EFV-100 (Brown, Leather Strap)', 'Brown', 'Leather Strap', 10390.00, 10910.00, 15, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efv-100'), 'RUIZ-1118', 'Casio Edifice EFV-100 (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 10590.00, 11649.00, 46, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efv-100'), 'RUIZ-1119', 'Casio Edifice EFV-100 (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 10690.00, 11224.00, 46, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efv-100'), 'RUIZ-1120', 'Casio Edifice EFV-100 (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 10940.00, 12581.00, 19, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efr-556'), 'RUIZ-1121', 'Casio Edifice EFR-556 (Black, Leather Strap)', 'Black', 'Leather Strap', 14140.00, 14847.00, 40, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efr-556'), 'RUIZ-1122', 'Casio Edifice EFR-556 (Brown, Leather Strap)', 'Brown', 'Leather Strap', 14190.00, 15609.00, 20, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efr-556'), 'RUIZ-1123', 'Casio Edifice EFR-556 (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 14490.00, 16664.00, 60, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efr-556'), 'RUIZ-1124', 'Casio Edifice EFR-556 (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 14840.00, 16324.00, 26, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-edifice-efr-556'), 'RUIZ-1125', 'Casio Edifice EFR-556 (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 14890.00, 15634.00, 48, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-weekender-40mm'), 'RUIZ-1126', 'Timex Weekender 40mm (Black, Leather Strap)', 'Black', 'Leather Strap', 7990.00, 8390.00, 22, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-weekender-40mm'), 'RUIZ-1127', 'Timex Weekender 40mm (Brown, Leather Strap)', 'Brown', 'Leather Strap', 8340.00, 9174.00, 59, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-weekender-40mm'), 'RUIZ-1128', 'Timex Weekender 40mm (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 8640.00, 9936.00, 53, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-weekender-40mm'), 'RUIZ-1129', 'Timex Weekender 40mm (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 8690.00, 9124.00, 30, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-weekender-40mm'), 'RUIZ-1130', 'Timex Weekender 40mm (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 8940.00, 9834.00, 20, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-expedition-scout'), 'RUIZ-1131', 'Timex Expedition Scout (Black, Leather Strap)', 'Black', 'Leather Strap', 10990.00, 12638.00, 49, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-expedition-scout'), 'RUIZ-1132', 'Timex Expedition Scout (Brown, Leather Strap)', 'Brown', 'Leather Strap', 11390.00, 11960.00, 5, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-expedition-scout'), 'RUIZ-1133', 'Timex Expedition Scout (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 11590.00, 12170.00, 45, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-expedition-scout'), 'RUIZ-1134', 'Timex Expedition Scout (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 11690.00, 12274.00, 9, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='timex-expedition-scout'), 'RUIZ-1135', 'Timex Expedition Scout (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 11890.00, 12484.00, 55, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-grant-chronograph'), 'RUIZ-1136', 'Fossil Grant Chronograph (Black, Leather Strap)', 'Black', 'Leather Strap', 20140.00, 22154.00, 25, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-grant-chronograph'), 'RUIZ-1137', 'Fossil Grant Chronograph (Brown, Leather Strap)', 'Brown', 'Leather Strap', 20190.00, 23218.00, 20, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-grant-chronograph'), 'RUIZ-1138', 'Fossil Grant Chronograph (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 20490.00, 21514.00, 17, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-grant-chronograph'), 'RUIZ-1139', 'Fossil Grant Chronograph (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 20790.00, 21830.00, 47, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-grant-chronograph'), 'RUIZ-1140', 'Fossil Grant Chronograph (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 20890.00, 24023.00, 31, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-neutra'), 'RUIZ-1141', 'Fossil Neutra (Black, Leather Strap)', 'Black', 'Leather Strap', 18090.00, 20804.00, 59, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-neutra'), 'RUIZ-1142', 'Fossil Neutra (Brown, Leather Strap)', 'Brown', 'Leather Strap', 18290.00, 19204.00, 19, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-neutra'), 'RUIZ-1143', 'Fossil Neutra (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 18490.00, 21264.00, 36, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-neutra'), 'RUIZ-1144', 'Fossil Neutra (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 18690.00, 21494.00, 14, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='fossil-neutra'), 'RUIZ-1145', 'Fossil Neutra (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 18990.00, 19940.00, 31, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='seiko-5-sports-srpd'), 'RUIZ-1146', 'Seiko 5 Sports (SRPD) (Black, Leather Strap)', 'Black', 'Leather Strap', 30090.00, 34604.00, 12, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='seiko-5-sports-srpd'), 'RUIZ-1147', 'Seiko 5 Sports (SRPD) (Brown, Leather Strap)', 'Brown', 'Leather Strap', 30190.00, 34718.00, 38, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='seiko-5-sports-srpd'), 'RUIZ-1148', 'Seiko 5 Sports (SRPD) (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 30640.00, 33704.00, 26, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='seiko-5-sports-srpd'), 'RUIZ-1149', 'Seiko 5 Sports (SRPD) (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 30690.00, 33759.00, 31, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='seiko-5-sports-srpd'), 'RUIZ-1150', 'Seiko 5 Sports (SRPD) (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 30790.00, 33869.00, 27, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-chandler'), 'RUIZ-1151', 'Citizen Eco-Drive Chandler (Black, Leather Strap)', 'Black', 'Leather Strap', 34990.00, 36740.00, 50, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-chandler'), 'RUIZ-1152', 'Citizen Eco-Drive Chandler (Brown, Leather Strap)', 'Brown', 'Leather Strap', 35190.00, 38709.00, 28, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-chandler'), 'RUIZ-1153', 'Citizen Eco-Drive Chandler (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 35490.00, 40814.00, 54, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-chandler'), 'RUIZ-1154', 'Citizen Eco-Drive Chandler (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 35690.00, 39259.00, 17, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-chandler'), 'RUIZ-1155', 'Citizen Eco-Drive Chandler (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 35890.00, 39479.00, 44, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-corso'), 'RUIZ-1156', 'Citizen Eco-Drive Corso (Black, Leather Strap)', 'Black', 'Leather Strap', 40090.00, 44099.00, 5, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-corso'), 'RUIZ-1157', 'Citizen Eco-Drive Corso (Brown, Leather Strap)', 'Brown', 'Leather Strap', 40190.00, 42200.00, 57, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-corso'), 'RUIZ-1158', 'Citizen Eco-Drive Corso (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 40640.00, 44704.00, 32, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-corso'), 'RUIZ-1159', 'Citizen Eco-Drive Corso (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 40690.00, 46794.00, 24, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='citizen-eco-drive-corso'), 'RUIZ-1160', 'Citizen Eco-Drive Corso (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 40890.00, 44979.00, 34, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='orient-bambino'), 'RUIZ-1161', 'Orient Bambino (Black, Leather Strap)', 'Black', 'Leather Strap', 27990.00, 30789.00, 53, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='orient-bambino'), 'RUIZ-1162', 'Orient Bambino (Brown, Leather Strap)', 'Brown', 'Leather Strap', 28340.00, 32591.00, 39, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='orient-bambino'), 'RUIZ-1163', 'Orient Bambino (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 28490.00, 31339.00, 44, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='orient-bambino'), 'RUIZ-1164', 'Orient Bambino (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 28840.00, 30282.00, 19, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='orient-bambino'), 'RUIZ-1165', 'Orient Bambino (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 28790.00, 33108.00, 39, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='daniel-wellington-classic-sheffield'), 'RUIZ-1166', 'Daniel Wellington Classic Sheffield (Black, Leather Strap)', 'Black', 'Leather Strap', 16090.00, 17699.00, 22, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='daniel-wellington-classic-sheffield'), 'RUIZ-1167', 'Daniel Wellington Classic Sheffield (Brown, Leather Strap)', 'Brown', 'Leather Strap', 16190.00, 17809.00, 20, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='daniel-wellington-classic-sheffield'), 'RUIZ-1168', 'Daniel Wellington Classic Sheffield (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 16690.00, 17524.00, 25, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='daniel-wellington-classic-sheffield'), 'RUIZ-1169', 'Daniel Wellington Classic Sheffield (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 16890.00, 17734.00, 46, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='daniel-wellington-classic-sheffield'), 'RUIZ-1170', 'Daniel Wellington Classic Sheffield (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 16790.00, 17630.00, 35, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='tissot-prx-quartz'), 'RUIZ-1171', 'Tissot PRX Quartz (Black, Leather Strap)', 'Black', 'Leather Strap', 55090.00, 57844.00, 23, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='tissot-prx-quartz'), 'RUIZ-1172', 'Tissot PRX Quartz (Brown, Leather Strap)', 'Brown', 'Leather Strap', 55390.00, 58160.00, 9, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='tissot-prx-quartz'), 'RUIZ-1173', 'Tissot PRX Quartz (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 55590.00, 63928.00, 5, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='tissot-prx-quartz'), 'RUIZ-1174', 'Tissot PRX Quartz (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 55690.00, 58474.00, 28, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='tissot-prx-quartz'), 'RUIZ-1175', 'Tissot PRX Quartz (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 55790.00, 64158.00, 51, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='invicta-pro-diver'), 'RUIZ-1176', 'Invicta Pro Diver (Black, Leather Strap)', 'Black', 'Leather Strap', 19090.00, 20999.00, 48, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='invicta-pro-diver'), 'RUIZ-1177', 'Invicta Pro Diver (Brown, Leather Strap)', 'Brown', 'Leather Strap', 19190.00, 21109.00, 40, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='invicta-pro-diver'), 'RUIZ-1178', 'Invicta Pro Diver (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 19690.00, 20674.00, 45, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='invicta-pro-diver'), 'RUIZ-1179', 'Invicta Pro Diver (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 19790.00, 21769.00, 23, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='invicta-pro-diver'), 'RUIZ-1180', 'Invicta Pro Diver (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 19990.00, 21989.00, 31, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='titan-neo'), 'RUIZ-1181', 'Titan Neo (Black, Leather Strap)', 'Black', 'Leather Strap', 9090.00, 10454.00, 17, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='titan-neo'), 'RUIZ-1182', 'Titan Neo (Brown, Leather Strap)', 'Brown', 'Leather Strap', 9340.00, 9807.00, 32, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='titan-neo'), 'RUIZ-1183', 'Titan Neo (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 9590.00, 10549.00, 54, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='titan-neo'), 'RUIZ-1184', 'Titan Neo (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 9840.00, 10332.00, 41, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='titan-neo'), 'RUIZ-1185', 'Titan Neo (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 9790.00, 10769.00, 23, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='skagen-signatur'), 'RUIZ-1186', 'Skagen Signatur (Black, Leather Strap)', 'Black', 'Leather Strap', 20140.00, 22154.00, 53, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='skagen-signatur'), 'RUIZ-1187', 'Skagen Signatur (Brown, Leather Strap)', 'Brown', 'Leather Strap', 20190.00, 21200.00, 35, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='skagen-signatur'), 'RUIZ-1188', 'Skagen Signatur (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 20490.00, 23563.00, 44, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='skagen-signatur'), 'RUIZ-1189', 'Skagen Signatur (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 20690.00, 23793.00, 30, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='skagen-signatur'), 'RUIZ-1190', 'Skagen Signatur (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 20990.00, 22040.00, 7, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='mvmt-classic'), 'RUIZ-1191', 'MVMT Classic (Black, Leather Strap)', 'Black', 'Leather Strap', 14990.00, 15740.00, 20, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='mvmt-classic'), 'RUIZ-1192', 'MVMT Classic (Brown, Leather Strap)', 'Brown', 'Leather Strap', 15390.00, 17698.00, 7, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='mvmt-classic'), 'RUIZ-1193', 'MVMT Classic (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 15640.00, 17986.00, 59, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='mvmt-classic'), 'RUIZ-1194', 'MVMT Classic (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 15890.00, 16684.00, 32, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='mvmt-classic'), 'RUIZ-1195', 'MVMT Classic (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 15790.00, 16580.00, 5, 12, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 12, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-a168'), 'RUIZ-1196', 'Casio A168 (Black, Leather Strap)', 'Black', 'Leather Strap', 3190.00, 3509.00, 58, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Black", "strap": "Leather Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-a168'), 'RUIZ-1197', 'Casio A168 (Brown, Leather Strap)', 'Brown', 'Leather Strap', 3190.00, 3509.00, 32, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Brown", "strap": "Leather Strap", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-a168'), 'RUIZ-1198', 'Casio A168 (Silver, Steel Bracelet)', 'Silver', 'Steel Bracelet', 3490.00, 3664.00, 45, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Silver", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-a168'), 'RUIZ-1199', 'Casio A168 (Gold, Steel Bracelet)', 'Gold', 'Steel Bracelet', 3890.00, 4084.00, 8, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Gold", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;
insert into public.product_variants (product_id, sku, title, color, strap, price_bdt, compare_at_bdt, stock_qty, warranty_months, warranty_note, specs, is_active)
values ((select id from public.products where slug='casio-a168'), 'RUIZ-1200', 'Casio A168 (Two-Tone, Steel Bracelet)', 'Two-Tone', 'Steel Bracelet', 3790.00, 3980.00, 59, 6, 'Brand warranty (if provided). See product page for details.', '{"color": "Two-Tone", "strap": "Steel Bracelet", "warranty_months": 6, "brand_based": true}'::jsonb, true)
on conflict (sku) do nothing;

-- Product -> Collections
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-bip-3-pro' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-bip-3-pro' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-bip-5' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-bip-5' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-bip-5' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-bip-5' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-bip-5' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gtr-mini' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gtr-mini' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gtr-mini' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gtr-mini' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gts-4-mini' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gts-4-mini' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gts-4-mini' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gts-4-mini' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='amazfit-gts-4-mini' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-se-2nd-gen-40mm' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-se-2nd-gen-40mm' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-se-2nd-gen-40mm' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-se-2nd-gen-40mm' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-series-8-45mm' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-series-8-45mm' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-series-8-45mm' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-series-8-45mm' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-series-8-45mm' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='apple-watch-series-8-45mm' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-a168' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-a168' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-a168' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-a168' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-edifice-efr-556' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-edifice-efr-556' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-edifice-efr-556' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-edifice-efv-100' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-edifice-efv-100' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-enticer-mtp-1374' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-enticer-mtp-1374' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-enticer-mtp-1374' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-enticer-mtp-1374' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-mtp-vd01' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-mtp-vd01' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-mtp-vd01' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-mtp-vd01' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-mtp-vt01' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-mtp-vt01' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='casio-mtp-vt01' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-chandler' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-chandler' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-chandler' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-chandler' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-corso' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-corso' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-corso' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-corso' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='citizen-eco-drive-corso' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='cmf-watch-pro' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='cmf-watch-pro' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='cmf-watch-pro' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='cmf-watch-pro' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='cmf-watch-pro' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='daniel-wellington-classic-sheffield' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='daniel-wellington-classic-sheffield' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='daniel-wellington-classic-sheffield' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fitbit-versa-3' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fitbit-versa-3' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fitbit-versa-3' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fitbit-versa-3' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-grant-chronograph' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-grant-chronograph' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-grant-chronograph' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-grant-chronograph' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-neutra' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-neutra' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-neutra' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-neutra' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='fossil-neutra' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='garmin-forerunner-55' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='garmin-forerunner-55' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='garmin-forerunner-55' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='garmin-forerunner-55' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='garmin-forerunner-55' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='garmin-forerunner-55' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='huawei-band-8' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='huawei-band-8' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='huawei-band-8' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='huawei-band-8' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='huawei-watch-fit-2' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='huawei-watch-fit-2' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='huawei-watch-fit-2' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='invicta-pro-diver' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='invicta-pro-diver' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='invicta-pro-diver' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='mvmt-classic' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='mvmt-classic' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='mvmt-classic' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='noise-colorfit-pro-4' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='noise-colorfit-pro-4' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='noise-colorfit-pro-4' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='noise-colorfit-pro-4' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='oneplus-nord-watch' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='oneplus-nord-watch' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='oneplus-nord-watch' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='oneplus-nord-watch' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='orient-bambino' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='orient-bambino' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='orient-bambino' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='orient-bambino' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='orient-bambino' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='orient-bambino' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='realme-watch-3-pro' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='realme-watch-3-pro' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='realme-watch-3-pro' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='realme-watch-3-pro' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='realme-watch-3-pro' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch4-40mm' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch4-40mm' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch4-40mm' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch5-44mm' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch5-44mm' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch5-44mm' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch5-44mm' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch5-44mm' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch6-40mm' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch6-40mm' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch6-40mm' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch6-40mm' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='samsung-galaxy-watch6-40mm' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='seiko-5-sports-srpd' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='seiko-5-sports-srpd' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='seiko-5-sports-srpd' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='seiko-5-sports-srpd' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='seiko-5-sports-srpd' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='skagen-signatur' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='skagen-signatur' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='skagen-signatur' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='timex-expedition-scout' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='timex-expedition-scout' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='timex-expedition-scout' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='timex-expedition-scout' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='timex-weekender-40mm' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='timex-weekender-40mm' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='timex-weekender-40mm' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='tissot-prx-quartz' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='tissot-prx-quartz' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='tissot-prx-quartz' and c.slug='premium'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='tissot-prx-quartz' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='tissot-prx-quartz' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='tissot-prx-quartz' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='titan-neo' and c.slug='classic-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='titan-neo' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='titan-neo' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='titan-neo' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='titan-neo' and c.slug='women'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-mi-watch-lite-2' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-mi-watch-lite-2' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-mi-watch-lite-2' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-mi-watch-lite-2' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-redmi-watch-3-active' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-redmi-watch-3-active' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-redmi-watch-4' and c.slug='gift-picks'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-redmi-watch-4' and c.slug='sale'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-redmi-watch-4' and c.slug='smart-watches'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-redmi-watch-4' and c.slug='under-takax'
on conflict do nothing;
insert into public.product_collections (product_id, collection_id)
select p.id, c.id from public.products p, public.collections c
where p.slug='xiaomi-redmi-watch-4' and c.slug='women'
on conflict do nothing;

-- Placeholder product images (1 per product)
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='casio-a168'), 'https://placehold.co/800x800?text=Ruiz+casio+a168', 'Ruiz casio-a168', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='casio-edifice-efr-556'), 'https://placehold.co/800x800?text=Ruiz+casio+edifice+efr+556', 'Ruiz casio-edifice-efr-556', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='casio-edifice-efv-100'), 'https://placehold.co/800x800?text=Ruiz+casio+edifice+efv+100', 'Ruiz casio-edifice-efv-100', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='casio-enticer-mtp-1374'), 'https://placehold.co/800x800?text=Ruiz+casio+enticer+mtp+1374', 'Ruiz casio-enticer-mtp-1374', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='casio-mtp-vd01'), 'https://placehold.co/800x800?text=Ruiz+casio+mtp+vd01', 'Ruiz casio-mtp-vd01', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='casio-mtp-vt01'), 'https://placehold.co/800x800?text=Ruiz+casio+mtp+vt01', 'Ruiz casio-mtp-vt01', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='citizen-eco-drive-chandler'), 'https://placehold.co/800x800?text=Ruiz+citizen+eco+drive+chandler', 'Ruiz citizen-eco-drive-chandler', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='citizen-eco-drive-corso'), 'https://placehold.co/800x800?text=Ruiz+citizen+eco+drive+corso', 'Ruiz citizen-eco-drive-corso', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='daniel-wellington-classic-sheffield'), 'https://placehold.co/800x800?text=Ruiz+daniel+wellington+classic+sheffield', 'Ruiz daniel-wellington-classic-sheffield', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='fossil-grant-chronograph'), 'https://placehold.co/800x800?text=Ruiz+fossil+grant+chronograph', 'Ruiz fossil-grant-chronograph', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='fossil-neutra'), 'https://placehold.co/800x800?text=Ruiz+fossil+neutra', 'Ruiz fossil-neutra', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='invicta-pro-diver'), 'https://placehold.co/800x800?text=Ruiz+invicta+pro+diver', 'Ruiz invicta-pro-diver', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='mvmt-classic'), 'https://placehold.co/800x800?text=Ruiz+mvmt+classic', 'Ruiz mvmt-classic', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='orient-bambino'), 'https://placehold.co/800x800?text=Ruiz+orient+bambino', 'Ruiz orient-bambino', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='seiko-5-sports-srpd'), 'https://placehold.co/800x800?text=Ruiz+seiko+5+sports+srpd', 'Ruiz seiko-5-sports-srpd', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='skagen-signatur'), 'https://placehold.co/800x800?text=Ruiz+skagen+signatur', 'Ruiz skagen-signatur', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='timex-expedition-scout'), 'https://placehold.co/800x800?text=Ruiz+timex+expedition+scout', 'Ruiz timex-expedition-scout', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='timex-weekender-40mm'), 'https://placehold.co/800x800?text=Ruiz+timex+weekender+40mm', 'Ruiz timex-weekender-40mm', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='tissot-prx-quartz'), 'https://placehold.co/800x800?text=Ruiz+tissot+prx+quartz', 'Ruiz tissot-prx-quartz', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='titan-neo'), 'https://placehold.co/800x800?text=Ruiz+titan+neo', 'Ruiz titan-neo', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='amazfit-bip-3-pro'), 'https://placehold.co/800x800?text=Ruiz+amazfit+bip+3+pro', 'Ruiz amazfit-bip-3-pro', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='amazfit-bip-5'), 'https://placehold.co/800x800?text=Ruiz+amazfit+bip+5', 'Ruiz amazfit-bip-5', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='amazfit-gtr-mini'), 'https://placehold.co/800x800?text=Ruiz+amazfit+gtr+mini', 'Ruiz amazfit-gtr-mini', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='amazfit-gts-4-mini'), 'https://placehold.co/800x800?text=Ruiz+amazfit+gts+4+mini', 'Ruiz amazfit-gts-4-mini', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='apple-watch-se-2nd-gen-40mm'), 'https://placehold.co/800x800?text=Ruiz+apple+watch+se+2nd+gen+40mm', 'Ruiz apple-watch-se-2nd-gen-40mm', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='apple-watch-series-8-45mm'), 'https://placehold.co/800x800?text=Ruiz+apple+watch+series+8+45mm', 'Ruiz apple-watch-series-8-45mm', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='cmf-watch-pro'), 'https://placehold.co/800x800?text=Ruiz+cmf+watch+pro', 'Ruiz cmf-watch-pro', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='fitbit-versa-3'), 'https://placehold.co/800x800?text=Ruiz+fitbit+versa+3', 'Ruiz fitbit-versa-3', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='garmin-forerunner-55'), 'https://placehold.co/800x800?text=Ruiz+garmin+forerunner+55', 'Ruiz garmin-forerunner-55', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='huawei-band-8'), 'https://placehold.co/800x800?text=Ruiz+huawei+band+8', 'Ruiz huawei-band-8', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='huawei-watch-fit-2'), 'https://placehold.co/800x800?text=Ruiz+huawei+watch+fit+2', 'Ruiz huawei-watch-fit-2', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='noise-colorfit-pro-4'), 'https://placehold.co/800x800?text=Ruiz+noise+colorfit+pro+4', 'Ruiz noise-colorfit-pro-4', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='oneplus-nord-watch'), 'https://placehold.co/800x800?text=Ruiz+oneplus+nord+watch', 'Ruiz oneplus-nord-watch', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='samsung-galaxy-watch4-40mm'), 'https://placehold.co/800x800?text=Ruiz+samsung+galaxy+watch4+40mm', 'Ruiz samsung-galaxy-watch4-40mm', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='samsung-galaxy-watch5-44mm'), 'https://placehold.co/800x800?text=Ruiz+samsung+galaxy+watch5+44mm', 'Ruiz samsung-galaxy-watch5-44mm', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='samsung-galaxy-watch6-40mm'), 'https://placehold.co/800x800?text=Ruiz+samsung+galaxy+watch6+40mm', 'Ruiz samsung-galaxy-watch6-40mm', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='xiaomi-mi-watch-lite-2'), 'https://placehold.co/800x800?text=Ruiz+xiaomi+mi+watch+lite+2', 'Ruiz xiaomi-mi-watch-lite-2', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='xiaomi-redmi-watch-3-active'), 'https://placehold.co/800x800?text=Ruiz+xiaomi+redmi+watch+3+active', 'Ruiz xiaomi-redmi-watch-3-active', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='xiaomi-redmi-watch-4'), 'https://placehold.co/800x800?text=Ruiz+xiaomi+redmi+watch+4', 'Ruiz xiaomi-redmi-watch-4', 0, true)
on conflict do nothing;
insert into public.product_images (product_id, url, alt, sort_order, is_primary)
values ((select id from public.products where slug='realme-watch-3-pro'), 'https://placehold.co/800x800?text=Ruiz+realme+watch+3+pro', 'Ruiz realme-watch-3-pro', 0, true)
on conflict do nothing;

-- Coupons (examples)
insert into public.coupons (code, discount_type, amount, min_subtotal, max_uses, max_uses_per_user, is_active)
values
  ('WELCOME100','fixed', 100, 999, 5000, 1, true),
  ('WEEKEND10','percent', 10, 1999, 2000, 1, true)
on conflict (code) do nothing;

-- Bundles (examples)
insert into public.bundles (name, slug, description, discount_type, amount, is_active)
values
  ('Gift Box Add-on','gift-box-addon','Add gift-ready packaging to your order.','fixed', 99, true),
  ('Watch + Extra Strap Bundle','watch-extra-strap','Bundle a watch with an extra strap for better value.','percent', 5, true)
on conflict (slug) do nothing;

commit;
