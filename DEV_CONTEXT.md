# 🛡️ ShelfGuard Developer Context (devcontext)

This file maintains the active context of the ShelfGuard Flutter application, outlining styling paradigms, layout patterns, resolved issues, and developer guidelines.

---

## 📌 Technical Specification

- **Core**: Flutter / Dart
- **Base UI Philosophy**: Premium Cupertino-like Apple aesthetics. Ripple-free, tactile scale/fade feedback on interaction. Elegant glassmorphism, subtle micro-animations, and soft drop shadows.
- **Color tokens**: Configured in [app_colors.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/core/theme/app_colors.dart)
  - `primary`: `#6F2FED` (Purple)
  - `secondary`: `#A1E510` (Lime Accent)
  - `borderLight`: `#E5E5EA` (Light Grey borders)
  - `badgeBackground`: `#F1F3F6` (Chip background fill)
  - `badgeText`: `#666666` (Chip grey text)
  - `inputBgLight`: `#F8FAFC` (Input field light background)
- **Typography**: `Mulish` local font family configured in [app_typography.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/core/theme/app_typography.dart).
- **Core Rule**: **NO hardcoded strings or raw hexadecimal color values** inside widget build methods. Always use `AppStrings` from [app_strings.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/core/constants/app_strings.dart) and `AppColors` from [app_colors.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/core/theme/app_colors.dart).

---

## 🔄 User Onboarding Setup Flow

The onboarding workspace setup flow consists of 3 distinct step screens with 2 distinct paths (Personal and Business):
1. **Step 1: Choose Account Type** — Selects between Personal/Home and Business/Org using compact vertical cards with custom outline icons and double-circle radio checked indicators.
2. **Step 2: Workspace Details** —
   - **Personal (B2C)**: Centered circular profile photo picker at the top with dashed border, followed by a clean, icon-free Full Name text field. No avatar grids are used.
   - **Business (B2B)**: 80x80 rounded-square logo picker (16px corner radius) next to the Store Name field in a horizontal Row, followed by Store Category dropdown, GSTIN field, and Team Size dropdown.
   - **Image pickers**: Both pickers utilize a dashed border (`DashedCirclePainter` / `DashedRectPainter` with `foregroundPainter`) and the custom camera SVG asset tinted in brand purple (`AppColors.primary`).
3. **Step 3: Alerts & Team Setup** —
   - **Personal (B2C)**: Alert days checklist and preferred daily notification time chips.
   - **Business (B2B)**: Approach A (Full-Screen Inline Form). Displays a copyable invite code and share link card at the top, an inline Direct Invitation form card (Email/Phone text field and Assign Role dropdown) with a direct "Send Invitation" action button, and a Teammates list card container showing members separated by thin light-gray dashed dividers (`DashedDivider`). No bottom sheets or separate invite buttons are used.

---

## 🛠️ Issues Raised & Solutions Implemented

Today, we resolved several critical layout, aesthetic, and architectural issues in the setup flow:

### 1. Vertical Layout Overflows (Step 3 Team Setup)
- **Issue**: Toggling the soft keyboard or adding multiple staff members triggered a vertical layout overflow crash. The list of members was wrapped in an `Expanded` widget inside a constrained `Column`, leaving no room for growth.
- **Solution**: Refactored [setup_step_team_alerts.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/features/auth/widgets/setup_step_team_alerts.dart) to replace the constrained parent `Column` with a `SingleChildScrollView`. Removed the `Expanded` wrapper and rendered the added team list inline. The entire form now scrolls naturally when inputs are active or when the list grows.

### 2. Horizontal Layout Overflows (Long Names in List)
- **Issue**: Adding a staff member with a long name (e.g. "Ahmed iqbal teli") pushed the role badge and trash icon off-screen, causing a horizontal overflow error.
- **Solution**: Wrapped the text details `Column` in `Expanded` inside the staff list item card and added `maxLines: 1` and `overflow: TextOverflow.ellipsis` to the name text. This ensures the name truncates cleanly with ellipses instead of pushing elements off-screen.

### 3. Harsh Avatar Shadows
- **Issue**: Circular initials badges had a high-contrast black drop shadow (`alpha: 0.25` with `blurRadius: 4`) that looked unpolished.
- **Solution**: Softened the avatar shadow in [setup_step_team_alerts.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/features/auth/widgets/setup_step_team_alerts.dart) to `AppColors.primary.withValues(alpha: 0.1)` with `blurRadius: 6` and `offset: Offset(0, 3)`. This gives a premium, soft purple visual depth.

### 4. Segmented Progress Bar / Header Stepper
- **Issue**: The onboarding progress indicator was a generic single progress line. The headers also had duplicated overlines like `'STEP 3 OF 3'` inside the page contents.
- **Solution**: Created a custom segmented progress stepper row in [profile_setup_screen.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/features/auth/screens/profile_setup_screen.dart) matching the Figma mockup. It displays the step progress text (e.g., `'Step 3 of 3'`) on the left, the step label (e.g., `'Preferences'`) in purple on the right, and three separate capsule indicators with animation support. Removed the duplicate overline headers inside all step widgets.

### 5. Smooth Button State Transitions
- **Issue**: When transitioning the primary bottom button between enabled and disabled states, the color changed abruptly without animation.
- **Solution**: Converted the static `Container` inside [primary_button.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/shared/widgets/primary_button.dart) to `AnimatedContainer` and wrapped the text in `AnimatedDefaultTextStyle`. Transitions between active and disabled states are now smoothly animated over `200ms`.

### 6. OTP Verification Input Centering
- **Issue**: Character digits were not aligning properly inside the OTP verification boxes.
- **Solution**: Positioned a completely transparent `TextField` on top of static character containers inside [otp_input_row.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/features/auth/widgets/otp_input_row.dart). This guarantees perfect horizontal and vertical text centering.

### 7. Implementation of Approach A Inline Team Invitation (Step 3 B2B)
- **Issue**: Tapping a button to open a bottom sheet modal for direct team invitations added friction and extra navigation steps.
- **Solution**: Completely removed the bottom sheet invite modal and placed the Direct Invitation input fields (Email/Phone and Role selection) directly on the screen inside a clean white card container above the teammates list. Tapping "Send Invitation" adds the member as a "Pending" invitee inline, clears the input fields, and dismisses the keyboard context.

---

## 🔍 Validation Protocol

Before making commits or launching the app, run the following checks from the project root:

1. **Static Analysis**:
   ```bash
   flutter analyze
   ```
   Must return `No issues found!`.

2. **Code Formatting**:
   ```bash
   dart format .
   ```
   All files must conform to standard Flutter formatting.

---

## 🏗️ State Management & Dashboard Flow

We integrated the onboarding state with the main application shell using a global state provider:

### 1. Global Workspace Provider
- Created `WorkspaceProvider` to store the active user name, account type (personal/business), active workspace details, team details, and the list of inventory products.
- Registered globally in [main.dart](file:///Users/ahmedteli/Desktop/flutter_development/shelfguard/lib/main.dart).
- Saves workspace state when the user completes step 3 of onboarding, dynamically populating the mock products dataset:
  - **Personal**:Groceries like milk, eggs, bread, and yogurt.
  - **Business**:Pharmacy medicines and produce, customized with large quantities.

### 2. Dynamic Dashboard Header & Summary Stats
- Refactored `DashboardHeader` to read from the provider. Dynamically displays the user's name, active workspace type/title, and auto-generates avatar initials from their full name.
- Refactored `SummaryCardsGrid` to dynamically calculate counts (Total, Expiring Soon, Expired, and Safe) directly from the list of products in the provider.
- Refactored `RecentActivityList` to list actual items sorted by creation time, with customized status colors, icons, and relative time-ago strings (e.g., "Just now", "2h ago"). If the product list is empty, a premium empty state container is rendered.

### 3. Add Product & Scanning Actions
- Created `AddProductSheet` containing full form validations, customized purple-themed date picker dialog, and dropdown category fields matching audited design guidelines.
- Modified the main floating action button and the quick actions bar to open the product sheet.
- Integrated a simulated barcode scanner modal sheet that mimics aligning a barcode inside a frame, plays a brief delay, and opens the product sheet with the scanned barcode pre-filled.
