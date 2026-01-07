
import React, { useState, useEffect, useMemo } from 'react';
import { supabase } from '../lib/supabase';
import { useAuth } from '../context/AuthContext';
import { formatCurrency, formatDate } from '../lib/utils';
import { Icon } from '../components/Icon';
import {
  FiPlus, FiDownload, FiSearch, FiEdit3, FiCopy,
  FiTrash2, FiX, FiCheck, FiAlertCircle,
  FiPercent, FiDollarSign, FiRefreshCcw, FiBell, FiLock, FiCalendar, FiUsers, FiTag
} from 'react-icons/fi';
import { motion, AnimatePresence } from 'framer-motion';
import { Coupon, CouponEntitlement, MarqueeSettings } from '../types';

const ADMIN_ROLES = ['super_admin', 'order_manager'];
const SUPER_ADMIN_ROLE = 'super_admin';

// --- COMPONENTS (Shadcn-like) ---

const Badge: React.FC<{ children: React.ReactNode; variant?: 'default' | 'outline' | 'secondary' | 'destructive' | 'success' }> = ({ children, variant = 'default' }) => {
  const styles = {
    default: 'bg-slate-900 text-white border-transparent',
    outline: 'text-slate-900 border-slate-200',
    secondary: 'bg-slate-100 text-slate-900 border-transparent',
    destructive: 'bg-red-50 text-red-600 border-red-100',
    success: 'bg-green-50 text-green-700 border-green-100'
  };
  return (
    <span className={`inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-slate-400 focus:ring-offset-2 ${styles[variant]}`}>
      {children}
    </span>
  );
};

// --- MAIN PAGE ---

export const AdminCoupons: React.FC = () => {
  const { user } = useAuth();

  // Data
  const [coupons, setCoupons] = useState<Coupon[]>([]);
  const [loading, setLoading] = useState(true);
  const [userRoles, setUserRoles] = useState<string[]>([]);
  const [marqueeSettings, setMarqueeSettings] = useState<MarqueeSettings | null>(null);

  // Filters
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<'all' | 'active' | 'inactive'>('all');
  const [typeFilter, setTypeFilter] = useState<'all' | 'percent' | 'fixed'>('all');

  // Dialog State
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [editingCoupon, setEditingCoupon] = useState<Coupon | null>(null);
  const [dialogLoading, setDialogLoading] = useState(false);
  const [activeTab, setActiveTab] = useState<'general' | 'restrictions' | 'marketing'>('general');

  // Form State
  const [formData, setFormData] = useState<Partial<Coupon>>({
    code: '',
    discount_type: 'fixed',
    amount: 0,
    min_subtotal: 0,
    max_uses: null,
    max_uses_per_user: null,
    starts_at: null,
    ends_at: null,
    is_active: true
  });

  // Entitlements State
  const [allowedEmails, setAllowedEmails] = useState<string[]>([]);
  const [newEmail, setNewEmail] = useState('');

  // Marquee State
  const [showInMarquee, setShowInMarquee] = useState(false);
  const [marqueeMessage, setMarqueeMessage] = useState('');

  // --- 1. INITIALIZATION ---

  useEffect(() => {
    if (user) {
      fetchRoles();
      fetchCoupons();
      fetchMarqueeSettings();
    }
  }, [user]);

  const fetchRoles = async () => {
    if (!user) return;
    const { data } = await supabase.from('user_roles').select('role:roles(name)').eq('user_id', user.id);
    const roles = data?.map((r: any) => r.role?.name) || [];
    setUserRoles(roles);
  };

  const fetchMarqueeSettings = async () => {
    const { data } = await supabase.from('site_settings').select('value').eq('key', 'promo.marquee').maybeSingle();
    if (data?.value) {
      setMarqueeSettings(data.value);
    }
  };

  const fetchCoupons = async () => {
    setLoading(true);
    try {
      // Fetch coupons and join orders to count usage
      const { data, error } = await supabase
        .from('coupons')
        .select(`
          *,
          orders:orders(count)
        `)
        .order('created_at', { ascending: false });

      if (error) throw error;

      // Transform data to include usage_count (Supabase raw result structure might vary depending on setup, handling count properly)
      // Note: Assuming count() works as aggregate or is manual. If raw postgrest doesn't return count object easily without group by, 
      // usually we'd need separate query or RPC. For now assuming simple join returns array we count length of.
      const formatted: any[] = (data || []).map((c: any) => ({
        ...c,
        discount_value: c.amount, // Map DB 'amount' to UI 'discount_value'
        usage_count: c.orders?.[0]?.count || 0
      }));

      setCoupons(formatted);
    } catch (err) {
      console.error('Error fetching coupons:', err);
    } finally {
      setLoading(false);
    }
  };

  // --- 2. ACTIONS ---

  const handleCreate = () => {
    setEditingCoupon(null);
    setFormData({
      code: '',
      discount_type: 'fixed',
      discount_value: 0,
      min_subtotal: 0,
      max_uses: null,
      max_uses_per_user: null,
      starts_at: null,
      ends_at: null,
      is_active: true
    });
    setAllowedEmails([]);
    setShowInMarquee(false);
    setMarqueeMessage('');
    setActiveTab('general');
    setIsDialogOpen(true);
  };

  const handleEdit = async (coupon: Coupon) => {
    setEditingCoupon(coupon);
    setFormData({
      code: coupon.code,
      discount_type: coupon.discount_type,
      amount: coupon.amount,
      min_subtotal: coupon.min_subtotal,
      max_uses: coupon.max_uses,
      max_uses_per_user: coupon.max_uses_per_user,
      starts_at: coupon.starts_at ? new Date(coupon.starts_at).toISOString().slice(0, 16) : null,
      ends_at: coupon.ends_at ? new Date(coupon.ends_at).toISOString().slice(0, 16) : null,
      is_active: coupon.is_active
    });

    // Fetch Entitlements
    const { data: entitlements } = await supabase
      .from('coupon_entitlements')
      .select('email')
      .eq('coupon_id', coupon.id);

    setAllowedEmails(entitlements?.map(e => e.email) || []);

    // Check Marquee
    if (marqueeSettings && marqueeSettings.enabled && marqueeSettings.coupon_code === coupon.code) {
      setShowInMarquee(true);
      setMarqueeMessage(marqueeSettings.message);
    } else {
      setShowInMarquee(false);
      setMarqueeMessage(`${coupon.code} — Tap to copy`);
    }

    setIsDialogOpen(true);
  };

  const handleAddEmail = () => {
    if (newEmail && newEmail.includes('@')) {
      if (!allowedEmails.includes(newEmail.toLowerCase())) {
        setAllowedEmails([...allowedEmails, newEmail.toLowerCase()]);
      }
      setNewEmail('');
    }
  };

  const handleRemoveEmail = (email: string) => {
    setAllowedEmails(allowedEmails.filter(e => e !== email));
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setDialogLoading(true);

    try {
      // Validate
      if (!formData.code) throw new Error("Code is required");
      if (formData.amount! <= 0) throw new Error("Value must be greater than 0");
      if (formData.discount_type === 'percent' && formData.amount! > 100) throw new Error("Percentage cannot exceed 100%");

      const payload = {
        code: formData.code.toUpperCase().replace(/\s+/g, ''),
        discount_type: formData.discount_type,
        amount: formData.amount, // DB column is 'amount'
        min_subtotal: formData.min_subtotal || 0,
        max_uses: formData.max_uses || null,
        max_uses_per_user: formData.max_uses_per_user || null,
        starts_at: formData.starts_at || null,
        ends_at: formData.ends_at || null,
        is_active: formData.is_active
      };

      let couponId = editingCoupon?.id;

      if (editingCoupon) {
        const { error } = await supabase.from('coupons').update(payload).eq('id', editingCoupon.id);
        if (error) throw error;
      } else {
        const { data, error } = await supabase.from('coupons').insert(payload).select().single();
        if (error) throw error;
        couponId = data.id;
      }

      // Handle Entitlements
      if (couponId) {
        // Delete existing
        await supabase.from('coupon_entitlements').delete().eq('coupon_id', couponId);

        // Insert new
        if (allowedEmails.length > 0) {
          const entRows = allowedEmails.map(email => ({
            coupon_id: couponId,
            email: email
          }));
          await supabase.from('coupon_entitlements').insert(entRows);
        }
      }

      // Handle Marquee
      if (showInMarquee) {
        const settingsPayload = {
          enabled: true,
          coupon_code: payload.code,
          message: marqueeMessage || `${payload.code} — Tap to copy`
        };
        await supabase.from('site_settings').upsert({
          key: 'promo.marquee',
          value: settingsPayload,
          updated_at: new Date().toISOString()
        });
        setMarqueeSettings(settingsPayload);
      } else if (marqueeSettings?.coupon_code === payload.code) {
        // If it was marquee and now disabled
        const settingsPayload = { ...marqueeSettings, enabled: false };
        await supabase.from('site_settings').upsert({
          key: 'promo.marquee',
          value: settingsPayload,
          updated_at: new Date().toISOString()
        });
        setMarqueeSettings(settingsPayload);
      }

      await fetchCoupons();
      setIsDialogOpen(false);
    } catch (err: any) {
      alert(`Error saving coupon: ${err.message}`);
    } finally {
      setDialogLoading(false);
    }
  };

  const handleDuplicate = async (coupon: Coupon) => {
    const newCode = `${coupon.code}_COPY_${Math.floor(Math.random() * 1000)}`;
    try {
      const { error } = await supabase.from('coupons').insert({
        code: newCode,
        discount_type: coupon.discount_type,
        amount: coupon.amount, // Map UI 'discount_value' to DB 'amount'
        min_subtotal: coupon.min_subtotal,
        max_uses: coupon.max_uses,
        max_uses_per_user: coupon.max_uses_per_user,
        starts_at: null,
        ends_at: null,
        is_active: false // Draft state
      });
      if (error) throw error;
      await fetchCoupons();
    } catch (err: any) {
      alert(`Error duplicating: ${err.message}`);
    }
  };

  const handleToggleActive = async (coupon: Coupon) => {
    try {
      const { error } = await supabase.from('coupons').update({ is_active: !coupon.is_active }).eq('id', coupon.id);
      if (error) throw error;
      // Optimistic update
      setCoupons(prev => prev.map(c => c.id === coupon.id ? { ...c, is_active: !c.is_active } : c));
    } catch (err: any) {
      alert(`Error updating status: ${err.message}`);
    }
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm("Are you sure you want to delete this coupon? This cannot be undone.")) return;
    try {
      const { error } = await supabase.from('coupons').delete().eq('id', id);
      if (error) throw error;
      setCoupons(prev => prev.filter(c => c.id !== id));
    } catch (err: any) {
      alert(`Error deleting: ${err.message}`);
    }
  };

  const handleExport = () => {
    const headers = ['Code', 'Type', 'Value', 'Min Subtotal', 'Max Uses', 'Starts', 'Ends', 'Active'];
    const rows = filteredData.map(c => [
      c.code,
      c.discount_type,
      c.amount,
      c.min_subtotal,
      c.max_uses || 'Unlimited',
      c.starts_at ? formatDate(c.starts_at) : '-',
      c.ends_at ? formatDate(c.ends_at) : '-',
      c.is_active ? 'Yes' : 'No'
    ]);

    const csvContent = [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `coupons_export_${new Date().toISOString().slice(0, 10)}.csv`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  // --- 3. FILTERING ---

  const filteredData = useMemo(() => {
    return coupons.filter(c => {
      const matchesSearch = c.code.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesStatus = statusFilter === 'all'
        ? true
        : statusFilter === 'active' ? c.is_active : !c.is_active;
      const matchesType = typeFilter === 'all'
        ? true
        : c.discount_type === (typeFilter === 'percent' ? 'percentage' : 'fixed');

      return matchesSearch && matchesStatus && matchesType;
    });
  }, [coupons, searchQuery, statusFilter, typeFilter]);

  // --- 4. ACCESS CONTROL ---
  const isSuperAdmin = userRoles.includes(SUPER_ADMIN_ROLE);
  const canEditRoles = userRoles.some(r => ADMIN_ROLES.includes(r));

  if (!canEditRoles && !loading) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[50vh]">
        <Icon icon={FiAlertCircle} size={48} className="text-slate-300 mb-4" />
        <h2 className="text-xl font-bold text-slate-900">Access Restricted</h2>
        <p className="text-slate-500">You do not have permission to manage coupons.</p>
      </div>
    );
  }

  return (
    <div className="max-w-[1600px] mx-auto animate-in fade-in duration-500 pb-20">

      {/* HEADER */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8">
        <div>
          <h1 className="text-3xl font-black tracking-tight text-slate-900">Coupons</h1>
          <p className="text-sm text-slate-500 mt-2 font-medium">Manage discounts and promotional campaigns.</p>
        </div>
        <div className="flex items-center gap-3">
          <button onClick={fetchCoupons} className="p-3 bg-white border border-slate-200 rounded-sm hover:bg-slate-50 text-slate-600 transition-all shadow-sm">
            <Icon icon={FiRefreshCcw} size={16} />
          </button>
          <button onClick={handleExport} className="hidden sm:flex items-center px-6 py-3 bg-white border border-slate-200 text-slate-600 text-xs font-bold uppercase tracking-widest rounded-sm hover:bg-slate-50 transition-all shadow-sm">
            <Icon icon={FiDownload} className="mr-2" /> Export
          </button>
          <button onClick={handleCreate} className="flex items-center px-6 py-3 bg-slate-900 text-white text-xs font-bold uppercase tracking-widest rounded-sm hover:bg-black transition-all shadow-lg hover:shadow-xl hover:-translate-y-0.5">
            <Icon icon={FiPlus} className="mr-2" /> Create Campaign
          </button>
        </div>
      </div>

      {/* FILTERS */}
      <div className="bg-white border border-slate-100 p-1 mb-8 rounded-sm shadow-sm flex flex-col md:flex-row gap-1">
        <div className="relative flex-grow">
          <Icon icon={FiSearch} className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            placeholder="Search campaigns..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-12 pr-4 py-3 bg-white text-sm font-medium outline-none"
          />
        </div>
        <div className="flex border-t md:border-t-0 md:border-l border-slate-100">
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value as any)}
            className="px-6 py-3 bg-white text-xs font-bold uppercase tracking-widest text-slate-600 outline-none hover:bg-slate-50 cursor-pointer"
          >
            <option value="all">Status: All</option>
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>
          <select
            value={typeFilter}
            onChange={(e) => setTypeFilter(e.target.value as any)}
            className="px-6 py-3 bg-white text-xs font-bold uppercase tracking-widest text-slate-600 outline-none hover:bg-slate-50 cursor-pointer border-l border-slate-100"
          >
            <option value="all">Type: All</option>
            <option value="percent">Percentage</option>
            <option value="fixed">Fixed Amount</option>
          </select>
        </div>
      </div>

      {/* CONTENT GRID/TABLE */}
      {loading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3, 4, 5, 6].map(i => <div key={i} className="h-40 bg-slate-100 animate-pulse rounded-sm" />)}
        </div>
      ) : filteredData.length === 0 ? (
        <div className="text-center py-20 bg-white border border-dashed border-slate-200 rounded-sm">
          <Icon icon={FiTag} className="mx-auto text-slate-300 mb-4" size={48} />
          <h3 className="text-lg font-bold text-slate-900">No campaigns found</h3>
          <p className="text-slate-500 mt-1">Try adjusting your search or filters.</p>
        </div>
      ) : (
        <>
          {/* Mobile Card View */}
          <div className="md:hidden space-y-4">
            {filteredData.map(coupon => (
              <div key={coupon.id} className="bg-white p-5 border border-slate-100 rounded-sm shadow-sm">
                <div className="flex justify-between items-start mb-4">
                  <div>
                    <span className="font-mono text-lg font-bold text-slate-900 bg-slate-50 px-2 py-1 rounded-sm border border-slate-100">{coupon.code}</span>
                    <p className="text-xs text-slate-500 mt-2 font-medium uppercase tracking-wide">{coupon.discount_type}</p>
                  </div>
                  <Badge variant={coupon.is_active ? 'success' : 'secondary'}>{coupon.is_active ? 'Active' : 'Inactive'}</Badge>
                </div>

                <div className="grid grid-cols-2 gap-4 py-4 border-t border-b border-slate-50 mb-4">
                  <div>
                    <label className="text-[10px] uppercase font-bold text-slate-400">Value</label>
                    <p className="text-sm font-bold text-slate-900">{coupon.discount_type === 'percent' ? `${coupon.amount}%` : formatCurrency(coupon.amount)}</p>
                  </div>
                  <div>
                    <label className="text-[10px] uppercase font-bold text-slate-400">Usage</label>
                    <p className="text-sm font-bold text-slate-900">{coupon.usage_count} / {coupon.max_uses || '∞'}</p>
                  </div>
                </div>

                <div className="flex justify-end gap-3 pt-2">
                  <button onClick={() => handleEdit(coupon)} className="flex-1 py-2 bg-slate-50 text-slate-900 text-xs font-bold uppercase tracking-widest rounded-sm hover:bg-slate-100 border border-slate-100">Edit</button>
                  <button onClick={() => handleToggleActive(coupon)} className="p-2 border border-slate-100 rounded-sm text-slate-400"><Icon icon={coupon.is_active ? FiX : FiCheck} /></button>
                </div>
              </div>
            ))}
          </div>

          {/* Desktop Table View */}
          <div className="hidden md:block bg-white border border-slate-100 rounded-sm shadow-sm overflow-hidden">
            <table className="w-full text-left">
              <thead className="bg-slate-50 border-b border-slate-100">
                <tr>
                  <th className="px-6 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500">Campaign info</th>
                  <th className="px-6 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500">Discount</th>
                  <th className="px-6 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500">Usage Stats</th>
                  <th className="px-6 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500">Status</th>
                  <th className="px-6 py-5 text-[10px] font-bold uppercase tracking-widest text-slate-500 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50">
                {filteredData.map(coupon => (
                  <tr key={coupon.id} className="hover:bg-slate-50/50 transition-colors group">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-sm bg-slate-100 flex items-center justify-center text-slate-400">
                          <Icon icon={FiTag} />
                        </div>
                        <div>
                          <div className="font-mono font-bold text-slate-900">{coupon.code}</div>
                          <div className="text-xs text-slate-500 mt-0.5">{coupon.starts_at && coupon.ends_at ? `${formatDate(coupon.starts_at)} - ${formatDate(coupon.ends_at)}` : 'No expiry set'}</div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`inline-block px-2 py-1 rounded-sm text-xs font-bold ${coupon.discount_type === 'percent' ? 'bg-orange-50 text-orange-600' : 'bg-blue-50 text-blue-600'}`}>
                        {coupon.discount_type === 'percent' ? `${coupon.amount}% OFF` : `-${formatCurrency(coupon.amount)}`}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm font-medium text-slate-900">{coupon.usage_count} uses</div>
                      <div className="w-24 h-1 bg-slate-100 rounded-full mt-2 overflow-hidden">
                        <div className="h-full bg-slate-900" style={{ width: `${Math.min(((coupon.usage_count || 0) / (coupon.max_uses || 100)) * 100, 100)}%` }}></div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <button onClick={() => handleToggleActive(coupon)}>
                        <Badge variant={coupon.is_active ? 'success' : 'secondary'}>{coupon.is_active ? 'Active' : 'Stopped'}</Badge>
                      </button>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <button onClick={() => handleEdit(coupon)} className="p-2 text-slate-400 hover:text-slate-900 hover:bg-white rounded-full transition-all" title="Edit"><Icon icon={FiEdit3} size={15} /></button>
                        <button onClick={() => handleDuplicate(coupon)} className="p-2 text-slate-400 hover:text-slate-900 hover:bg-white rounded-full transition-all" title="Duplicate"><Icon icon={FiCopy} size={15} /></button>
                        {isSuperAdmin && (
                          <button onClick={() => handleDelete(coupon.id)} className="p-2 text-slate-400 hover:text-red-600 hover:bg-white rounded-full transition-all" title="Delete"><Icon icon={FiTrash2} size={15} /></button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}

      {/* DIALOG */}
      <AnimatePresence>
        {isDialogOpen && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/40 backdrop-blur-sm">
            <motion.div
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              className="bg-white w-full max-w-2xl rounded-sm shadow-2xl overflow-hidden flex flex-col max-h-[90vh]"
            >
              <div className="p-6 border-b border-slate-100 flex justify-between items-center bg-white">
                <div>
                  <h3 className="text-xl font-bold text-slate-900 tracking-tight">{editingCoupon ? 'Edit Campaign' : 'New Campaign'}</h3>
                  <p className="text-xs text-slate-500 mt-1">Configure discount rules and validity.</p>
                </div>
                <button onClick={() => setIsDialogOpen(false)} className="p-2 hover:bg-slate-50 rounded-full transition-colors"><Icon icon={FiX} size={20} /></button>
              </div>

              {/* TABS */}
              <div className="flex border-b border-slate-100 bg-slate-50/50 px-6 gap-6">
                {['general', 'restrictions', 'marketing'].map(tab => (
                  <button
                    key={tab}
                    onClick={() => setActiveTab(tab as any)}
                    className={`py-4 text-xs font-bold uppercase tracking-widest relative ${activeTab === tab ? 'text-slate-900' : 'text-slate-400 hover:text-slate-600'}`}
                  >
                    {tab}
                    {activeTab === tab && <motion.div layoutId="activeTab" className="absolute bottom-0 left-0 right-0 h-0.5 bg-slate-900" />}
                  </button>
                ))}
              </div>

              <form onSubmit={handleSave} className="flex-1 overflow-y-auto p-8 relative">

                {/* GENERAL TAB */}
                {activeTab === 'general' && (
                  <div className="space-y-8 animate-in fade-in slide-in-from-bottom-2 duration-300">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div>
                        <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-500 mb-2">Campaign Code</label>
                        <input required value={formData.code} onChange={e => setFormData({ ...formData, code: e.target.value.toUpperCase() })} className="w-full bg-slate-50 border border-slate-200 p-4 text-sm font-mono uppercase font-bold rounded-sm outline-none focus:border-slate-900 transition-colors" placeholder="e.g. SUMMER24" />
                      </div>
                      <div>
                        <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-500 mb-2">Status</label>
                        <div className="flex items-center gap-3 p-3 bg-slate-50 border border-slate-200 rounded-sm">
                          <input type="checkbox" checked={formData.is_active} onChange={e => setFormData({ ...formData, is_active: e.target.checked })} className="accent-slate-900 w-5 h-5" />
                          <span className="text-sm font-medium text-slate-900">{formData.is_active ? 'Active' : 'Inactive'}</span>
                        </div>
                      </div>
                    </div>

                    <div className="p-6 bg-slate-50 border border-slate-100 rounded-sm space-y-6">
                      <h4 className="text-xs font-bold uppercase text-slate-900 flex items-center gap-2"><Icon icon={FiDollarSign} /> Discount Value</h4>
                      <div className="grid grid-cols-2 gap-4">
                        <div className="flex bg-white border border-slate-200 rounded-sm overflow-hidden">
                          <button type="button" onClick={() => setFormData({ ...formData, discount_type: 'percent' })} className={`flex-1 text-xs font-bold uppercase tracking-wide ${formData.discount_type === 'percent' ? 'bg-slate-900 text-white' : 'text-slate-500 hover:bg-slate-50'}`}>Percent</button>
                          <button type="button" onClick={() => setFormData({ ...formData, discount_type: 'fixed' })} className={`flex-1 text-xs font-bold uppercase tracking-wide ${formData.discount_type === 'fixed' ? 'bg-slate-900 text-white' : 'text-slate-500 hover:bg-slate-50'}`}>Fixed</button>
                        </div>
                        <div className="relative">
                          <input type="number" min="0" value={formData.amount} onChange={e => setFormData({ ...formData, amount: parseFloat(e.target.value) })} className="w-full bg-white border border-slate-200 p-2.5 pl-8 text-sm font-bold rounded-sm outline-none focus:border-slate-900" />
                          <span className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 font-bold">{formData.discount_type === 'percent' ? '%' : '$'}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                )}

                {/* RESTRICTIONS TAB */}
                {activeTab === 'restrictions' && (
                  <div className="space-y-8 animate-in fade-in slide-in-from-bottom-2 duration-300">
                    <div className="grid grid-cols-2 gap-6">
                      <div>
                        <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-500 mb-2">Min Order Subtotal</label>
                        <input type="number" min="0" value={formData.min_subtotal} onChange={e => setFormData({ ...formData, min_subtotal: parseFloat(e.target.value) })} className="w-full bg-slate-50 border border-slate-200 p-3 text-sm rounded-sm outline-none focus:border-slate-900" />
                      </div>
                      <div>
                        <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-500 mb-2">Total Max Uses</label>
                        <input type="number" min="0" placeholder="Unlimited" value={formData.max_uses || ''} onChange={e => setFormData({ ...formData, max_uses: e.target.value ? parseInt(e.target.value) : null })} className="w-full bg-slate-50 border border-slate-200 p-3 text-sm rounded-sm outline-none focus:border-slate-900" />
                      </div>
                    </div>

                    <div className="grid grid-cols-2 gap-6">
                      <div>
                        <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-500 mb-2">Starts Date</label>
                        <input type="datetime-local" value={formData.starts_at || ''} onChange={e => setFormData({ ...formData, starts_at: e.target.value || null })} className="w-full bg-slate-50 border border-slate-200 p-3 text-xs rounded-sm outline-none focus:border-slate-900" />
                      </div>
                      <div>
                        <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-500 mb-2">Ends Date</label>
                        <input type="datetime-local" value={formData.ends_at || ''} onChange={e => setFormData({ ...formData, ends_at: e.target.value || null })} className="w-full bg-slate-50 border border-slate-200 p-3 text-xs rounded-sm outline-none focus:border-slate-900" />
                      </div>
                    </div>

                    <div className="p-6 bg-amber-50 border border-amber-100 rounded-sm">
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-amber-600 mb-3 flex items-center gap-2"><Icon icon={FiLock} /> Restrict to Emails</label>
                      <div className="flex gap-2 mb-3">
                        <input value={newEmail} onChange={e => setNewEmail(e.target.value)} placeholder="customer@example.com" className="flex-grow bg-white border border-amber-200 p-2 text-sm rounded-sm outline-none focus:border-amber-500" />
                        <button type="button" onClick={handleAddEmail} className="px-4 bg-amber-200 text-amber-800 text-xs font-bold uppercase rounded-sm hover:bg-amber-300">Add</button>
                      </div>
                      {allowedEmails.length > 0 && (
                        <div className="flex flex-wrap gap-2">
                          {allowedEmails.map(email => (
                            <span key={email} className="bg-white border border-amber-200 px-2 py-1 rounded text-xs text-amber-800 flex items-center gap-2">
                              {email}
                              <button type="button" onClick={() => setAllowedEmails(allowedEmails.filter(e => e !== email))} className="hover:text-red-500"><Icon icon={FiX} size={10} /></button>
                            </span>
                          ))}
                        </div>
                      )}
                      {allowedEmails.length === 0 && <p className="text-xs text-amber-600/60 italic">No restrictions. Available to everyone.</p>}
                    </div>
                  </div>
                )}

                {/* MARKETING TAB */}
                {activeTab === 'marketing' && (
                  <div className="space-y-6 animate-in fade-in slide-in-from-bottom-2 duration-300">
                    <div className="p-6 bg-indigo-50 border border-indigo-100 rounded-sm">
                      <div className="flex justify-between items-start mb-4">
                        <div>
                          <h4 className="text-sm font-bold text-indigo-900">Announcement Bar</h4>
                          <p className="text-xs text-indigo-600 mt-1">Display this code at the top of the website.</p>
                        </div>
                        <input type="checkbox" checked={showInMarquee} onChange={e => setShowInMarquee(e.target.checked)} className="accent-indigo-900 w-5 h-5" />
                      </div>
                      {showInMarquee && (
                        <div className="bg-white border border-indigo-200 p-3 rounded-sm animate-in slide-in-from-top-2">
                          <label className="block text-[10px] font-bold uppercase tracking-widest text-indigo-400 mb-2">Message</label>
                          <input value={marqueeMessage} onChange={e => setMarqueeMessage(e.target.value)} placeholder={`${formData.code} — Tap to copy`} className="w-full bg-slate-50 border-none p-2 text-sm rounded-sm outline-none" />
                        </div>
                      )}
                    </div>
                  </div>
                )}

              </form>

              <div className="p-6 border-t border-slate-100 bg-slate-50/50 flex gap-4">
                <button onClick={() => setIsDialogOpen(false)} className="flex-1 py-3 border border-slate-200 bg-white text-xs font-bold uppercase tracking-widest hover:bg-slate-50 rounded-sm transition-colors text-slate-600">Cancel</button>
                <button onClick={handleSave} disabled={dialogLoading} className="flex-1 py-3 bg-slate-900 text-white text-xs font-bold uppercase tracking-widest hover:bg-black rounded-sm transition-all shadow-md disabled:opacity-70 disabled:cursor-not-allowed">
                  {dialogLoading ? 'Saving...' : 'Save & Publish'}
                </button>
              </div>

            </motion.div>
          </div>
        )}
      </AnimatePresence>

    </div>
  );
};
