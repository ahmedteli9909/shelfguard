import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/cupertino_dropdown_field.dart';
import '../../../shared/widgets/cupertino_pressable.dart';
import '../../../shared/widgets/dashed_border_painters.dart';

String getInitials(String name) {
  if (name.isEmpty) return 'U';
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.length > 1) {
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
  return parts[0][0].toUpperCase();
}

class SetupStepTeamAlerts extends StatefulWidget {
  final String accountType;
  final bool isCreatingWorkspace;
  final String workspaceName;
  final String storeCategory;
  final List<String> selectedAlertDays;
  final ValueChanged<List<String>> onAlertDaysChanged;
  final String selectedAlertTime;
  final ValueChanged<String> onAlertTimeChanged;
  final List<Map<String, String>> staffList;
  final ValueChanged<List<Map<String, String>>> onStaffListChanged;

  const SetupStepTeamAlerts({
    super.key,
    required this.accountType,
    required this.isCreatingWorkspace,
    required this.workspaceName,
    required this.storeCategory,
    required this.selectedAlertDays,
    required this.onAlertDaysChanged,
    required this.selectedAlertTime,
    required this.onAlertTimeChanged,
    required this.staffList,
    required this.onStaffListChanged,
  });

  @override
  State<SetupStepTeamAlerts> createState() => _SetupStepTeamAlertsState();
}

class _SetupStepTeamAlertsState extends State<SetupStepTeamAlerts> {
  final TextEditingController _inviteEmailOrPhoneController =
      TextEditingController();
  String _inviteRole = 'Stock Assistant';

  @override
  void dispose() {
    _inviteEmailOrPhoneController.dispose();
    super.dispose();
  }

  LinearGradient _getAvatarGradient(int index) {
    final List<List<Color>> gradients = [
      [const Color(0xFFA393F5), const Color(0xFF735CE6)], // Purple-blue
      [const Color(0xFFC48AFF), const Color(0xFFAA65F0)], // Lavender-purple
      [const Color(0xFF50C750), const Color(0xFF32B332)], // Green
      [const Color(0xFFFFB73D), const Color(0xFFFFA000)], // Orange-gold
      [const Color(0xFF65C2C2), const Color(0xFF86D1D1)], // Cyan-teal
    ];
    final selected = gradients[index % gradients.length];
    return LinearGradient(
      colors: selected,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  String _getInviteCode() {
    if (widget.workspaceName.isEmpty) return 'SG-984210';
    final cleanName = widget.workspaceName
        .replaceAll(RegExp(r'[^a-zA-Z]'), '')
        .toUpperCase();
    final prefix = cleanName.length >= 3 ? cleanName.substring(0, 3) : 'SG';
    return '$prefix-742918';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Code copied to clipboard!',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Removed _showInviteBottomSheet as direct inline invitation form is now used.

  void _removeStaff(int index) {
    final updatedList = List<Map<String, String>>.from(widget.staffList)
      ..removeAt(index);
    widget.onStaffListChanged(updatedList);
  }

  Widget _buildCheckIndicator(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFFC7C7CC),
          width: isSelected ? 1.5 : 1.2,
        ),
        color: isSelected ? AppColors.primary : Colors.transparent,
      ),
      child: isSelected
          ? const Center(
              child: Icon(Icons.check_rounded, color: Colors.white, size: 13),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.accountType == 'personal') {
      return _buildPersonalAlerts();
    } else {
      if (widget.isCreatingWorkspace) {
        return _buildBusinessStaff();
      } else {
        return _buildJoinConfirmation();
      }
    }
  }

  // -------------------------------------------------------------
  // 1. Personal Alerts Config (B2C)
  // -------------------------------------------------------------
  Widget _buildPersonalAlerts() {
    final List<Map<String, String>> alertOptions = [
      {
        'val': '7',
        'label': AppStrings.alertWindow7Days,
        'desc': AppStrings.alertWindow7DaysDesc,
      },
      {
        'val': '3',
        'label': AppStrings.alertWindow3Days,
        'desc': AppStrings.alertWindow3DaysDesc,
      },
      {
        'val': '1',
        'label': AppStrings.alertWindow1Day,
        'desc': AppStrings.alertWindow1DayDesc,
      },
    ];

    final List<String> times = ['8:00 AM', '1:00 PM', '7:00 PM'];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              AppStrings.selectAlertWindowsLabel,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLightFigma),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadowColor,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: alertOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final opt = entry.value;
                  final isSelected = widget.selectedAlertDays.contains(
                    opt['val'],
                  );
                  return Column(
                    children: [
                      CupertinoPressable(
                        onTap: () {
                          final updated = List<String>.from(
                            widget.selectedAlertDays,
                          );
                          if (isSelected) {
                            updated.remove(opt['val']);
                          } else {
                            updated.add(opt['val']!);
                          }
                          widget.onAlertDaysChanged(updated);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.02)
                              : Colors.transparent,
                          child: Row(
                            children: [
                              _buildCheckIndicator(isSelected),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt['label']!,
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14.5,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      opt['desc']!,
                                      style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index < alertOptions.length - 1)
                        const DashedDivider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
            const SizedBox(height: 24),

            Text(
              AppStrings.preferredDailyTimeLabel,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 120.ms),
            const SizedBox(height: 10),

            Row(
              children: times.map((t) {
                final isSelected = widget.selectedAlertTime == t;
                return Expanded(
                  child: CupertinoPressable(
                    onTap: () => widget.onAlertTimeChanged(t),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.borderLightFigma,
                          width: 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        t,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // 2. Business Staff Setup (B2B)
  // -------------------------------------------------------------
  Widget _buildBusinessStaff() {
    final inviteCode = _getInviteCode();
    final inviteLink = 'shelfguard.app/join/$inviteCode';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text(
              AppStrings.storeTeamTitle,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              AppStrings.storeTeamSubtitle,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Card for Invite Code & Share Link (Clean and unified)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLightFigma),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadowColor,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.vpn_key_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Invite Code',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textHint,
                              ),
                            ),
                            Text(
                              inviteCode,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CupertinoPressable(
                    onTap: () => _copyToClipboard(inviteCode),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.copy_rounded,
                            color: AppColors.primary,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Copy',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CupertinoPressable(
                    onTap: () => _copyToClipboard(inviteLink),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.bgTintFigma,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: AppColors.textHint,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 50.ms),
            const SizedBox(height: 20),

            // Direct Invitation Form Card (Inline)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLightFigma),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadowColor,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Direct Invitation',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    label: 'Email or Mobile Number',
                    hintText: 'Enter email or mobile number',
                    controller: _inviteEmailOrPhoneController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  CupertinoDropdownField<String>(
                    label: AppStrings.assignRoleLabel,
                    hintText: AppStrings.selectRoleHint,
                    value: _inviteRole,
                    items: AppStrings.staffRoles,
                    itemToString: (role) => role,
                    onChanged: (val) {
                      setState(() {
                        _inviteRole = val;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CupertinoPressable(
                    onTap: () {
                      final contact = _inviteEmailOrPhoneController.text.trim();
                      if (contact.isNotEmpty) {
                        final newStaff = {
                          'name': contact,
                          'role': _inviteRole,
                          'status': 'Pending',
                        };
                        final updatedList = List<Map<String, String>>.from(
                          widget.staffList,
                        )..add(newStaff);
                        widget.onStaffListChanged(updatedList);
                        _inviteEmailOrPhoneController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Send Invitation',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 20),

            // Teammates Card Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLightFigma),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadowColor,
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Workspace Team (${widget.staffList.length + 1})',
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 1. Creator/Owner
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Y',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'You',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          'Active',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (widget.staffList.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const DashedDivider(height: 1),
                    const SizedBox(height: 12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.staffList.length,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: DashedDivider(height: 1),
                      ),
                      itemBuilder: (context, index) {
                        final staff = widget.staffList[index];
                        return _buildStaffRow(staff, index);
                      },
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffRow(Map<String, String> staff, int index) {
    final nameOrEmail = staff['name'] ?? '';
    final initials = getInitials(nameOrEmail);

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: _getAvatarGradient(index),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              fontFamily: 'Mulish',
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            nameOrEmail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.bgTintFigma,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            staff['role'] ?? 'Stock Assistant',
            style: const TextStyle(
              fontFamily: 'Mulish',
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7), // Light amber pending
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Text(
            'Pending',
            style: TextStyle(
              fontFamily: 'Mulish',
              color: AppColors.warning,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 6),
        CupertinoPressable(
          onTap: () => _removeStaff(index),
          child: const Padding(
            padding: EdgeInsets.all(6.0),
            child: Icon(Icons.close_rounded, color: AppColors.danger, size: 18),
          ),
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // 3. Business Join Confirmation (Join Path)
  // -------------------------------------------------------------
  Widget _buildJoinConfirmation() {
    final List<Map<String, String>> mockTeammates = [
      {'name': 'Sarah Connor', 'role': 'Store Manager'},
      {'name': 'David Miller', 'role': 'Stock Assistant'},
      {'name': 'Emma Watson', 'role': 'Cashier'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.12),
                        width: 1.0,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      color: AppColors.success,
                      size: 28,
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 450.ms)
                .scale(begin: const Offset(0.85, 0.85)),
            const SizedBox(height: 12),
            Center(
              child: Text(
                AppStrings.joinedWorkspaceTitle,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 80.ms),
            const SizedBox(height: 4),
            Center(
              child: Text(
                AppStrings.joinedWorkspaceSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 120.ms),
            const SizedBox(height: 20),

            Text(
              AppStrings.joinedStoreCardHeader,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLightFigma),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadowColor,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ShelfGuard Pharmacy',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkText,
                            fontSize: 14.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Pharmacy / Medical Shop',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 180.ms),
            const SizedBox(height: 20),

            Text(
              AppStrings.joinedTeammatesHeader,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLightFigma),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadowColor,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: List.generate(mockTeammates.length, (index) {
                  final teammate = mockTeammates[index];
                  final initials = getInitials(teammate['name']!);
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                gradient: _getAvatarGradient(index),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initials,
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                teammate['name']!,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.darkText,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bgTintFigma,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                teammate['role']!,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  color: AppColors.textHint,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (index < mockTeammates.length - 1)
                        const DashedDivider(height: 1),
                    ],
                  );
                }),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 220.ms),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
