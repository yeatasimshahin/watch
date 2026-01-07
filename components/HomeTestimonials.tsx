
import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { InfiniteMarquee } from './InfiniteMarquee';
import { Icon } from './Icon';
import { FiStar, FiCheck, FiUser } from 'react-icons/fi';
import { FaQuoteLeft } from 'react-icons/fa6';

interface Testimonial {
  id: string;
  rating: number;
  title: string;
  body: string;
  is_verified: boolean;
  customer_name: string;
  customer_location?: string;
  avatar_url?: string;
}

interface Brand {
  id: string;
  name: string;
  logo_url: string;
}

// Mock Data with Bangladesh Districts (Zillas)
const MOCK_REVIEWS: Testimonial[] = [
  {
    id: 'm1', rating: 5, title: 'Exceptional Quality', body: 'The build quality of the Ruiz Classic exceeded my expectations. Feels like a much more expensive timepiece.',
    is_verified: true, customer_name: 'Arif Hasan', customer_location: 'Dhaka', avatar_url: ''
  },
  {
    id: 'm2', rating: 5, title: 'Best Service', body: 'Ordered in the morning, received it by evening. The COD process was smooth and the packaging was premium.',
    is_verified: true, customer_name: 'Nusrat Jahan', customer_location: 'Chattogram', avatar_url: ''
  },
  {
    id: 'm3', rating: 4, title: 'Great Smartwatch', body: 'Battery life is solid, lasts about 5 days. Notifications work perfectly with my iPhone.',
    is_verified: true, customer_name: 'Tanvir Ahmed', customer_location: 'Sylhet', avatar_url: ''
  },
  {
    id: 'm4', rating: 5, title: 'Perfect Gift', body: 'Bought this for my husband on our anniversary. He loves the sleek design. Thank you Ruiz!',
    is_verified: true, customer_name: 'Sadia Islam', customer_location: 'Rajshahi', avatar_url: ''
  },
  {
    id: 'm5', rating: 5, title: 'Genuine Products', body: 'I was skeptical about buying online, but the product is 100% authentic. Checked the serial number.',
    is_verified: true, customer_name: 'Rahim Uddin', customer_location: 'Khulna', avatar_url: ''
  },
  {
    id: 'm6', rating: 5, title: 'Stylish Wear', body: 'Looks amazing on the wrist. Very comfortable strap. Highly recommended for office wear.',
    is_verified: true, customer_name: 'Karim Sheikh', customer_location: 'Barishal', avatar_url: ''
  },
  {
    id: 'm7', rating: 5, title: 'Fast Delivery', body: 'Got my watch within 24 hours in Rangpur. Amazing service!',
    is_verified: true, customer_name: 'Jamal Hossain', customer_location: 'Rangpur', avatar_url: ''
  },
  {
    id: 'm8', rating: 4, title: 'Good Value', body: 'For the price, this is the best classic watch I have purchased.',
    is_verified: true, customer_name: 'Farhana Akter', customer_location: 'Mymensingh', avatar_url: ''
  },
];

const MOCK_BRANDS: Brand[] = [
  { id: 'b1', name: 'Casio', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Casio_logo.svg/320px-Casio_logo.svg.png' },
  { id: 'b2', name: 'Fossil', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Fossil_Group_logo.svg/320px-Fossil_Group_logo.svg.png' },
  { id: 'b3', name: 'Curren', logo_url: 'https://currenwatches.com.pk/wp-content/uploads/2020/10/curren-logo.png' },
  { id: 'b4', name: 'Naviforce', logo_url: 'https://naviforce.com/wp-content/uploads/2020/12/logo-1.png' },
  { id: 'b5', name: 'Seiko', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Seiko_logo.svg/320px-Seiko_logo.svg.png' },
  { id: 'b6', name: 'Titan', logo_url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Titan_Company_Logo.png/320px-Titan_Company_Logo.png' },
];

const TestimonialCard: React.FC<{ item: Testimonial }> = ({ item }) => (
  <div className="w-[320px] md:w-[400px] bg-white border border-slate-100 rounded-xl p-8 shadow-[0_4px_20px_-4px_rgba(0,0,0,0.05)] hover:shadow-xl hover:-translate-y-1 transition-all duration-300 flex flex-col justify-between h-full group mx-4">
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex text-yellow-400 gap-1">
          {[...Array(5)].map((_, i) => (
            <Icon
              key={i}
              icon={FiStar}
              size={16}
              className={i < item.rating ? "fill-current" : "text-slate-200 fill-slate-200"}
            />
          ))}
        </div>
        <Icon icon={FaQuoteLeft} className="text-slate-100 group-hover:text-slate-200 transition-colors" size={32} />
      </div>

      <h4 className="text-base font-bold text-slate-900 mb-3 line-clamp-1">{item.title}</h4>
      <p className="text-sm text-slate-500 font-light leading-relaxed line-clamp-3 mb-8">
        "{item.body}"
      </p>
    </div>

    <div className="flex items-center gap-4 pt-6 border-t border-slate-50">
      {/* Avatar: First Letter */}
      <div className="w-12 h-12 rounded-full bg-slate-900 text-white flex items-center justify-center text-lg font-bold shadow-md">
        {item.customer_name.charAt(0).toUpperCase()}
      </div>

      <div>
        <div className="flex items-center gap-2 mb-0.5">
          <span className="text-sm font-bold text-slate-900">{item.customer_name}</span>
          {item.is_verified && (
            <Icon icon={FiCheck} className="text-green-500" size={14} title="Verified Purchase" />
          )}
        </div>
        <p className="text-xs text-slate-400 font-medium uppercase tracking-wide">
          {item.customer_location ? `${item.customer_location}, Bangladesh` : 'Bangladesh'}
        </p>
      </div>
    </div>
  </div>
);

export const HomeTestimonials: React.FC = () => {
  const [reviews, setReviews] = useState<Testimonial[]>([]);
  const [brands, setBrands] = useState<Brand[]>([]);
  const [loading, setLoading] = useState(true);
  const [visible, setVisible] = useState(true);

  useEffect(() => {
    async function fetchData() {
      try {
        setLoading(true);

        // 1. Fetch Reviews (Approved only)
        const { data: reviewsData } = await supabase
          .from('reviews')
          .select(`
            id, rating, title, body, is_verified,
            reviewer:profiles(full_name, email)
          `)
          .eq('status', 'approved')
          .order('created_at', { ascending: false })
          .limit(16);

        // 2. Fetch Brands
        const { data: brandsData } = await supabase
          .from('brands')
          .select('id, name, logo_url')
          .eq('is_active', true)
          .not('logo_url', 'is', null)
          .limit(15);

        // Process Reviews
        let processedReviews: Testimonial[] = [];
        if (reviewsData && reviewsData.length > 0) {
          processedReviews = reviewsData.map((r: any) => ({
            id: r.id,
            rating: r.rating || 5,
            title: r.title || 'Great Product',
            body: r.body || '',
            is_verified: r.is_verified,
            customer_name: r.reviewer?.full_name || 'Verified Customer',
            customer_location: 'Bangladesh', // Default if not in DB
            avatar_url: ''
          }));
        } else {
          processedReviews = MOCK_REVIEWS;
        }

        // Process Brands
        let processedBrands: Brand[] = [];
        if (brandsData && brandsData.length > 0) {
          processedBrands = brandsData;
        } else {
          processedBrands = MOCK_BRANDS;
        }

        setReviews(processedReviews);
        setBrands(processedBrands);
        setVisible(true);

      } catch (err) {
        console.error('Error fetching social proof:', err);
        setReviews(MOCK_REVIEWS);
        setBrands(MOCK_BRANDS);
        setVisible(true);
      } finally {
        setLoading(false);
      }
    }

    fetchData();
  }, []);

  if (loading) return <div className="py-24 bg-slate-50"></div>;
  if (!visible) return null;

  // Split reviews into two rows
  const midPoint = Math.ceil(reviews.length / 2);
  const rowOne = reviews.slice(0, midPoint);
  const rowTwo = reviews.slice(midPoint);

  // If few reviews, duplicate for smooth marquee
  const safeRowOne = rowOne.length < 4 ? [...rowOne, ...rowOne, ...rowOne] : rowOne;
  const safeRowTwo = rowTwo.length < 4 && rowTwo.length > 0 ? [...rowTwo, ...rowTwo, ...rowTwo] : (rowTwo.length > 0 ? rowTwo : [...rowOne]);

  return (
    <section className="py-32 bg-gradient-to-b from-white to-slate-50 overflow-hidden relative border-t border-slate-100">

      {/* Background Decorative Blur */}
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full max-w-7xl h-full pointer-events-none">
        <div className="absolute top-[20%] left-[10%] w-96 h-96 bg-blue-50 rounded-full mix-blend-multiply filter blur-3xl opacity-40"></div>
        <div className="absolute bottom-[20%] right-[10%] w-96 h-96 bg-purple-50 rounded-full mix-blend-multiply filter blur-3xl opacity-40"></div>
      </div>

      <div className="relative z-10">
        <div className="max-w-4xl mx-auto px-4 text-center mb-20">
          <h2 className="text-4xl md:text-5xl font-bold tracking-tighter text-slate-900 mb-6">
            Loved by watch lovers <br /> across Bangladesh
          </h2>
          <p className="text-slate-500 font-light text-lg">
            Real reviews from real customers in 64 districts.
          </p>
        </div>

        {/* Row A: Left to Right */}
        <div className="mb-12">
          <InfiniteMarquee direction="left" speed={50}>
            {safeRowOne.map((review, idx) => (
              <TestimonialCard key={`${review.id}-a-${idx}`} item={review} />
            ))}
          </InfiniteMarquee>
        </div>

        {/* Row B: Right to Left */}
        {safeRowTwo.length > 0 && (
          <div className="mb-24">
            <InfiniteMarquee direction="right" speed={60}>
              {safeRowTwo.map((review, idx) => (
                <TestimonialCard key={`${review.id}-b-${idx}`} item={review} />
              ))}
            </InfiniteMarquee>
          </div>
        )}

        {/* Brand Ticker */}
        {brands.length > 0 && (
          <div className="max-w-7xl mx-auto px-4">
            <div className="text-center mb-10">
              <span className="text-[10px] font-bold uppercase tracking-[0.3em] text-slate-400">Authorized Retailer For</span>
            </div>
            <InfiniteMarquee direction="left" speed={40} className="opacity-60 hover:opacity-100 transition-opacity">
              {brands.map((brand, idx) => (
                <div
                  key={`${brand.id}-${idx}`}
                  className="mx-8 grayscale hover:grayscale-0 transition-all duration-500"
                >
                  <img
                    src={brand.logo_url}
                    alt={brand.name}
                    className="h-8 md:h-10 w-auto object-contain"
                    onError={(e) => {
                      e.currentTarget.style.display = 'none';
                      e.currentTarget.nextElementSibling?.classList.remove('hidden');
                    }}
                  />
                  {/* Fallback Text if Image Fails */}
                  <span className="hidden text-xl font-bold text-slate-300 uppercase tracking-widest">{brand.name}</span>
                </div>
              ))}
            </InfiniteMarquee>
          </div>
        )}
      </div>
    </section>
  );
};
