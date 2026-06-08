import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CountryModel {
  final String name;
  final String code;
  final String flag;

  const CountryModel({
    required this.name,
    required this.code,
    required this.flag,
  });
}

const List<CountryModel> kCountries = [
  CountryModel(name: 'India', code: '+91', flag: '🇮🇳'),
  CountryModel(name: 'United States', code: '+1', flag: '🇺🇸'),
  CountryModel(name: 'United Kingdom', code: '+44', flag: '🇬🇧'),
  CountryModel(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪'),
  CountryModel(name: 'Canada', code: '+1', flag: '🇨🇦'),
  CountryModel(name: 'Australia', code: '+61', flag: '🇦🇺'),
  CountryModel(name: 'Singapore', code: '+65', flag: '🇸🇬'),
  CountryModel(name: 'Germany', code: '+49', flag: '🇩🇪'),
  CountryModel(name: 'France', code: '+33', flag: '🇫🇷'),
  CountryModel(name: 'Japan', code: '+81', flag: '🇯🇵'),
  CountryModel(name: 'Saudi Arabia', code: '+966', flag: '🇸🇦'),
];

const List<CountryModel> kPopularCountries = [
  CountryModel(name: 'India', code: '+91', flag: '🇮🇳'),
  CountryModel(name: 'United States', code: '+1', flag: '🇺🇸'),
  CountryModel(name: 'United Kingdom', code: '+44', flag: '🇬🇧'),
  CountryModel(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪'),
  CountryModel(name: 'Canada', code: '+1', flag: '🇨🇦'),
  CountryModel(name: 'Singapore', code: '+65', flag: '🇸🇬'),
];

class CountryPickerBottomSheet extends StatefulWidget {
  final String selectedCode;
  final ValueChanged<CountryModel> onCountrySelected;

  const CountryPickerBottomSheet({
    super.key,
    required this.selectedCode,
    required this.onCountrySelected,
  });

  @override
  State<CountryPickerBottomSheet> createState() =>
      _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  final _searchController = TextEditingController();
  List<CountryModel> _filteredCountries = List.from(kCountries);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = List.from(kCountries);
      } else {
        _filteredCountries = kCountries.where((country) {
          return country.name.toLowerCase().contains(query) ||
              country.code.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic height constraints to scale layout dynamically according to keyboard status
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Bottom sheet fits maximum 82% of screen height minus keyboard height
    final double maxSheetHeight = (screenHeight - keyboardHeight) * 0.82;

    return Padding(
      padding: EdgeInsets.only(
        bottom: keyboardHeight,
      ), // Pushes sheet above keyboard
      child: Container(
        constraints: BoxConstraints(maxHeight: maxSheetHeight),
        // Flush-to-bottom layout with rounded top corners only
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Drag Handle
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 38,
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D1D6),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Centered Header Title
            Center(
              child: Text(
                'Select Country',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // 3. Capsule Search Bar (snug spacing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: const Color(0xFFE5E5EA),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      color: Color(0xFF8E8E93),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Icon(
                        Icons.search_rounded,
                        color: Color(0xFF8E8E93),
                        size: 22,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 46,
                      minHeight: 24,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 14.0, left: 8.0),
                              child: Icon(
                                Icons.cancel_rounded,
                                color: AppColors.textSecondary,
                                size: 18,
                              ),
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 24,
                    ),
                    filled: false,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // 4. Horizontal Popular Country Chips Selector
            if (_searchController.text.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'POPULAR COUNTRIES',
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8E8E93),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  itemCount: kPopularCountries.length,
                  itemBuilder: (context, index) {
                    final country = kPopularCountries[index];
                    final isSelected = country.code == widget.selectedCode;

                    return GestureDetector(
                      onTap: () {
                        widget.onCountrySelected(country);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.08)
                              : const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(
                            19,
                          ), // Chip capsule shape
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : const Color(0xFFE5E5EA),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country.flag,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${country.name} (${country.code})',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(color: Color(0xFFF2F2F7), height: 1),
              ),
              const SizedBox(height: 12),
            ],

            // 5. Vertical Country List (Remaining space)
            Flexible(
              child: _filteredCountries.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          'No countries found',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredCountries.length,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        4.0,
                        16.0,
                        24.0,
                      ), // Safe area bottom padding
                      itemBuilder: (context, index) {
                        final country = _filteredCountries[index];
                        final isSelected = country.code == widget.selectedCode;

                        return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  widget.onCountrySelected(country);
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 14.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withValues(
                                            alpha: 0.05,
                                          )
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      if (isSelected)
                                        Container(
                                          width: 3.5,
                                          height: 22,
                                          margin: const EdgeInsets.only(
                                            right: 12.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),

                                      Text(
                                        country.flag,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          country.name,
                                          style: AppTypography.bodyLarge
                                              .copyWith(
                                                fontWeight: isSelected
                                                    ? FontWeight.w700
                                                    : FontWeight.w600,
                                                color: AppColors.textPrimary,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        country.code,
                                        style: AppTypography.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.textSecondary,
                                            ),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 12),
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColors.primary,
                                          size: 20,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 250.ms, delay: (index * 20).ms)
                            .slideY(
                              begin: 0.08,
                              end: 0.0,
                              duration: 250.ms,
                              delay: (index * 20).ms,
                              curve: Curves.easeOutCubic,
                            );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
