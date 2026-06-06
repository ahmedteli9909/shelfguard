# 🛡️ ShelfGuard — Product Expiry Tracker App

> **Track it. Get alerted. Never waste again.**

---

## 📌 Project Overview

**ShelfGuard** is a mobile application that helps users track the expiry dates of everyday products — groceries, medicines, cosmetics, and more. Users can add products by scanning barcodes or entering details manually, and the app sends smart notifications before items expire. The goal is to reduce household waste, save money, and promote healthier consumption habits.

---

## 🎯 Problem Statement

Every year, millions of tonnes of food and medicine are wasted because people forget expiry dates. Households throw away products worth thousands of rupees simply because they didn't know something was about to expire. There is no simple, everyday tool that helps people stay on top of what's in their kitchen, fridge, or medicine cabinet.

---

## 💡 Solution

ShelfGuard solves this by acting as a **personal expiry assistant**. Users add their products once (via barcode scan or manual entry), and the app takes care of the rest — organizing inventory, sending timely alerts, and giving a clear dashboard view of what needs attention.

---

## 👥 Target Audience

| Segment | Description |
|---|---|
| **Homemakers** | Track groceries, dairy, spices, and kitchen essentials |
| **Health-conscious individuals** | Monitor supplements, protein powders, vitamins |
| **Parents** | Keep track of baby food, formula, children's medicine |
| **Small shop owners** | Manage inventory expiry for a small retail store |
| **Elderly / Caregivers** | Track medicines and prescriptions |
| **Hostel students** | Manage limited food supplies efficiently |

---

## 📱 App Screens & Flow

```
Splash Screen
    ↓
Onboarding (Welcome / Feature Intro)
    ↓
Phone Number Authentication
    ↓
OTP Verification
    ↓
Dashboard (Home)
    ↓
  ├── Scan Product (Barcode Scanner)
  │       ↓
  │   Add Product Details
  │       ↓
  │   Save to Inventory
  │
  ├── Inventory List (All Products)
  │       ↓
  │   Product Detail View
  │       ↓
  │   Edit / Delete Product
  │
  ├── Notifications / Alerts
  │
  ├── Profile & Settings
  │       ↓
  │   ├── Edit Profile
  │   ├── Notification Preferences
  │   ├── App Theme (Light / Dark)
  │   └── About / Help
  │
  └── Categories Management
```

---

## ✨ Features

### 🔐 1. Authentication

| Feature | Detail |
|---|---|
| Phone number login | User enters mobile number to receive OTP |
| OTP verification | 4-digit OTP sent via SMS for verification |
| Skip option | Users can skip auth and use app in local-only mode |
| Session persistence | Stay logged in until manual logout |

---

### 🏠 2. Dashboard (Home Screen)

| Feature | Detail |
|---|---|
| Total items count | Shows how many products are being tracked |
| Expiring soon alerts | Highlights products expiring within 3 days |
| Expired items | Red-flagged products that have already expired |
| Safe items count | Products with comfortable shelf life remaining |
| Quick actions | Fast access to Scan and Add Product |
| Recent activity | Last 5 added or updated products |

---

### 📷 3. Barcode Scanner

| Feature | Detail |
|---|---|
| Camera-based scanning | Point camera at product barcode to auto-detect |
| Auto-fill product info | If barcode is recognized, auto-fill name and category |
| Manual entry fallback | If barcode not found, user enters details manually |
| Flashlight toggle | Enable flash for scanning in dark environments |
| Scan history | Keep log of recently scanned items |

---

### 📝 4. Add / Edit Product

| Field | Type | Required |
|---|---|---|
| Product Name | Text input | ✅ Yes |
| Category | Dropdown (Dairy, Bakery, Medicine, etc.) | ✅ Yes |
| Expiry Date | Date picker | ✅ Yes |
| Manufacturing Date | Date picker | ❌ Optional |
| Quantity | Number input | ✅ Yes |
| Unit | Dropdown (pcs, kg, litre, ml, strips) | ❌ Optional |
| Notes | Text area | ❌ Optional |
| Product Image | Camera / Gallery | ❌ Optional |
| Barcode | Auto-filled or manual | ❌ Optional |

---

### 📦 5. Inventory List

| Feature | Detail |
|---|---|
| Search bar | Search products by name |
| Filter pills | Filter by: All, Safe, Expiring Soon, Expired |
| Sort options | Sort by: Expiry date, Name, Date added, Category |
| Product cards | Each card shows: Name, Category, Qty, Expiry status badge |
| Status badges | 🟢 Safe (>7 days) · 🟡 Warning (3-7 days) · 🔴 Expiring (<3 days) · ⚫ Expired |
| Swipe actions | Swipe left to delete, swipe right to mark as consumed |
| Bulk actions | Select multiple items to delete or mark as used |

---

### 🔔 6. Notifications & Alerts

| Alert Type | When | Priority |
|---|---|---|
| **7-day warning** | Product expires in 7 days | Low (silent) |
| **3-day warning** | Product expires in 3 days | Medium |
| **1-day warning** | Product expires tomorrow | High |
| **Expiry day** | Product expires today | Critical |
| **Post-expiry** | Product expired yesterday | Info (cleanup reminder) |

Additional notification features:
- Custom alert timing (user can choose when to be notified)
- Morning daily summary (optional digest of all expiring items)
- Do Not Disturb respect
- Push notifications (FCM)
- In-app notification center with history

---

### 🗂️ 7. Categories

| Default Categories | Icon |
|---|---|
| Dairy | 🥛 |
| Bakery | 🍞 |
| Fruits & Vegetables | 🍎 |
| Meat & Seafood | 🥩 |
| Beverages | 🥤 |
| Snacks | 🍿 |
| Frozen Food | 🧊 |
| Medicines | 💊 |
| Cosmetics & Personal Care | 🧴 |
| Baby Products | 🍼 |
| Supplements | 💪 |
| Others | 📦 |

- Users can **create custom categories**
- Each category has a color tag for visual identification
- Category-wise product count on dashboard

---

### 👤 8. Profile & Settings

| Setting | Detail |
|---|---|
| Edit name & phone | Update personal information |
| Profile photo | Upload or take photo |
| Default reminder timing | Set global notification preferences |
| App theme | Light mode / Dark mode toggle |
| Language | English, Hindi (future: more languages) |
| Data backup | Backup data to cloud |
| Export data | Export inventory as CSV / PDF |
| Clear all data | Reset app with confirmation |
| App version & help | About page, FAQ, contact support |
| Rate the app | Redirect to Play Store |
| Share app | Share download link with friends |

---

## 🎨 Design & Theme

| Token | Value |
|---|---|
| **Primary Color** | `#6F2FED` (Purple) |
| **Primary Dark** | `#5A24C6` |
| **Secondary / Accent** | `#A1E510` (Lime Green) |
| **Background** | `#F5F5F5` (Light Grey) |
| **Surface / Cards** | `#FFFFFF` (White) |
| **Text Primary** | `#1A1A2E` |
| **Text Secondary** | `#666666` |
| **Success** | `#08875D` (Green) |
| **Warning** | `#FF8C00` (Orange) |
| **Danger / Error** | `#E02D3C` (Red) |
| **Border** | `#E0E0E0` |
| **Font Family** | Mulish (Google Fonts) |
| **Corner Radius (Buttons)** | 12px |
| **Corner Radius (Cards)** | 16px |
| **Corner Radius (Input)** | 12px |
| **Button Height** | 46px |
| **Input Height** | 46px |
| **Bottom Nav Height** | 80px |
| **Screen Size (Design)** | 375 × 812 (iPhone frame) |

---

## 🛠️ Tech Stack (Recommended)

| Layer | Technology |
|---|---|
| **Frontend** | React Native / Flutter |
| **State Management** | Redux Toolkit / Provider |
| **Backend** | Node.js + Express / Firebase |
| **Database** | Firebase Firestore / MongoDB |
| **Authentication** | Firebase Auth (Phone OTP) |
| **Push Notifications** | Firebase Cloud Messaging (FCM) |
| **Barcode Scanning** | ML Kit / ZXing library |
| **Image Storage** | Firebase Storage / Cloudinary |
| **Local Storage** | AsyncStorage / SQLite |
| **Analytics** | Firebase Analytics |
| **CI/CD** | GitHub Actions |

---

## 📊 Data Model

### User
```
{
  id: string
  phone: string
  name: string
  profileImage: string (URL)
  createdAt: timestamp
  settings: {
    theme: "light" | "dark"
    notifyBefore: [1, 3, 7]  // days before expiry
    dailySummary: boolean
    language: "en" | "hi"
  }
}
```

### Product
```
{
  id: string
  userId: string
  name: string
  category: string
  barcode: string (optional)
  expiryDate: date
  manufacturingDate: date (optional)
  quantity: number
  unit: string
  notes: string (optional)
  image: string (URL, optional)
  status: "safe" | "warning" | "expiring" | "expired"
  isConsumed: boolean
  createdAt: timestamp
  updatedAt: timestamp
}
```

### Notification
```
{
  id: string
  userId: string
  productId: string
  type: "7day" | "3day" | "1day" | "today" | "expired"
  title: string
  body: string
  isRead: boolean
  sentAt: timestamp
}
```

---

## 📈 Future Scope (v2+)

| Feature | Description |
|---|---|
| **Family sharing** | Share inventory with family members |
| **Shopping list** | Auto-generate shopping list from expired/consumed items |
| **Recipe suggestions** | Suggest recipes using items about to expire |
| **Price tracking** | Track how much money was wasted on expired products |
| **Store locator** | Find nearby stores to quickly replace expired essentials |
| **Voice input** | Add products via voice commands |
| **Widget** | Home screen widget showing expiring items count |
| **Wear OS / Watch** | Quick glance alerts on smartwatch |
| **Multi-language** | Support for 10+ regional languages |
| **AI-powered OCR** | Scan expiry date directly from product packaging |

---

## 📋 Summary

| Item | Detail |
|---|---|
| **App Name** | ShelfGuard |
| **Tagline** | Track it. Get alerted. Never waste again. |
| **Platform** | Android (primary), iOS (future) |
| **Total Screens** | 12-15 screens |
| **Core Features** | Barcode scan, Manual add, Smart alerts, Inventory management |
| **Unique Selling Point** | Simplest way to never let food or medicine expire unnoticed |
| **Monetization** | Freemium (free for 50 items, premium for unlimited + cloud backup) |

---

*Document created for ShelfGuard project planning and development reference.*
