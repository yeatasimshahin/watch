
import React, { useEffect, useState } from 'react';
import { supabase } from '../lib/supabase';
import { Icon } from './Icon';
import { FiCopy, FiCheck } from 'react-icons/fi';
import { MarqueeSettings } from '../types';

export const PromoMarquee: React.FC = () => {
  const [settings, setSettings] = useState<MarqueeSettings | null>(null);
  const [loading, setLoading] = useState(true);
  const [copied, setCopied] = useState(false);
  const [isValid, setIsValid] = useState(false);

  useEffect(() => {
    const fetchMarquee = async () => {
      try {
        // 1. Fetch settings
        const { data: settingsData } = await supabase
          .from('site_settings')
          .select('value')
          .eq('key', 'promo.marquee')
          .maybeSingle();

        if (settingsData && settingsData.value?.enabled) {
          const config = settingsData.value as MarqueeSettings;

          // 2. Validate Coupon existence & dates
          // We don't just trust the setting, we ensure the coupon is actually valid currently
          const { data: coupon } = await supabase
            .from('coupons')
            .select('is_active, starts_at, ends_at')
            .eq('code', config.coupon_code)
            .single();

          if (coupon && coupon.is_active) {
            const now = new Date();
            const start = coupon.starts_at ? new Date(coupon.starts_at) : null;
            const end = coupon.ends_at ? new Date(coupon.ends_at) : null;

            if ((!start || now >= start) && (!end || now <= end)) {
              setSettings(config);
              setIsValid(true);
            }
          }
        }
      } catch (err) {
        console.error('Marquee fetch error', err);
      } finally {
        setLoading(false);
      }
    };

    fetchMarquee();
  }, []);

  const handleCopy = () => {
    if (settings?.coupon_code) {
      navigator.clipboard.writeText(settings.coupon_code);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  if (loading || !isValid || !settings) return null;

  return (
    <div className="bg-slate-900 text-white overflow-hidden relative z-50 h-10 flex items-center justify-center">
      <div className="flex items-center space-x-4 animate-in fade-in duration-500">
        {/* Simple text display for cleaner UX than rapid scrolling for a single message */}
        <span className="text-[10px] md:text-xs font-bold uppercase tracking-widest flex items-center">
          {settings.message}
        </span>
        <button
          onClick={handleCopy}
          className="ml-4 flex items-center gap-2 bg-white/10 hover:bg-white/20 px-3 py-1 rounded-sm transition-colors text-[10px] font-bold uppercase tracking-widest border border-white/10"
        >
          {copied ? (
            <>
              <Icon icon={FiCheck} size={12} className="text-green-400" /> Copied
            </>
          ) : (
            <>
              <Icon icon={FiCopy} size={12} /> {settings.coupon_code}
            </>
          )}
        </button>
      </div>
    </div>
  );
};
