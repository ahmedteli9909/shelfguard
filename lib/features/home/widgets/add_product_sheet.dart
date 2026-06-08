import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/product.dart';
import '../../../core/providers/workspace_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';

class AddProductSheet extends StatefulWidget {
  final String? initialBarcode;

  const AddProductSheet({super.key, this.initialBarcode});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _locationController = TextEditingController();
  final _barcodeController = TextEditingController();

  DateTime? _selectedDate;
  String _selectedCategory = 'Dairy & Food Court';

  final List<String> _categories = [
    'Produce & Groceries',
    'Pharmacy Section',
    'Cosmetics Department',
    'Dairy & Food Court',
    'General Storage',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialBarcode != null) {
      _barcodeController.text = widget.initialBarcode!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: const TextStyle(
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveProduct() {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an expiry date'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final workspaceProvider = context.read<WorkspaceProvider>();
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      expiryDate: _selectedDate!,
      quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
      category: _selectedCategory,
      location: _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : 'General Storage',
      barcode: _barcodeController.text.trim().isNotEmpty
          ? _barcodeController.text.trim()
          : null,
      addedAt: DateTime.now(),
    );

    workspaceProvider.addProduct(newProduct);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newProduct.name} added successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Product',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  fontFamily: 'Mulish',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Product Name',
                hintText: 'e.g. Milk, Paracetamol, Bread',
                controller: _nameController,
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Enter a product name'
                    : null,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expiry Date',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLightFigma),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadowColor,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                              color: _selectedDate == null
                                  ? AppColors.textHint
                                  : AppColors.darkText,
                              fontWeight: _selectedDate == null
                                  ? FontWeight.w400
                                  : FontWeight.w700,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Quantity',
                      hintText: 'e.g. 1',
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(val.trim()) == null) {
                          return 'Must be a number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Location / Shelf',
                      hintText: 'e.g. Fridge, Shelf 3',
                      controller: _locationController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLightFigma),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadowColor,
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                        ),
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          color: AppColors.darkText,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
                        },
                        items: _categories.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Barcode (Optional)',
                hintText: 'Scan or type barcode',
                controller: _barcodeController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 28),
              PrimaryButton(text: 'Save Product', onPressed: _saveProduct),
            ],
          ),
        ),
      ),
    );
  }
}
