import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/workspace_provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/pantry_background.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/figma_header.dart';
import '../../home/screens/home_screen.dart';
import '../widgets/setup_step_account_type.dart';
import '../widgets/setup_step_workspace_details.dart';
import '../widgets/setup_step_team_alerts.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();
  final TextEditingController _gstinController = TextEditingController();

  int _currentStep = 1;
  String _selectedAccountType = 'personal';

  // Step 2 State
  bool _isCreatingWorkspace = true;
  String _selectedStoreType = '';
  String _selectedTeamSize = '';
  bool _hasLogo = false;

  // Step 3 State
  List<String> _selectedAlertDays = ['1', '3'];
  String _selectedAlertTime = '8:00 AM';
  List<Map<String, String>> _staffList = [];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateValidation);
    _inviteCodeController.addListener(_updateValidation);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _inviteCodeController.dispose();
    _gstinController.dispose();
    super.dispose();
  }

  void _updateValidation() {
    setState(() {}); // Triggers build to evaluate continue button active state
  }

  bool _isNextEnabled() {
    if (_currentStep == 1) {
      return _selectedAccountType.isNotEmpty;
    }
    if (_currentStep == 2) {
      if (_selectedAccountType == 'personal') {
        return _nameController.text.trim().isNotEmpty;
      }
      if (_selectedAccountType == 'business') {
        if (_isCreatingWorkspace) {
          return _nameController.text.trim().isNotEmpty &&
              _selectedStoreType.isNotEmpty;
        } else {
          return _inviteCodeController.text.trim().length >= 6;
        }
      }
    }
    if (_currentStep == 3) {
      if (_selectedAccountType == 'personal') {
        return _selectedAlertDays.isNotEmpty;
      }
      return true; // Staff/team details are optional to complete business setup
    }
    return false;
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeSetup();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _completeSetup() {
    final workspaceProvider = context.read<WorkspaceProvider>();

    if (_selectedAccountType == 'personal') {
      workspaceProvider.setupPersonalWorkspace(
        name: _nameController.text.trim(),
        alertDays: _selectedAlertDays,
        alertTime: _selectedAlertTime,
      );
    } else {
      if (_isCreatingWorkspace) {
        workspaceProvider.setupBusinessWorkspace(
          userName: _nameController.text.trim(),
          workspaceName: _nameController.text.trim(),
          storeCategory: _selectedStoreType,
          teamSize: _selectedTeamSize,
          hasLogo: _hasLogo,
          staffList: _staffList,
        );
      } else {
        workspaceProvider.joinBusinessWorkspace(
          userName: _nameController.text.trim(),
          inviteCode: _inviteCodeController.text.trim(),
        );
      }
    }

    // Navigate straight to dashboard
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'Choose Account';
      case 2:
        if (_selectedAccountType == 'personal') {
          return 'Personal Profile';
        } else {
          return _isCreatingWorkspace ? 'Store Setup' : 'Join Workspace';
        }
      case 3:
        if (_selectedAccountType == 'personal') {
          return 'Alert Settings';
        } else {
          return _isCreatingWorkspace ? 'Team Setup' : 'Confirm Join';
        }
      default:
        return 'Setup';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PantryBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Figma Navigation Header at the top (with top-left back button)
            FigmaHeader(
              title: _getStepTitle(),
              onBackPressed: _currentStep > 1 ? _prevStep : null,
            ),
            // 2. Premium Segmented Progress Indicator (Apple-style segmented stepper)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step $_currentStep of 3',
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8E8E93),
                          letterSpacing: 0.2,
                        ),
                      ),
                      Text(
                        _currentStep == 1
                            ? AppStrings.stepLabelAccount
                            : (_currentStep == 2
                                  ? AppStrings.stepLabelDetails
                                  : AppStrings.stepLabelPreferences),
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(3, (index) {
                      final bool isActiveOrPassed = index < _currentStep;
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOutCubic,
                          margin: EdgeInsets.only(right: index == 2 ? 0 : 8.0),
                          height: 3.5,
                          decoration: BoxDecoration(
                            color: isActiveOrPassed
                                ? AppColors.primary
                                : AppColors.borderLight,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // 3. Setup Step Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Block swipes to enforce validations
                children: [
                  SetupStepAccountType(
                    selectedType: _selectedAccountType,
                    onSelected: (type) {
                      setState(() {
                        _selectedAccountType = type;
                      });
                    },
                  ),
                  SetupStepWorkspaceDetails(
                    accountType: _selectedAccountType,
                    isCreatingWorkspace: _isCreatingWorkspace,
                    onCreatingWorkspaceChanged: (val) {
                      setState(() {
                        _isCreatingWorkspace = val;
                      });
                    },
                    nameController: _nameController,
                    inviteCodeController: _inviteCodeController,
                    gstinController: _gstinController,
                    selectedStoreType: _selectedStoreType,
                    onStoreTypeChanged: (type) {
                      setState(() {
                        _selectedStoreType = type;
                      });
                    },
                    selectedTeamSize: _selectedTeamSize,
                    onTeamSizeChanged: (size) {
                      setState(() {
                        _selectedTeamSize = size;
                      });
                    },
                    hasLogo: _hasLogo,
                    onLogoChanged: (logo) {
                      setState(() {
                        _hasLogo = logo;
                      });
                    },
                  ),
                  SetupStepTeamAlerts(
                    accountType: _selectedAccountType,
                    isCreatingWorkspace: _isCreatingWorkspace,
                    workspaceName: _nameController.text,
                    storeCategory: _selectedStoreType,
                    selectedAlertDays: _selectedAlertDays,
                    onAlertDaysChanged: (days) {
                      setState(() {
                        _selectedAlertDays = days;
                      });
                    },
                    selectedAlertTime: _selectedAlertTime,
                    onAlertTimeChanged: (time) {
                      setState(() {
                        _selectedAlertTime = time;
                      });
                    },
                    staffList: _staffList,
                    onStaffListChanged: (list) {
                      setState(() {
                        _staffList = list;
                      });
                    },
                  ),
                ],
              ),
            ),

            // 4. Primary bottom action button (Full-width pinned bottom)
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
              child: PrimaryButton(
                text: _currentStep == 3
                    ? AppStrings.getStartedButton
                    : AppStrings.nextStepButton,
                onPressed: _isNextEnabled() ? _nextStep : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
