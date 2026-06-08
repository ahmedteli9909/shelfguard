class AppStrings {
  // App General
  static const String appName = 'ShelfGuard';

  // Splash Screen
  static const String splashTagline =
      'Track it. Get alerted. Never waste again.';

  // Phone Auth Screen
  static const String phoneAuthTitle = 'Enter your mobile number';
  static const String phoneAuthSubtitle =
      'We will send you a confirmation code';
  static const String phoneHint = 'Phone Number';
  static const String continueButton = 'Continue';
  static const String countryCode = '+91';

  // OTP Verification Screen
  static const String otpTitle = 'Verification Code';
  static const String otpSubtitle = 'We have sent the code verification to';
  static const String verifyButton = 'Verify';
  static const String resendCode = 'Resend Code';
  static const String didntReceiveCode = "Didn't receive the code? ";

  // Workspace Setup Flow
  static const String setupTitle = 'Set up your Workspace';
  static const String setupSubtitle = 'Tell us how you want to use ShelfGuard';
  static const String personalUseTitle = 'Personal / Home';
  static const String personalUseDesc =
      'For personal homes, kitchen groceries, and family medicine tracking.';
  static const String storeUseTitle = 'Shop / Pharmacy';
  static const String storeUseDesc =
      'Track shelf-life for small shops, medical stores, and retail stock';
  static const String mallUseTitle = 'Mall / Supermarket';
  static const String mallUseDesc =
      'Enterprise-level tracking with team, staff roles, and departments';
  static const String nextStepButton = 'Next Step';
  static const String getStartedButton = 'Get Started';

  // Stepper Labels
  static const String stepLabelAccount = 'Account';
  static const String stepLabelDetails = 'Details';
  static const String stepLabelPreferences = 'Preferences';

  // Step 1: Account Type
  static const String accountTypeTitle = 'How will you use ShelfGuard?';
  static const String accountTypeSubtitle =
      'Select the account type that best fits your inventory tracking and team needs.';

  // Step 2: Workspace Details (Personal Profile Setup)
  static const String profileSetupTitle = 'Set up your Profile';
  static const String profileSetupSubtitle =
      'Upload a profile photo and enter your full name to personalize your account.';
  static const String fullNameLabel = 'Full Name';
  static const String fullNameHint = 'Enter your full name';

  // Step 2: Workspace Details (Store Setup)
  static const String storeSetupTitle = 'Set up your Store';
  static const String storeSetupSubtitle =
      'Enter your store details to organize shelf-life tracking for commercial stock.';
  static const String storeNameLabel = 'Store / Shop Name';
  static const String storeNameHint = 'Enter store or shop name';
  static const String storeCategoryLabel = 'Store Category';
  static const String storeCategoryHint = 'Select store category';

  // Step 2: Workspace Details (Supermarket Setup)
  static const String mallSetupTitle = 'Set up your Supermarket';
  static const String mallSetupSubtitle =
      'Enter your mall workspace name and select departments to coordinate tracking.';
  static const String mallNameLabel = 'Mall / Supermarket Name';
  static const String mallNameHint = 'Enter supermarket name';
  static const String activeDepartmentsLabel = 'Select Active Departments';

  // Step 3: Team & Alerts (Personal Alerts)
  static const String alertsSetupTitle = 'Alert Window Settings';
  static const String alertsSetupSubtitle =
      'Configure when and how ShelfGuard notifies you about expiring items.';
  static const String selectAlertWindowsLabel = 'Select Alert Windows';
  static const String preferredDailyTimeLabel = 'Preferred Daily Summary Time';

  // Step 3: Team & Alerts (Store Staff)
  static const String storeTeamTitle = 'Store Staff & Team';
  static const String storeTeamSubtitle =
      'Add staff members and assign their roles to manage inventory cooperatively.';

  // Step 3: Team & Alerts (Mall Team)
  static const String mallTeamTitle = 'Department Team Setup';
  static const String mallTeamSubtitle =
      'Invite staff members and assign them to specific departments and operational roles.';

  // Step 3: General Team Setup labels
  static const String staffNameLabel = 'Staff Member Full Name';
  static const String staffNameHint = 'Enter staff member full name';
  static const String assignRoleLabel = 'Assign Operational Role';
  static const String selectRoleHint = 'Select role';
  static const String selectDepartmentLabel = 'Select Department';
  static const String selectDepartmentHint = 'Select department';
  static const String addStaffButton = 'Add Staff Member';
  static const String noTeamMembersMessage = 'No team members added yet.';
  static const String departmentMemberLabel = 'Department Member';
  static const String storeTeamMemberLabel = 'Store Team Member';
  static const String addedTeamMembersLabel = 'Added Team Members';

  // Active Departments
  static const String deptProduce = 'Produce & Groceries';
  static const String deptPharmacy = 'Pharmacy Section';
  static const String deptCosmetics = 'Cosmetics Department';
  static const String deptDairy = 'Dairy & Food Court';
  static const String deptGeneral = 'General Storage';

  // Personal Alerts
  static const String alertWindow7Days = '7 Days Before';
  static const String alertWindow7DaysDesc = 'Perfect for pantry cleaning';
  static const String alertWindow3Days = '3 Days Before';
  static const String alertWindow3DaysDesc = 'Standard groceries warning';
  static const String alertWindow1Day = '1 Day Before';
  static const String alertWindow1DayDesc = 'Tomorrow\'s critical alert';

  // Step 1: Simplified Business title & description
  static const String businessUseTitle = 'Business / Org';
  static const String businessUseDesc =
      'For retail shops, pharmacy sections, and commercial store inventory.';

  // Step 2: Tab options
  static const String createWorkspaceTab = 'Create Workspace';
  static const String joinWorkspaceTab = 'Join Workspace';

  // Step 2: Business Setup & Join
  static const String inviteCodeLabel = 'Invite / Join Code';
  static const String inviteCodeHint = 'Enter SG-XXXXXX code';
  static const String inviteCodeNote =
      'Ask your store admin or manager for the invite code to link your account to this workspace.';
  static const String companyLogoLabel = 'Company Logo';
  static const String addLogoLabel = 'Add Logo';
  static const String gstinLabel = 'GSTIN / Business Registration (Optional)';
  static const String gstinHint = 'Enter business registration number';
  static const String teamSizeLabel = 'Estimated Team Size (Optional)';
  static const String teamSizeHint = 'Select estimated team size';

  // Onboarding Dropdown Items
  static const List<String> businessCategories = [
    'Grocery / Convenience Store',
    'Pharmacy / Medical Shop',
    'Cosmetics / Beauty Shop',
    'Supermarket / Mall',
    'General Retail / Wholesale',
  ];

  static const List<String> teamSizes = [
    '1 - 5 staff',
    '6 - 15 staff',
    '16 - 50 staff',
    '50+ staff',
  ];

  static const List<String> staffRoles = [
    'Store Manager',
    'Stock Assistant',
    'Cashier',
  ];

  // Step 3: Button short texts
  static const String addStaffShortButton = 'Add Staff';
  static const String saveButton = 'Save';
  static const String joinButton = 'Join';

  // Step 3: Join Confirmation Screen
  static const String joinedWorkspaceTitle = 'Workspace Linked!';
  static const String joinedWorkspaceSubtitle =
      'You have successfully joined the team and linked to this workspace.';
  static const String joinedStoreCardHeader = 'Joined Store Details';
  static const String joinedTeammatesHeader = 'Active Teammates';
  static const String joinedSuccessfullyMessage = 'Linked to';
}
