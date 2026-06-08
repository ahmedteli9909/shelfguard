import 'package:flutter/material.dart';
import '../models/product.dart';

class WorkspaceProvider with ChangeNotifier {
  String _userName = 'Alex';
  String _accountType = 'personal';
  String _workspaceName = '';
  bool _isCreatingWorkspace = true;
  String _storeCategory = '';
  String _teamSize = '';
  bool _hasLogo = false;
  List<String> _alertDays = ['1', '3'];
  String _selectedAlertTime = '8:00 AM';
  List<Map<String, String>> _staffList = [];
  bool _isSetupCompleted = false;
  String _inviteCode = '';

  // Products list
  final List<Product> _products = [];

  // Getters
  String get userName => _userName;
  String get accountType => _accountType;
  String get workspaceName => _workspaceName;
  bool get isCreatingWorkspace => _isCreatingWorkspace;
  String get storeCategory => _storeCategory;
  String get teamSize => _teamSize;
  bool get hasLogo => _hasLogo;
  List<String> get alertDays => _alertDays;
  String get selectedAlertTime => _selectedAlertTime;
  List<Map<String, String>> get staffList => _staffList;
  bool get isSetupCompleted => _isSetupCompleted;
  String get inviteCode => _inviteCode;

  List<Product> get products => List.unmodifiable(_products);

  // Computed getters for statistics
  int get totalItems => _products.length;
  int get expiringSoonCount => _products.where((p) => p.isExpiringSoon).length;
  int get expiredCount => _products.where((p) => p.isExpired).length;
  int get safeCount => _products.where((p) => p.isSafe).length;

  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }

  void removeProduct(String id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      notifyListeners();
    }
  }

  void _loadMockProducts() {
    _products.clear();
    final now = DateTime.now();
    if (_accountType == 'personal') {
      _products.addAll([
        Product(
          id: '1',
          name: 'Amul Fresh Milk',
          expiryDate: now.add(const Duration(days: 5)),
          quantity: 2,
          category: 'Dairy & Food Court',
          location: 'Kitchen Fridge',
          barcode: '8901262010014',
          addedAt: now.subtract(const Duration(hours: 1)),
        ),
        Product(
          id: '2',
          name: 'Brown Bread',
          expiryDate: now.subtract(const Duration(days: 1)),
          quantity: 1,
          category: 'Dairy & Food Court',
          location: 'Kitchen Pantry',
          barcode: '8901262020020',
          addedAt: now.subtract(const Duration(days: 1)),
        ),
        Product(
          id: '3',
          name: 'Organic Eggs (12-pack)',
          expiryDate: now.add(const Duration(days: 2)),
          quantity: 1,
          category: 'Dairy & Food Court',
          location: 'Kitchen Fridge',
          barcode: '8901262030036',
          addedAt: now.subtract(const Duration(hours: 4)),
        ),
        Product(
          id: '4',
          name: 'Greek Yogurt (Strawberry)',
          expiryDate: now.add(const Duration(days: 12)),
          quantity: 4,
          category: 'Dairy & Food Court',
          location: 'Kitchen Fridge',
          addedAt: now.subtract(const Duration(hours: 12)),
        ),
      ]);
    } else {
      // Business/Store mock products
      _products.addAll([
        Product(
          id: '11',
          name: 'Paracetamol 500mg',
          expiryDate: now.add(const Duration(days: 4)),
          quantity: 150,
          category: 'Pharmacy Section',
          location: 'Rack A - Shelf 2',
          barcode: '8901043001211',
          addedAt: now.subtract(const Duration(hours: 2)),
        ),
        Product(
          id: '12',
          name: 'Aspirin Tablets',
          expiryDate: now.subtract(const Duration(days: 5)),
          quantity: 80,
          category: 'Pharmacy Section',
          location: 'Rack A - Shelf 3',
          barcode: '8901043001228',
          addedAt: now.subtract(const Duration(days: 2)),
        ),
        Product(
          id: '13',
          name: 'Nivea Face Wash 100ml',
          expiryDate: now.add(const Duration(days: 45)),
          quantity: 24,
          category: 'Cosmetics Department',
          location: 'Aisle 4 - Shelf 1',
          barcode: '4005900136207',
          addedAt: now.subtract(const Duration(hours: 8)),
        ),
        Product(
          id: '14',
          name: 'Organic Vine Tomatoes 500g',
          expiryDate: now.add(const Duration(days: 2)),
          quantity: 15,
          category: 'Produce & Groceries',
          location: 'Fresh Counter 1',
          barcode: '8908001223567',
          addedAt: now.subtract(const Duration(hours: 5)),
        ),
      ]);
    }
  }

  void updatePersonalProfile({required String name}) {
    _userName = name;
    notifyListeners();
  }

  void updateAccountType(String type) {
    _accountType = type;
    notifyListeners();
  }

  void setupPersonalWorkspace({
    required String name,
    required List<String> alertDays,
    required String alertTime,
  }) {
    _userName = name;
    _accountType = 'personal';
    _alertDays = alertDays;
    _selectedAlertTime = alertTime;
    _isSetupCompleted = true;
    _loadMockProducts();
    notifyListeners();
  }

  void setupBusinessWorkspace({
    required String userName,
    required String workspaceName,
    required String storeCategory,
    required String teamSize,
    required bool hasLogo,
    required List<Map<String, String>> staffList,
  }) {
    _userName = userName;
    _workspaceName = workspaceName;
    _storeCategory = storeCategory;
    _teamSize = teamSize;
    _hasLogo = hasLogo;
    _staffList = staffList;
    _accountType = 'business';
    _isCreatingWorkspace = true;
    _isSetupCompleted = true;
    _loadMockProducts();
    notifyListeners();
  }

  void joinBusinessWorkspace({
    required String userName,
    required String inviteCode,
  }) {
    _userName = userName;
    _inviteCode = inviteCode;
    _accountType = 'business';
    _isCreatingWorkspace = false;
    _isSetupCompleted = true;
    // Mock store/workspace details for joining
    _workspaceName = 'SuperMart Center';
    _storeCategory = 'Supermarket / Mall';
    _staffList = [
      {
        'name': 'Sarah Connor',
        'role': 'Store Manager',
        'dept': 'Produce & Groceries',
      },
      {
        'name': 'John Doe',
        'role': 'Stock Assistant',
        'dept': 'Dairy & Food Court',
      },
    ];
    _loadMockProducts();
    notifyListeners();
  }
}
