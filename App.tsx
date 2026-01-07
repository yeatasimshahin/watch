
import React from 'react';
import { HashRouter as Router, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { CartProvider } from './context/CartContext';
import { WishlistProvider } from './context/WishlistContext';
import { AuthProvider, useAuth } from './context/AuthContext';
import { Layout } from './components/Layout';
import { AdminLayout } from './components/AdminLayout'; // Import AdminLayout
// Lazy load all pages for better performance
const Home = React.lazy(() => import('./pages/Home').then(m => ({ default: m.Home })));
const Shop = React.lazy(() => import('./pages/Shop').then(m => ({ default: m.Shop })));
const ProductDetail = React.lazy(() => import('./pages/ProductDetail').then(m => ({ default: m.ProductDetail })));
const Cart = React.lazy(() => import('./pages/Cart').then(m => ({ default: m.Cart })));
const Checkout = React.lazy(() => import('./pages/Checkout').then(m => ({ default: m.Checkout })));
const Success = React.lazy(() => import('./pages/Success').then(m => ({ default: m.Success })));
const TrackOrder = React.lazy(() => import('./pages/TrackOrder').then(m => ({ default: m.TrackOrder })));
const Wishlist = React.lazy(() => import('./pages/Wishlist').then(m => ({ default: m.Wishlist })));
const Login = React.lazy(() => import('./pages/Login').then(m => ({ default: m.Login })));
const Signup = React.lazy(() => import('./pages/Signup').then(m => ({ default: m.Signup })));
const Account = React.lazy(() => import('./pages/Account').then(m => ({ default: m.Account })));
const OrderList = React.lazy(() => import('./pages/OrderList').then(m => ({ default: m.OrderList })));
const OrderDetails = React.lazy(() => import('./pages/OrderDetails').then(m => ({ default: m.OrderDetails })));
const CMSPage = React.lazy(() => import('./pages/CMSPage').then(m => ({ default: m.CMSPage })));
const Contact = React.lazy(() => import('./pages/Contact').then(m => ({ default: m.Contact })));
const Wholesale = React.lazy(() => import('./pages/Wholesale').then(m => ({ default: m.Wholesale })));
const About = React.lazy(() => import('./pages/About').then(m => ({ default: m.About })));
const FAQ = React.lazy(() => import('./pages/FAQ').then(m => ({ default: m.FAQ })));
const BlogList = React.lazy(() => import('./pages/BlogList').then(m => ({ default: m.BlogList })));
const BlogPost = React.lazy(() => import('./pages/BlogPost').then(m => ({ default: m.BlogPost })));
const AdminLoginRedirect = React.lazy(() => import('./pages/AdminLoginRedirect').then(m => ({ default: m.AdminLoginRedirect })));
const AdminDashboard = React.lazy(() => import('./pages/AdminDashboard').then(m => ({ default: m.AdminDashboard })));
const AdminProductList = React.lazy(() => import('./pages/AdminProductList').then(m => ({ default: m.AdminProductList })));
const AdminProductForm = React.lazy(() => import('./pages/AdminProductForm').then(m => ({ default: m.AdminProductForm })));
const AdminInventory = React.lazy(() => import('./pages/AdminInventory').then(m => ({ default: m.AdminInventory })));
const AdminOrderList = React.lazy(() => import('./pages/AdminOrderList').then(m => ({ default: m.AdminOrderList })));
const AdminOrderDetails = React.lazy(() => import('./pages/AdminOrderDetails').then(m => ({ default: m.AdminOrderDetails })));
const AdminCustomers = React.lazy(() => import('./pages/AdminCustomers').then(m => ({ default: m.AdminCustomers })));
const AdminCoupons = React.lazy(() => import('./pages/AdminCoupons').then(m => ({ default: m.AdminCoupons })));
const AdminReviews = React.lazy(() => import('./pages/AdminReviews').then(m => ({ default: m.AdminReviews })));
const AdminBlogList = React.lazy(() => import('./pages/AdminBlogList').then(m => ({ default: m.AdminBlogList })));
const AdminBlogPost = React.lazy(() => import('./pages/AdminBlogPost').then(m => ({ default: m.AdminBlogPost })));
const AdminSettings = React.lazy(() => import('./pages/AdminSettings').then(m => ({ default: m.AdminSettings })));
const AdminLoyalty = React.lazy(() => import('./pages/AdminLoyalty').then(m => ({ default: m.AdminLoyalty })));
const AdminShipping = React.lazy(() => import('./pages/AdminShipping').then(m => ({ default: m.AdminShipping })));
const AdminReports = React.lazy(() => import('./pages/AdminReports').then(m => ({ default: m.AdminReports })));
const AdminContactEditor = React.lazy(() => import('./pages/AdminContactEditor').then(m => ({ default: m.AdminContactEditor })));

// Loading Component
const PageLoading = () => (
  <div className="min-h-screen flex items-center justify-center bg-white">
    <div className="w-12 h-12 border-4 border-slate-100 border-t-[#FF8C00] rounded-full animate-spin"></div>
  </div>
);

import { AnimatePresence } from 'framer-motion';

const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
  const { user, loading } = useAuth();
  if (loading) return null;
  if (!user) return <Navigate to="/login" replace />;
  return <>{children}</>;
};

// AnimatedRoutes wrapper to use useLocation
const AnimatedRoutes = () => {
  const location = useLocation();

  return (
    <AnimatePresence mode="wait">
      <React.Suspense fallback={<PageLoading />} key={location.pathname}>
        <Routes location={location}>
          <Route path="/" element={<Home />} />
          <Route path="/shop" element={<Shop />} />
          <Route path="/search" element={<Shop />} />
          <Route path="/c/:collectionSlug" element={<Shop />} />
          <Route path="/p/:productSlug" element={<ProductDetail />} />
          <Route path="/cart" element={<Cart />} />
          <Route path="/checkout" element={<Checkout />} />
          <Route path="/success/:orderId" element={<Success />} />

          <Route path="/track-order" element={<TrackOrder />} />
          <Route path="/track" element={<Navigate to="/track-order" replace />} />

          <Route path="/wishlist" element={<Wishlist />} />

          {/* Auth Routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Signup />} />
          <Route path="/signup" element={<Navigate to="/register" replace />} />

          {/* Account Routes */}
          <Route path="/account" element={<ProtectedRoute><Account /></ProtectedRoute>} />
          <Route path="/account/orders" element={<ProtectedRoute><OrderList /></ProtectedRoute>} />
          <Route path="/account/orders/:orderNumber" element={<ProtectedRoute><OrderDetails /></ProtectedRoute>} />

          {/* Trust & Business */}
          <Route path="/about" element={<About />} />
          <Route path="/contact" element={<Contact />} />
          <Route path="/faq" element={<FAQ />} />
          <Route path="/wholesale" element={<Wholesale />} />

          {/* Blog */}
          <Route path="/blog" element={<BlogList />} />
          <Route path="/blog/:slug" element={<BlogPost />} />

          {/* Legal */}
          <Route path="/legal/shipping" element={<CMSPage slug="legal-shipping" />} />
          <Route path="/legal/returns" element={<CMSPage slug="legal-returns" />} />
          <Route path="/legal/warranty" element={<CMSPage slug="legal-warranty" />} />
          <Route path="/legal/privacy" element={<CMSPage slug="legal-privacy" />} />
          <Route path="/legal/terms" element={<CMSPage slug="legal-terms" />} />

          {/* Fallback */}
          <Route path="*" element={<Home />} />
        </Routes>
      </React.Suspense>
    </AnimatePresence>
  );
};

const App: React.FC = () => {
  return (
    <Router>
      <AuthProvider>
        <WishlistProvider>
          <CartProvider>
            <Routes>
              {/* ADMIN ROUTES (Protected by AdminLayout) */}
              <Route path="/admin" element={<AdminLayout />}>
                <Route index element={<Navigate to="dashboard" replace />} />
                <Route path="*" element={
                  <React.Suspense fallback={<PageLoading />}>
                    <Routes>
                      <Route path="dashboard" element={<AdminDashboard />} />
                      <Route path="products" element={<AdminProductList />} />
                      <Route path="products/new" element={<AdminProductForm />} />
                      <Route path="products/:id" element={<AdminProductForm />} />
                      <Route path="inventory" element={<AdminInventory />} />
                      <Route path="orders" element={<AdminOrderList />} />
                      <Route path="orders/:orderNumber" element={<AdminOrderDetails />} />
                      <Route path="customers" element={<AdminCustomers />} />
                      <Route path="coupons" element={<AdminCoupons />} />
                      <Route path="reviews" element={<AdminReviews />} />
                      <Route path="content/blog" element={<AdminBlogList />} />
                      <Route path="content/blog/new" element={<AdminBlogPost />} />
                      <Route path="content/blog/:id" element={<AdminBlogPost />} />
                      <Route path="content/contact" element={<AdminContactEditor />} />
                      <Route path="settings" element={<AdminSettings />} />
                      <Route path="loyalty" element={<AdminLoyalty />} />
                      <Route path="shipping" element={<AdminShipping />} />
                      <Route path="reports" element={<AdminReports />} />
                      <Route path="*" element={<div className="p-8 text-center text-slate-400 uppercase font-bold text-xs tracking-widest">Page Under Construction</div>} />
                    </Routes>
                  </React.Suspense>
                } />
              </Route>

              {/* ADMIN LOGIN REDIRECT */}
              <Route path="/admin/login" element={<React.Suspense fallback={<PageLoading />}><AdminLoginRedirect /></React.Suspense>} />

              {/* PUBLIC STORE ROUTES (Wrapped in Main Layout) */}
              <Route path="*" element={
                <Layout>
                  <AnimatedRoutes />
                </Layout>
              } />
            </Routes>
          </CartProvider>
        </WishlistProvider>
      </AuthProvider>
    </Router>
  );
};

export default App;
