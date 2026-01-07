
import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { supabase } from '../lib/supabase';
import { Profile, Address, Order } from '../types';
import { Icon } from '../components/Icon';
import { FiChevronRight, FiEdit2 } from 'react-icons/fi';

export const Account: React.FC = () => {
  const { user } = useAuth();
  const [profile, setProfile] = useState<Profile | null>(null);
  const [addresses, setAddresses] = useState<Address[]>([]);
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);

  // Address Form State
  const [isEditingAddress, setIsEditingAddress] = useState(false);
  const [currentAddress, setCurrentAddress] = useState<Partial<Address>>({});
  const [addressLoading, setAddressLoading] = useState(false);

  useEffect(() => {
    if (!user) return;

    async function fetchData() {
      setLoading(true);
      try {
        const [profileRes, addressesRes, ordersRes] = await Promise.all([
          supabase.from('profiles').select('*').eq('user_id', user!.id).single(),
          supabase.from('addresses').select('*').eq('user_id', user!.id),
          supabase.from('orders').select('*').eq('customer_id', user!.id).order('created_at', { ascending: false }).limit(3)
        ]);

        if (profileRes.data) setProfile(profileRes.data);
        if (addressesRes.data) {
          const uniqueAddresses = addressesRes.data.filter((addr: any, index: number, self: any[]) =>
            index === self.findIndex((t) => (
              t.label === addr.label &&
              t.full_name === addr.full_name &&
              t.phone === addr.phone &&
              t.address_line === addr.address_line &&
              t.district === addr.district
            ))
          );
          setAddresses(uniqueAddresses);
        }
        if (ordersRes.data) setOrders(ordersRes.data);
      } catch (err) {
        console.error('Error fetching account data:', err);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, [user]);

  const handleEditAddress = (addr: Address) => {
    setCurrentAddress(addr);
    setIsEditingAddress(true);
    // Scroll to form
    window.scrollTo({ top: 400, behavior: 'smooth' });
  };

  const handleAddNewAddress = () => {
    setCurrentAddress({});
    setIsEditingAddress(true);
  };

  const handleCancelAddress = () => {
    setIsEditingAddress(false);
    setCurrentAddress({});
  };

  const handleSaveAddress = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!user) return;
    setAddressLoading(true);

    const formData = new FormData(e.currentTarget);
    const updates: any = {
      user_id: user.id,
      label: formData.get('label') || 'Home',
      full_name: formData.get('full_name'),
      phone: formData.get('phone'),
      address_line: formData.get('address_line'),
      division: formData.get('division'),
      district: formData.get('district'),
      thana: formData.get('thana'),
      area: formData.get('area'), // Optional
      zip: formData.get('zip'),     // Optional
      is_default: formData.get('is_default') === 'on'
    };

    try {
      if (updates.is_default) {
        // If setting as default, unset others first
        await supabase
          .from('addresses')
          .update({ is_default: false })
          .eq('user_id', user.id);
      }

      let error;
      if (currentAddress.id) {
        // Update
        const res = await supabase.from('addresses').update(updates).eq('id', currentAddress.id);
        error = res.error;
      } else {
        // Insert
        const res = await supabase.from('addresses').insert(updates);
        error = res.error;
      }

      if (error) throw error;

      // Refresh addresses
      const { data } = await supabase.from('addresses').select('*').eq('user_id', user.id).order('created_at', { ascending: true });
      if (data) setAddresses(data);

      setIsEditingAddress(false);
      setCurrentAddress({});
      setMessage({ type: 'success', text: 'Address saved successfully.' });
    } catch (err: any) {
      console.error(err);
      setMessage({ type: 'error', text: 'Failed to save address.' });
    } finally {
      setAddressLoading(false);
    }
  };

  const handleUpdateProfile = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!user || !profile) return;
    setSaving(true);
    setMessage(null);

    const formData = new FormData(e.currentTarget);
    const updates = {
      full_name: formData.get('full_name') as string,
      phone: formData.get('phone') as string,
    };

    const { error } = await supabase
      .from('profiles')
      .upsert({ user_id: user.id, email: user.email, ...updates });

    if (error) {
      setMessage({ type: 'error', text: 'Failed to update profile.' });
    } else {
      setProfile({ ...profile, ...updates });
      setMessage({ type: 'success', text: 'Profile updated successfully.' });
    }
    setSaving(false);
  };

  if (loading) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-20 text-center animate-pulse">
        <h2 className="text-xl font-bold tracking-widest text-slate-200">CURATING YOUR SPACE...</h2>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div className="mb-12">
        <h1 className="text-4xl font-bold tracking-tighter">My Account</h1>
        <p className="text-slate-500 mt-2 uppercase text-[10px] tracking-[0.4em] font-bold">Personal Dashboard</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
        {/* Profile Section */}
        <div className="lg:col-span-1">
          <div className="bg-slate-50 p-8 rounded-sm border border-slate-100 h-full">
            <h2 className="text-xs font-bold uppercase tracking-[0.3em] mb-8 border-b border-slate-200 pb-4">Personal Profile</h2>
            {message && (
              <div className={`p-4 mb-6 text-[10px] font-bold uppercase tracking-widest border ${message.type === 'success' ? 'bg-green-50 text-green-600 border-green-100' : 'bg-red-50 text-red-600 border-red-100'}`}>
                {message.text}
              </div>
            )}
            <form onSubmit={handleUpdateProfile} className="space-y-6">
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-slate-400">Email Address</label>
                <input disabled value={user?.email} className="w-full bg-slate-200 border-none p-4 rounded-sm text-sm font-medium text-slate-500 cursor-not-allowed" />
              </div>
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-slate-400">Full Name</label>
                <input name="full_name" defaultValue={profile?.full_name} required className="w-full bg-white border border-slate-200 p-4 rounded-sm text-sm focus:ring-1 focus:ring-slate-900 outline-none" />
              </div>
              <div className="space-y-1">
                <label className="text-[10px] font-bold uppercase tracking-widest text-slate-400">Phone Number</label>
                <input name="phone" defaultValue={profile?.phone} required className="w-full bg-white border border-slate-200 p-4 rounded-sm text-sm focus:ring-1 focus:ring-slate-900 outline-none" />
              </div>
              <button disabled={saving} className="w-full bg-slate-900 text-white py-4 font-bold tracking-widest uppercase text-xs hover:bg-slate-800 transition-all disabled:opacity-50">
                {saving ? 'Saving...' : 'Update Details'}
              </button>
            </form>
          </div>
        </div>

        {/* Address & Orders */}
        <div className="lg:col-span-2 space-y-12">
          {/* Recent Orders */}
          <div>
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-xs font-bold uppercase tracking-[0.3em]">Recent Orders</h2>
              <Link to="/account/orders" className="text-[10px] font-bold border-b border-slate-900 uppercase">View All Orders</Link>
            </div>
            {orders.length > 0 ? (
              <div className="space-y-4">
                {orders.map(order => (
                  <div key={order.id} className="flex flex-col md:flex-row md:items-center justify-between p-6 bg-white border border-slate-100 hover:shadow-sm transition-all rounded-sm group">
                    <div>
                      <h3 className="font-bold text-slate-900">Order #{order.order_number}</h3>
                      <p className="text-[10px] text-slate-400 font-bold uppercase mt-1">Placed on {new Date(order.created_at).toLocaleDateString()}</p>
                    </div>
                    <div className="mt-4 md:mt-0 flex items-center space-x-8">
                      <div className="text-right">
                        <p className="text-sm font-bold">৳{order.total.toLocaleString()}</p>
                        <span className="text-[10px] font-bold uppercase tracking-widest px-2 py-0.5 bg-slate-100 text-slate-600 rounded-full">{order.status}</span>
                      </div>
                      <Link to={`/account/orders/${order.order_number}`} className="bg-slate-50 p-2 rounded-full text-slate-400 group-hover:bg-slate-900 group-hover:text-white transition-all">
                        <Icon icon={FiChevronRight} size={20} />
                      </Link>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="bg-slate-50 py-12 text-center border border-dashed border-slate-200 rounded-sm">
                <p className="text-slate-400 text-xs font-medium mb-4">You haven't placed any orders yet.</p>
                <Link to="/shop" className="text-xs font-bold uppercase tracking-widest border-b border-slate-900">Start Shopping</Link>
              </div>
            )}
          </div>

          {/* Address Book */}
          <div>
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-xs font-bold uppercase tracking-[0.3em]">Address Book</h2>
              {!isEditingAddress && (
                <button onClick={handleAddNewAddress} className="text-[10px] font-bold border-b border-slate-900 uppercase">Add New</button>
              )}
            </div>

            {/* ADDRESS FORM */}
            {isEditingAddress && (
              <div className="bg-slate-50 border border-slate-200 p-6 rounded-sm mb-8 animate-in fade-in zoom-in-95 duration-200">
                <h3 className="text-sm font-bold text-slate-900 mb-4">{currentAddress.id ? 'Edit Address' : 'New Address'}</h3>
                <form onSubmit={handleSaveAddress} className="space-y-4">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Label</label>
                      <input name="label" defaultValue={currentAddress.label || 'Home'} placeholder="Home, Office, etc." required className="w-full text-sm border border-slate-200 p-3 rounded-sm" />
                    </div>
                    <div>
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Full Name</label>
                      <input name="full_name" defaultValue={currentAddress.full_name || ''} required className="w-full text-sm border border-slate-200 p-3 rounded-sm" />
                    </div>
                    <div>
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Phone</label>
                      <input name="phone" defaultValue={currentAddress.phone || ''} required className="w-full text-sm border border-slate-200 p-3 rounded-sm" />
                    </div>
                    <div>
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Division</label>
                      <select name="division" defaultValue={currentAddress.division || 'Dhaka'} className="w-full text-sm border border-slate-200 p-3 rounded-sm">
                        {['Dhaka', 'Chattogram', 'Rajshahi', 'Khulna', 'Barishal', 'Sylhet', 'Rangpur', 'Mymensingh'].map(d => (
                          <option key={d} value={d}>{d}</option>
                        ))}
                      </select>
                    </div>
                    <div className="md:col-span-2">
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Address Line</label>
                      <textarea name="address_line" defaultValue={currentAddress.address_line || ''} rows={2} required className="w-full text-sm border border-slate-200 p-3 rounded-sm" />
                    </div>
                    <div>
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">District</label>
                      <input name="district" defaultValue={currentAddress.district || ''} required className="w-full text-sm border border-slate-200 p-3 rounded-sm" />
                    </div>
                    <div>
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Thana/Upazila</label>
                      <input name="thana" defaultValue={currentAddress.thana || ''} required className="w-full text-sm border border-slate-200 p-3 rounded-sm" />
                    </div>
                    <div>
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Zip Code</label>
                      <input name="zip" defaultValue={currentAddress.zip || ''} className="w-full text-sm border border-slate-200 p-3 rounded-sm" />
                    </div>
                    <div>
                      <label className="block text-[10px] font-bold uppercase tracking-widest text-slate-400 mb-1">Area</label>
                      <input name="area" defaultValue={currentAddress.area || ''} className="w-full text-sm border border-slate-200 p-3 rounded-sm" />
                    </div>
                  </div>

                  <div className="flex items-center gap-2 mt-2">
                    <input type="checkbox" name="is_default" id="is_default" defaultChecked={currentAddress.is_default} />
                    <label htmlFor="is_default" className="text-xs font-bold text-slate-600">Set as default address</label>
                  </div>

                  <div className="flex gap-3 pt-4">
                    <button type="submit" disabled={addressLoading} className="px-6 py-2 bg-slate-900 text-white text-xs font-bold uppercase tracking-widest hover:bg-slate-800 disabled:opacity-50">Save Address</button>
                    <button type="button" onClick={handleCancelAddress} className="px-6 py-2 border border-slate-200 text-slate-600 text-xs font-bold uppercase tracking-widest hover:bg-slate-50">Cancel</button>
                  </div>
                </form>
              </div>
            )}

            {!isEditingAddress && (
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {addresses.map(address => (
                  <div key={address.id} className="p-6 border border-slate-100 bg-white rounded-sm relative group">
                    <div className="flex justify-between items-start mb-4">
                      <span className="text-[10px] font-bold uppercase tracking-[0.2em] bg-slate-900 text-white px-2 py-0.5">{address.label}</span>
                      {address.is_default && <span className="text-[9px] font-bold text-slate-400 uppercase tracking-widest italic">Default</span>}
                    </div>
                    <p className="text-sm font-bold text-slate-900 mb-1">{address.full_name}</p>
                    <p className="text-xs text-slate-500 leading-relaxed">
                      {address.address_line}, {address.thana}<br />
                      {address.district}, {address.division} - {address.zip}
                    </p>
                    <p className="text-xs text-slate-400 mt-2 font-medium">{address.phone}</p>
                    <div className="absolute top-6 right-6 flex space-x-2 opacity-0 group-hover:opacity-100 transition-opacity">
                      <button onClick={() => handleEditAddress(address)} className="text-slate-400 hover:text-slate-900">
                        <Icon icon={FiEdit2} size={16} />
                      </button>
                    </div>
                  </div>
                ))}
                {addresses.length === 0 && (
                  <div className="col-span-full bg-slate-50 py-12 text-center border border-dashed border-slate-200 rounded-sm">
                    <p className="text-slate-400 text-xs font-medium mb-4">No addresses saved.</p>
                    <button onClick={handleAddNewAddress} className="text-xs font-bold uppercase tracking-widest border-b border-slate-900">Add Delivery Address</button>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
