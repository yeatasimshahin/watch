
import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useWishlist } from '../context/WishlistContext';
import { useCart } from '../context/CartContext';
import { formatCurrency } from '../lib/utils';
import { Icon } from './Icon';
import { FiHeart, FiShoppingBag, FiCheck, FiArrowRight } from 'react-icons/fi';
import { motion } from 'framer-motion';

interface ProductCardProps {
  id: string;
  slug: string;
  title: string;
  brand: string;
  price: number;
  compareAt?: number;
  image: string;
  badges?: string[];
  // New props for Quick Add
  variantId?: string;
  sku?: string;
  stock?: number;
  model?: string;
}

export const ProductCard: React.FC<ProductCardProps> = ({
  id,
  slug,
  title,
  brand,
  price,
  compareAt,
  image,
  badges,
  variantId,
  sku,
  stock = 0,
  model
}) => {
  const navigate = useNavigate();
  const { toggleWishlist, isInWishlist } = useWishlist();
  const { addToCart } = useCart();

  const [isAdding, setIsAdding] = useState(false);
  const [justAdded, setJustAdded] = useState(false);

  const handleQuickAdd = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    if (!variantId) {
      navigate(`/p/${slug}`);
      return;
    }

    setIsAdding(true);
    addToCart({
      variant_id: variantId,
      product_id: id,
      sku: sku || 'N/A',
      qty: 1,
      title: title,
      model: model || 'Standard',
      brand_name: brand,
      price: price,
      image: image,
      stock: stock
    });

    setTimeout(() => {
      setIsAdding(false);
      setJustAdded(true);
      setTimeout(() => setJustAdded(false), 2000);
    }, 500);
  };

  const isOutOfStock = stock === 0 && variantId !== undefined;

  return (
    <motion.div
      className="group relative bg-white flex flex-col h-full overflow-hidden"
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5 }}
    >
      {/* Image Container */}
      <div className="relative aspect-[1/1.2] overflow-hidden bg-[#F8F8F8]">
        <Link to={`/p/${slug}`} className="block w-full h-full">
          <motion.img
            src={image || `https://picsum.photos/400/500?random=${id}`}
            alt={title}
            className="h-full w-full object-cover object-center transition-transform duration-1000 group-hover:scale-110"
            loading="lazy"
          />
        </Link>

        {/* Badges - Minimalist */}
        <div className="absolute top-4 left-4 flex flex-col gap-2 z-10">
          {compareAt && compareAt > price && (
            <span className="bg-[#FF8C00] text-white text-[9px] font-black px-2 py-1 uppercase tracking-widest">
              {Math.round(((compareAt - price) / compareAt) * 100)}% OFF
            </span>
          )}
          {isOutOfStock && (
            <span className="bg-black text-white text-[9px] font-black px-2 py-1 uppercase tracking-widest">
              Sold Out
            </span>
          )}
        </div>

        {/* Floating Wishlist Icon */}
        <div className="absolute top-4 right-4 z-10 translate-x-4 opacity-0 group-hover:translate-x-0 group-hover:opacity-100 transition-all duration-300">
          <button
            onClick={(e) => { e.preventDefault(); toggleWishlist(id); }}
            className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors ${isInWishlist(id) ? 'bg-[#FF8C00] text-white' : 'bg-white hover:bg-slate-50 text-black'
              } shadow-lg`}
          >
            <Icon icon={FiHeart} size={18} className={isInWishlist(id) ? "fill-current" : ""} />
          </button>
        </div>

        {/* Modern Quick Add - Solar Orange theme */}
        <div className="absolute bottom-0 inset-x-0 translate-y-full group-hover:translate-y-0 transition-transform duration-500 z-20">
          <button
            onClick={handleQuickAdd}
            disabled={isOutOfStock || isAdding}
            className={`w-full py-5 text-[10px] font-black uppercase tracking-[0.3em] transition-all duration-500 flex items-center justify-center space-x-2 ${justAdded ? 'bg-green-600 text-white' : isOutOfStock ? 'bg-slate-200 text-slate-400 cursor-not-allowed' : 'bg-black text-white hover:bg-[#FF8C00]'
              }`}
          >
            {justAdded ? (
              <>
                <Icon icon={FiCheck} size={14} />
                <span>Added to Bag</span>
              </>
            ) : isAdding ? (
              <span className="animate-pulse">Processing...</span>
            ) : isOutOfStock ? (
              <span>Unavailable</span>
            ) : (
              <>
                <Icon icon={FiShoppingBag} size={14} className="group-hover:translate-y-[-1px] transition-transform" />
                <span>Quick Add</span>
              </>
            )}
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="p-6 flex flex-col flex-grow bg-white">
        <div className="flex justify-between items-start mb-2">
          <span className="text-[9px] font-black uppercase tracking-[0.3em] text-[#FF8C00]">{brand}</span>
          <div className="flex flex-col items-end">
            {compareAt && compareAt > price && (
              <span className="text-[10px] text-slate-400 line-through decoration-slate-300">{formatCurrency(compareAt)}</span>
            )}
            <span className="text-sm font-black text-black">{formatCurrency(price)}</span>
          </div>
        </div>

        <h3 className="text-base font-bold text-black leading-tight group-hover:text-[#FF8C00] transition-colors line-clamp-2">
          <Link to={`/p/${slug}`}>
            {title}
          </Link>
        </h3>

        <div className="mt-4 pt-4 border-t border-slate-50 flex items-center text-[10px] font-bold uppercase tracking-widest text-slate-400 group-hover:text-black transition-colors">
          <span>View Details</span>
          <Icon icon={FiArrowRight} size={12} className="ml-2 translate-x-[-4px] opacity-0 group-hover:translate-x-0 group-hover:opacity-100 transition-all" />
        </div>
      </div>
    </motion.div>
  );
};
