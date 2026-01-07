
import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { ProductCard } from '../components/ProductCard';
import { HomeTestimonials } from '../components/HomeTestimonials';
import { supabase } from '../lib/supabase';
import { buildWhatsAppUrl } from '../lib/utils';
import { Icon } from '../components/Icon';
import {
  FiShoppingCart, FiMessageCircle, FiTruck, FiShield, FiMapPin,
  FiCheck, FiStar, FiArrowRight, FiGift, FiActivity, FiWatch
} from 'react-icons/fi';
import { FaWhatsapp } from 'react-icons/fa6';
import { PageTransition } from '../components/motion/PageTransition';
import { Reveal } from '../components/motion/Reveal';
import { motion } from 'framer-motion';

interface HomeData {
  collections: any[];
  bestSellers: any[];
  newArrivals: any[];
}

const COLLECTION_IMAGES: Record<string, string> = {
  'smart-watches': 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?q=80&w=800&auto=format&fit=crop',
  'classic-watches': 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?q=80&w=800&auto=format&fit=crop',
  'women': 'https://images.unsplash.com/photo-1590736969955-71cc94801759?q=80&w=800&auto=format&fit=crop',
  'gift-picks': 'https://images.unsplash.com/photo-1549439602-43ebca2327af?q=80&w=800&auto=format&fit=crop',
  'sale': 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=800&auto=format&fit=crop',
  'mens': 'https://images.unsplash.com/photo-1619134778706-7015533a6150?q=80&w=800&auto=format&fit=crop',
  'accessories': 'https://images.unsplash.com/photo-1509048191080-d2984bad6ae5?q=80&w=800&auto=format&fit=crop',
  'premium': 'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?q=80&w=800&auto=format&fit=crop',
  'everyday-essentials': 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?q=80&w=800&auto=format&fit=crop'
};

const getCollectionImage = (slug: string) => {
  return COLLECTION_IMAGES[slug] || 'https://images.unsplash.com/photo-1434056886845-dac89dd99199?q=80&w=800&auto=format&fit=crop';
};

export const Home: React.FC = () => {
  const [data, setData] = useState<HomeData>({
    collections: [],
    bestSellers: [],
    newArrivals: [],
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchHomeData() {
      setLoading(true);
      try {
        // 1. Collections (Prioritize main categories)
        const { data: colData } = await supabase
          .from('collections')
          .select('*')
          .order('name')
          .limit(8);

        // 2. Best Sellers (Higher Price = Premium/Best Seller for now)
        const { data: bestData } = await supabase
          .from('products')
          .select(`
            id, title, slug, model,
            brand:brands(name),
            variants:product_variants(id, sku, price_bdt, compare_at_bdt, stock_qty),
            images:product_images(url, is_primary)
          `)
          .order('default_warranty_months', { ascending: false }) // Proxy for premium
          .limit(8);

        // 3. New Arrivals
        const { data: newData } = await supabase
          .from('products')
          .select(`
            id, title, slug, model,
            brand:brands(name),
            variants:product_variants(id, sku, price_bdt, compare_at_bdt, stock_qty),
            images:product_images(url, is_primary)
          `)
          .order('created_at', { ascending: false })
          .limit(8);

        const formatProduct = (p: any) => {
          const primaryVariant = p.variants?.[0];
          const primaryImage = p.images?.find((img: any) => img.is_primary) || p.images?.[0];
          const brandInfo = Array.isArray(p.brand) ? p.brand[0] : p.brand;

          return {
            id: p.id,
            slug: p.slug,
            title: p.title,
            brand: brandInfo?.name || 'Ruiz',
            price: primaryVariant?.price_bdt || 0,
            compareAt: primaryVariant?.compare_at_bdt,
            image: primaryImage?.url,
            variantId: primaryVariant?.id,
            sku: primaryVariant?.sku,
            stock: primaryVariant?.stock_qty,
            model: p.model
          };
        };

        setData({
          collections: colData || [],
          bestSellers: bestData?.map(formatProduct) || [],
          newArrivals: newData?.map(formatProduct) || [],
        });

      } catch (err) {
        console.error('Error fetching home data:', err);
      } finally {
        setLoading(false);
      }
    }
    fetchHomeData();
  }, []);

  const whatsappHero = "Hi Ruiz, I'm interested in buying a watch. Can you help me choose?";
  const whatsappBulk = "Hi Ruiz, I'm interested in corporate/wholesale orders.";

  return (
    <PageTransition className="bg-white pb-20 overflow-hidden">

      {/* --- SECTION 01: LUXURY HERO --- */}
      <section className="relative bg-white lg:min-h-[90vh] flex items-center pt-24 lg:pt-0 overflow-hidden">
        {/* Subtle Background Elements */}
        <div className="absolute top-0 right-0 w-1/2 h-full bg-slate-50/50 -z-0"></div>
        <div className="absolute -top-24 -left-24 w-96 h-96 bg-slate-50 rounded-full blur-3xl opacity-50 -z-0"></div>

        <div className="relative z-10 max-w-7xl mx-auto px-6 sm:px-10 lg:px-12 py-12 lg:py-20 w-full">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 lg:gap-24 items-center">

            {/* Left Column: Typography */}
            <motion.div
              initial={{ opacity: 0, x: -30 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ duration: 0.8, ease: "easeOut" }}
              className="flex flex-col space-y-8"
            >
              <div className="space-y-4">
                <motion.span
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.3 }}
                  className="text-[#FF8C00] font-bold uppercase tracking-[0.3em] text-[10px]"
                >
                  Est. 2024 — Premium Collection
                </motion.span>
                <h1 className="text-6xl md:text-7xl lg:text-8xl font-black text-black leading-[0.9] tracking-tighter uppercase">
                  Explore <br />
                  <span className="font-serif italic capitalize font-normal lowercase tracking-normal text-slate-800">the latest</span> <br />
                  & Best <br />
                  <span className="font-serif italic capitalize font-normal lowercase tracking-normal text-slate-800">Timepiece</span>
                </h1>
              </div>

              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.5 }}
                className="flex flex-col space-y-6"
              >
                <p className="text-slate-500 text-base max-w-sm leading-relaxed font-light">
                  With diverse designs, features, and technologies available,
                  watches remain versatile and multifunctional devices.
                </p>

                <div className="flex items-center space-x-6">
                  <Link
                    to="/shop"
                    className="group relative px-8 py-4 bg-black text-white text-xs font-bold uppercase tracking-widest overflow-hidden transition-all hover:pr-12"
                  >
                    <span className="relative z-10">Get Started</span>
                    <div className="absolute right-0 top-0 h-full w-0 bg-[#FF8C00] group-hover:w-full transition-all duration-300 -z-0"></div>
                    <Icon icon={FiArrowRight} className="absolute right-4 top-1/2 -translate-y-1/2 opacity-0 group-hover:opacity-100 transition-all font-bold" />
                  </Link>

                  <div className="flex flex-col">
                    <span className="text-[10px] text-slate-400 font-bold uppercase tracking-widest">January 12, 2024</span>
                    <span className="text-sm font-bold text-black group cursor-pointer hover:text-[#FF8C00] transition-colors">
                      Made with Technological Advancements.
                    </span>
                  </div>
                </div>
              </motion.div>


            </motion.div>

            {/* Right Column: Visual */}
            <motion.div
              initial={{ opacity: 0, scale: 0.9, x: 50 }}
              animate={{ opacity: 1, scale: 1, x: 0 }}
              transition={{ duration: 1, ease: "circOut" }}
              className="relative"
            >
              {/* Chamfered Container */}
              <div
                className="relative aspect-square w-full bg-slate-200 overflow-hidden"
                style={{ clipPath: 'polygon(15% 0%, 100% 0%, 100% 85%, 85% 100%, 0% 100%, 0% 15%)' }}
              >
                <img
                  src="https://images.unsplash.com/photo-1622434641406-a158123450f9?q=80&w=704&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
                  alt="Luxury Luna Automatic"
                  className="w-full h-full object-cover transform hover:scale-105 transition-transform duration-1000"
                />


              </div>

              {/* Decorative Accent */}
              <div className="absolute -bottom-6 -right-6 w-24 h-24 bg-[#FF8C00] -z-10" style={{ clipPath: 'polygon(0 100%, 100% 100%, 100% 0)' }}></div>
            </motion.div>

          </div>
        </div>
      </section>

      {/* --- SECTION 02: PROBLEM & SOLUTION --- */}
      <Reveal className="bg-white py-20 border-b border-slate-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto mb-16">
            <h2 className="text-3xl font-bold tracking-tighter mb-6">Why buy from Ruiz?</h2>
            <p className="text-slate-500 font-light leading-relaxed">
              Worried about fake products, slow delivery, or no warranty? We've solved that.
              Ruiz brings you a curated selection of 100% authentic timepieces with transparent policies.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              { icon: FiShield, title: "Authentic & Verified", desc: "Every watch is sourced directly from authorized distributors. No copies, no fakes." },
              { icon: FiTruck, title: "Lightning Fast Delivery", desc: "Get your order within 12 hours inside Dhaka and 24 hours nationwide." },
              { icon: FiMessageCircle, title: "Real Human Support", desc: "Confused? Chat with us on WhatsApp for live photos and specs guidance." }
            ].map((item, idx) => (
              <div key={idx} className="p-8 bg-slate-50 border border-slate-100 rounded-sm hover:shadow-md transition-shadow">
                <div className="w-12 h-12 bg-white text-slate-900 rounded-full flex items-center justify-center mb-6 shadow-sm border border-slate-100">
                  <Icon icon={item.icon} size={24} />
                </div>
                <h3 className="text-sm font-bold uppercase tracking-widest mb-3">{item.title}</h3>
                <p className="text-sm text-slate-500 leading-relaxed font-light">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </Reveal>

      {/* --- SECTION 03: COLLECTIONS --- */}
      <Reveal className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="flex justify-between items-end mb-10">
          <div>
            <h2 className="text-3xl font-bold tracking-tighter">Explore Collections</h2>
            <p className="text-slate-500 mt-2 text-sm font-light">Curated for every style.</p>
          </div>
          <Link to="/shop" className="text-xs font-bold uppercase tracking-widest border-b border-slate-900 pb-1 hover:opacity-70">View All</Link>
        </div>

        {loading ? (
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {[1, 2, 3, 4].map(i => <div key={i} className="aspect-square bg-slate-100 animate-pulse rounded-sm"></div>)}
          </div>
        ) : (
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-8">
            {data.collections.map((col, idx) => (
              <motion.div
                key={col.id}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: idx * 0.1, duration: 0.5 }}
                viewport={{ once: true }}
              >
                <Link to={`/c/${col.slug}`} className="group relative aspect-[4/5] overflow-hidden bg-slate-100 block group">
                  <img
                    src={col.image_url || getCollectionImage(col.slug)}
                    alt={col.name}
                    className="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-110"
                  />
                  {/* Premium Overlay */}
                  <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent opacity-60 group-hover:opacity-80 transition-opacity duration-500"></div>

                  <div className="absolute bottom-0 left-0 w-full p-6 transform translate-y-2 group-hover:translate-y-0 transition-transform duration-500">
                    <span className="text-[#FF8C00] text-[8px] font-black uppercase tracking-[0.4em] mb-2 block">Collection</span>
                    <h3 className="text-white text-2xl font-black uppercase tracking-tight leading-none mb-4">{col.name}</h3>
                    <div className="flex items-center space-x-2 text-white/0 group-hover:text-white/100 transition-all duration-500 delay-100">
                      <span className="text-[10px] font-bold uppercase tracking-widest">Explore More</span>
                      <span className="text-[#FF8C00]">
                        <FiArrowRight size={12} />
                      </span>
                    </div>
                  </div>

                  {/* Border Accent */}
                  <div className="absolute inset-0 border-0 group-hover:border-[12px] border-white/5 transition-all duration-500 pointer-events-none"></div>
                </Link>
              </motion.div>
            ))}
          </div>
        )}
      </Reveal>

      {/* --- SECTION 04: BEST SELLERS --- */}
      <Reveal className="bg-slate-50 py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold tracking-tighter mb-12 text-center">Best Sellers</h2>

          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-x-6 gap-y-10">
            {loading ? (
              [1, 2, 3, 4].map(i => <div key={i} className="aspect-[4/5] bg-slate-200 animate-pulse rounded-sm"></div>)
            ) : (
              data.bestSellers.map((p, idx) => (
                <motion.div
                  key={p.id}
                  initial={{ opacity: 0, y: 20 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  transition={{ delay: idx * 0.05, duration: 0.5 }}
                  viewport={{ once: true }}
                >
                  <ProductCard {...p} />
                </motion.div>
              ))
            )}
          </div>

          <div className="mt-12 text-center">
            <Link to="/shop" className="inline-block bg-white border border-slate-200 px-8 py-4 text-xs font-bold uppercase tracking-widest hover:border-slate-900 transition-colors">
              View All Best Sellers
            </Link>
          </div>
        </div>
      </Reveal>

      {/* --- SECTION 05: USE CASE (Gifting) --- */}
      <Reveal className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <Link to="/c/gift-picks" className="relative h-[400px] group overflow-hidden">
            <img src="https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?q=80&w=1000&auto=format&fit=crop" className="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-110" alt="Gifts for Him" />
            <div className="absolute inset-0 bg-black/40 group-hover:bg-black/60 transition-all duration-500"></div>
            <div className="absolute inset-0 flex flex-col items-center justify-center text-white px-8 text-center">
              <span className="text-[#FF8C00] text-[10px] font-black uppercase tracking-[0.5em] mb-4">Curated</span>
              <h3 className="text-4xl font-black uppercase tracking-tighter mb-4">Gifts for <br /> Him</h3>
              <p className="text-white/60 text-xs font-light max-w-[200px] mb-8 opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                Premium timepieces selected for the modern gentleman.
              </p>
              <div className="flex items-center space-x-3 border-b border-[#FF8C00] pb-2 group-hover:px-4 transition-all duration-500">
                <span className="text-[10px] font-bold uppercase tracking-[0.2em]">Shop Selection</span>
                <Icon icon={FiArrowRight} size={14} className="text-[#FF8C00]" />
              </div>
            </div>
          </Link>
          <Link to="/c/women" className="relative h-[400px] group overflow-hidden">
            <img src="https://images.unsplash.com/photo-1590736969955-71cc94801759?q=80&w=1000&auto=format&fit=crop" className="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-110" alt="Gifts for Her" />
            <div className="absolute inset-0 bg-black/40 group-hover:bg-black/60 transition-all duration-500"></div>
            <div className="absolute inset-0 flex flex-col items-center justify-center text-white px-8 text-center">
              <span className="text-[#FF8C00] text-[10px] font-black uppercase tracking-[0.5em] mb-4">Elegance</span>
              <h3 className="text-4xl font-black uppercase tracking-tighter mb-4">Gifts for <br /> Her</h3>
              <p className="text-white/60 text-xs font-light max-w-[200px] mb-8 opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                Timeless pieces for the sophisticated woman.
              </p>
              <div className="flex items-center space-x-3 border-b border-[#FF8C00] pb-2 group-hover:px-4 transition-all duration-500">
                <span className="text-[10px] font-bold uppercase tracking-[0.2em]">Explore More</span>
                <Icon icon={FiArrowRight} size={14} className="text-[#FF8C00]" />
              </div>
            </div>
          </Link>
          <Link to="/c/smart-watches" className="relative h-[400px] group overflow-hidden">
            <img src="https://images.unsplash.com/photo-1579586337278-3befd40fd17a?q=80&w=1000&auto=format&fit=crop" className="w-full h-full object-cover transition-transform duration-1000 group-hover:scale-110" alt="Fitness & Tech" />
            <div className="absolute inset-0 bg-black/40 group-hover:bg-black/60 transition-all duration-500"></div>
            <div className="absolute inset-0 flex flex-col items-center justify-center text-white px-8 text-center">
              <span className="text-[#FF8C00] text-[10px] font-black uppercase tracking-[0.5em] mb-4">Innovation</span>
              <h3 className="text-4xl font-black uppercase tracking-tighter mb-4">Fitness <br /> & Tech</h3>
              <p className="text-white/60 text-xs font-light max-w-[200px] mb-8 opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                Next-gen features meet classic design.
              </p>
              <div className="flex items-center space-x-3 border-b border-[#FF8C00] pb-2 group-hover:px-4 transition-all duration-500">
                <span className="text-[10px] font-bold uppercase tracking-[0.2em]">View Tech</span>
                <Icon icon={FiArrowRight} size={14} className="text-[#FF8C00]" />
              </div>
            </div>
          </Link>
        </div>
      </Reveal>

      {/* --- SECTION 06: NEW ARRIVALS --- */}
      <Reveal className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 border-t border-slate-50">
        <h2 className="text-3xl font-bold tracking-tighter mb-12">New Arrivals</h2>
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-x-6 gap-y-10">
          {loading ? (
            [1, 2, 3, 4].map(i => <div key={i} className="aspect-[4/5] bg-slate-100 animate-pulse rounded-sm"></div>)
          ) : (
            data.newArrivals.map((p, idx) => (
              <motion.div
                key={p.id}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: idx * 0.05, duration: 0.5 }}
                viewport={{ once: true }}
              >
                <ProductCard {...p} />
              </motion.div>
            ))
          )}
        </div>
      </Reveal>

      {/* --- SECTION 07: SOCIAL PROOF (New Dynamic Module) --- */}
      <Reveal>
        <HomeTestimonials />
      </Reveal>

      {/* --- SECTION 08: WHOLESALE CTA --- */}
      <Reveal className="bg-slate-50 border-b border-slate-100 py-16">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <span className="text-[10px] font-bold uppercase tracking-[0.2em] text-slate-400 mb-4 block">Corporate & Bulk</span>
          <h2 className="text-3xl font-bold tracking-tighter mb-6">Need watches for corporate gifting?</h2>
          <p className="text-slate-500 mb-8 max-w-lg mx-auto font-light">
            We offer exclusive bulk pricing and custom packaging for corporate orders.
          </p>
          <div className="flex flex-col sm:flex-row justify-center gap-4">
            <Link to="/wholesale" className="bg-white border border-slate-200 text-slate-900 px-8 py-3 font-bold uppercase tracking-widest text-xs hover:bg-slate-100">
              Request Quote
            </Link>
            <a href={buildWhatsAppUrl(whatsappBulk)} className="flex items-center justify-center text-green-600 font-bold uppercase tracking-widest text-xs px-8 py-3">
              <Icon icon={FaWhatsapp} className="mr-2" size={16} /> WhatsApp Us
            </a>
          </div>
        </div>
      </Reveal>

      {/* --- SECTION 09: FINAL CONVERSION CTA --- */}
      <Reveal className="py-24 text-center px-4">
        <h2 className="text-4xl font-bold tracking-tighter mb-8">Ready to find your style?</h2>
        <div className="flex flex-col sm:flex-row justify-center gap-4">
          <Link to="/shop" className="inline-flex items-center justify-center bg-slate-900 text-white px-10 py-5 font-bold tracking-[0.15em] uppercase text-xs hover:bg-slate-800 transition-all shadow-xl group">
            <Icon icon={FiShoppingCart} className="mr-3 group-hover:-translate-y-0.5 transition-transform" />
            Shop Watches
          </Link>
        </div>
        <p className="mt-8 text-[10px] font-bold uppercase tracking-widest text-slate-400">
          Free Delivery on orders over ৳5000 • 7-Day Exchange
        </p>
      </Reveal>

    </PageTransition>
  );
};
