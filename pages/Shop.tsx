
import React, { useState, useEffect } from 'react';
import { useParams, useSearchParams } from 'react-router-dom';
import { ProductCard } from '../components/ProductCard';
import { supabase } from '../lib/supabase';
import { PageTransition } from '../components/motion/PageTransition';
import { Reveal } from '../components/motion/Reveal';
import { motion, AnimatePresence } from 'framer-motion';

export const Shop: React.FC = () => {
  const { collectionSlug } = useParams();
  const [searchParams, setSearchParams] = useSearchParams();
  const [products, setProducts] = useState<any[]>([]);
  const [brands, setBrands] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const q = searchParams.get('q');

  const [sortBy, setSortBy] = useState('newest');
  const [selectedBrands, setSelectedBrands] = useState<string[]>([]);

  useEffect(() => {
    async function fetchFilterData() {
      const { data: brandData } = await supabase.from('brands').select('id, name');
      if (brandData) setBrands(brandData);
    }
    fetchFilterData();
  }, []);

  useEffect(() => {
    async function fetchProducts() {
      setIsLoading(true);
      try {
        let selectStr = `
          id, title, slug,
          brand:brands(name, id),
          variants:product_variants(id, price_bdt, compare_at_bdt, stock_qty, strap),
          images:product_images(url, is_primary)
        `;

        if (collectionSlug) {
          selectStr += `,
            product_collections!inner(
              collection:collections!inner(slug)
            )
          `;
        }

        let query = supabase
          .from('products')
          .select(selectStr);

        if (q) {
          query = query.or(`title.ilike.%${q}%, model.ilike.%${q}%`);
        }

        if (collectionSlug) {
          query = query.eq('product_collections.collection.slug', collectionSlug);
        }

        if (selectedBrands.length > 0) {
          query = query.in('brand_id', selectedBrands);
        }

        const { data, error } = await query;

        if (error) throw error;

        if (data) {
          let formatted = data.map((p: any) => {
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
              image: primaryImage?.url || `https://picsum.photos/400/500?random=${p.id}`,
              type: primaryVariant?.strap
            };
          });

          if (sortBy === 'price-low') formatted.sort((a, b) => a.price - b.price);
          if (sortBy === 'price-high') formatted.sort((a, b) => b.price - a.price);

          setProducts(formatted);
        }
      } catch (err: any) {
        console.error('Error fetching products:', err.message || err);
      } finally {
        setIsLoading(false);
      }
    }
    fetchProducts();
  }, [collectionSlug, q, sortBy, selectedBrands]);

  return (
    <PageTransition>
      {/* Hero / Header Section */}
      <div className="bg-white border-b border-slate-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-20 text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <span className="text-orange-500 font-bold uppercase tracking-[0.3em] text-[10px] mb-4 block">
              Premium Collection
            </span>
            <h1 className="text-4xl md:text-6xl font-black tracking-tighter text-slate-900 mb-6 uppercase">
              {q ? `Search: "${q}"` : collectionSlug ? collectionSlug.split('-').join(' ') : 'All Timepieces'}
            </h1>
            <p className="text-slate-500 max-w-lg mx-auto font-light text-sm md:text-base leading-relaxed">
              Discover our curated selection of verified authentic timepieces, sourced directly from authorized global distributors.
            </p>
          </motion.div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {/* Mobile Filter & Sort Bar */}
        <div className="lg:hidden mb-8 sticky top-[70px] z-30 bg-white/95 backdrop-blur-md border-b border-slate-100 -mx-4 px-4 py-4 flex justify-between items-center">
          <button
            onClick={() => document.getElementById('mobile-filters')?.classList.remove('translate-x-full')}
            className="flex items-center space-x-2 text-xs font-bold uppercase tracking-widest text-slate-900"
          >
            <span className="w-4 h-4 border border-slate-900 flex flex-col justify-center items-center gap-[2px]">
              <span className="w-2 h-[1px] bg-slate-900"></span>
              <span className="w-2 h-[1px] bg-slate-900"></span>
              <span className="w-2 h-[1px] bg-slate-900"></span>
            </span>
            <span>Filter & Sort</span>
          </button>
          <span className="text-[10px] font-bold text-slate-400 uppercase tracking-widest">
            {products.length} Items
          </span>
        </div>

        {/* Mobile Filter Drawer (Off-canvas) */}
        <div id="mobile-filters" className="fixed inset-0 z-[60] bg-white transform translate-x-full transition-transform duration-300 lg:hidden flex flex-col">
          <div className="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50">
            <h2 className="text-xl font-bold tracking-tighter uppercase">Filters</h2>
            <button
              onClick={() => document.getElementById('mobile-filters')?.classList.add('translate-x-full')}
              className="p-2 hover:bg-slate-200 rounded-full transition-colors"
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
          </div>
          <div className="flex-grow overflow-y-auto p-6 space-y-10 custom-scrollbar">
            {/* Sort (Mobile) */}
            <div>
              <h3 className="text-xs font-black uppercase tracking-[0.2em] text-slate-900 mb-6">Sort By</h3>
              <div className="space-y-3">
                {[
                  { label: 'Newest Arrivals', value: 'newest' },
                  { label: 'Price: Low to High', value: 'price-low' },
                  { label: 'Price: High to Low', value: 'price-high' }
                ].map(opt => (
                  <label key={opt.value} className="flex items-center justify-between group cursor-pointer p-2 hover:bg-slate-50 rounded-sm">
                    <span className={`text-sm font-medium transition-colors ${sortBy === opt.value ? 'text-slate-900' : 'text-slate-500'}`}>{opt.label}</span>
                    <input
                      type="radio"
                      name="sort_mobile"
                      checked={sortBy === opt.value}
                      onChange={() => setSortBy(opt.value)}
                      className="accent-slate-900 w-4 h-4"
                    />
                  </label>
                ))}
              </div>
            </div>

            {/* Brands (Mobile) */}
            <div>
              <h3 className="text-xs font-black uppercase tracking-[0.2em] text-slate-900 mb-6">Brands</h3>
              <div className="space-y-3">
                {brands.map(brand => (
                  <label key={brand.id} className="flex items-center justify-between group cursor-pointer p-2 hover:bg-slate-50 rounded-sm">
                    <span className={`text-sm font-medium transition-colors ${selectedBrands.includes(brand.id) ? 'text-slate-900' : 'text-slate-500'}`}>{brand.name}</span>
                    <div className={`w-5 h-5 border flex items-center justify-center transition-colors ${selectedBrands.includes(brand.id) ? 'bg-slate-900 border-slate-900' : 'border-slate-300'}`}>
                      {selectedBrands.includes(brand.id) && <svg className="w-3 h-3 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>}
                    </div>
                    <input
                      type="checkbox"
                      className="hidden"
                      checked={selectedBrands.includes(brand.id)}
                      onChange={() => setSelectedBrands(prev => prev.includes(brand.id) ? prev.filter(b => b !== brand.id) : [...prev, brand.id])}
                    />
                  </label>
                ))}
              </div>
            </div>
          </div>
          <div className="p-6 border-t border-slate-100 bg-slate-50">
            <button
              onClick={() => document.getElementById('mobile-filters')?.classList.add('translate-x-full')}
              className="w-full bg-slate-900 text-white py-4 font-bold uppercase tracking-widest text-xs hover:bg-black transition-colors"
            >
              Show {products.length} Results
            </button>
          </div>
        </div>

        <div className="flex flex-col lg:flex-row gap-16">
          {/* Desktop Sidebar */}
          <aside className="hidden lg:block w-64 flex-shrink-0">
            <div className="sticky top-32 space-y-12">
              {/* Sort Desktop */}
              <div>
                <h3 className="text-xs font-black uppercase tracking-[0.2em] text-slate-900 mb-6 border-b border-slate-100 pb-2">Sort By</h3>
                <div className="space-y-2">
                  {[
                    { label: 'Newest Arrivals', value: 'newest' },
                    { label: 'Price: Low to High', value: 'price-low' },
                    { label: 'Price: High to Low', value: 'price-high' }
                  ].map(opt => (
                    <button
                      key={opt.value}
                      onClick={() => setSortBy(opt.value)}
                      className={`block w-full text-left text-sm py-1 transition-all duration-300 ${sortBy === opt.value ? 'font-bold text-slate-900 pl-2 border-l-2 border-orange-500' : 'text-slate-500 hover:text-slate-900'}`}
                    >
                      {opt.label}
                    </button>
                  ))}
                </div>
              </div>

              {/* Brands Desktop */}
              <div>
                <h3 className="text-xs font-black uppercase tracking-[0.2em] text-slate-900 mb-6 border-b border-slate-100 pb-2">Brands</h3>
                <div className="space-y-3">
                  {brands.map(brand => (
                    <label key={brand.id} className="flex items-center space-x-3 text-sm group cursor-pointer">
                      <div className={`w-4 h-4 border transition-all duration-300 flex items-center justify-center ${selectedBrands.includes(brand.id) ? 'bg-slate-900 border-slate-900' : 'border-slate-300 group-hover:border-slate-500'}`}>
                        {selectedBrands.includes(brand.id) && <svg className="w-2 h-2 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>}
                      </div>
                      <input
                        type="checkbox"
                        className="hidden"
                        checked={selectedBrands.includes(brand.id)}
                        onChange={() => setSelectedBrands(prev => prev.includes(brand.id) ? prev.filter(b => b !== brand.id) : [...prev, brand.id])}
                      />
                      <span className={`transition-colors ${selectedBrands.includes(brand.id) ? 'font-bold text-slate-900' : 'text-slate-500 group-hover:text-slate-900'}`}>{brand.name}</span>
                    </label>
                  ))}
                </div>
              </div>

              {/* Reset Filters */}
              {(selectedBrands.length > 0) && (
                <button
                  onClick={() => { setSelectedBrands([]); }}
                  className="text-xs font-bold text-red-500 hover:text-red-600 uppercase tracking-widest border-b border-red-200 pb-0.5"
                >
                  Clear All Filters
                </button>
              )}
            </div>
          </aside>

          {/* Product Grid */}
          <div className="flex-grow">
            {isLoading ? (
              <div className="grid grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-x-6 gap-y-10">
                {[1, 2, 3, 4, 5, 6, 7, 8].map(i => <div key={i} className="aspect-[1/1.2] bg-slate-100 animate-pulse rounded-sm" />)}
              </div>
            ) : products.length > 0 ? (
              <>
                <div className="hidden lg:flex justify-between items-end mb-8 border-b border-slate-100 pb-4">
                  <span className="text-xs font-bold uppercase tracking-widest text-slate-500">
                    Showing <span className="text-slate-900">{products.length}</span> results
                  </span>
                </div>

                <motion.div
                  className="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-x-4 md:gap-x-6 gap-y-10 md:gap-y-12"
                  initial="hidden"
                  animate="visible"
                  variants={{
                    hidden: { opacity: 0 },
                    visible: {
                      opacity: 1,
                      transition: { staggerChildren: 0.05 }
                    }
                  }}
                >
                  <AnimatePresence mode='popLayout'>
                    {products.map(product => (
                      <motion.div
                        key={product.id}
                        layout
                        initial={{ opacity: 0, scale: 0.95 }}
                        animate={{ opacity: 1, scale: 1 }}
                        exit={{ opacity: 0, scale: 0.95 }}
                        transition={{ duration: 0.4, ease: "easeOut" }}
                      >
                        <ProductCard {...product} />
                      </motion.div>
                    ))}
                  </AnimatePresence>
                </motion.div>
              </>
            ) : (
              <div className="flex flex-col items-center justify-center py-32 bg-slate-50 rounded-sm">
                <div className="w-16 h-16 bg-white rounded-full flex items-center justify-center mb-6 shadow-sm">
                  <svg className="w-8 h-8 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                </div>
                <h3 className="text-lg font-bold text-slate-900 mb-2">No watches found</h3>
                <p className="text-slate-500 font-light mb-8 max-w-xs text-center">We couldn't find matches for your current filters.</p>
                <button
                  onClick={() => { setSelectedBrands([]); setSortBy('newest'); }}
                  className="px-8 py-3 bg-slate-900 text-white text-xs font-bold uppercase tracking-widest hover:bg-black transition-colors"
                >
                  Clear All Filters
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </PageTransition>
  );
};
