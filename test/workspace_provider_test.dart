import 'package:flutter_test/flutter_test.dart';
import 'package:shelfguard/core/models/product.dart';
import 'package:shelfguard/core/providers/workspace_provider.dart';

void main() {
  group('WorkspaceProvider Tests', () {
    late WorkspaceProvider provider;

    setUp(() {
      provider = WorkspaceProvider();
    });

    test('initial values', () {
      expect(provider.userName, 'Alex');
      expect(provider.accountType, 'personal');
      expect(provider.isSetupCompleted, false);
      expect(provider.products, isEmpty);
    });

    test('setup personal workspace initializes mock data', () {
      provider.setupPersonalWorkspace(
        name: 'John Doe',
        alertDays: ['1', '3', '7'],
        alertTime: '09:00 AM',
      );

      expect(provider.userName, 'John Doe');
      expect(provider.accountType, 'personal');
      expect(provider.isSetupCompleted, true);
      expect(provider.products, isNotEmpty);
      expect(provider.totalItems, equals(4));
    });

    test('setup business workspace initializes mock data', () {
      provider.setupBusinessWorkspace(
        userName: 'Manager Alice',
        workspaceName: 'Alice Shop',
        storeCategory: 'Grocery / Convenience Store',
        teamSize: '1 - 5 staff',
        hasLogo: true,
        staffList: [],
      );

      expect(provider.userName, 'Manager Alice');
      expect(provider.workspaceName, 'Alice Shop');
      expect(provider.accountType, 'business');
      expect(provider.isSetupCompleted, true);
      expect(provider.products, isNotEmpty);
    });

    test('add and remove products', () {
      final now = DateTime.now();
      final product = Product(
        id: 'test-1',
        name: 'Test Milk',
        expiryDate: now.add(const Duration(days: 10)),
        quantity: 1,
        category: 'Dairy & Food Court',
        location: 'Fridge',
        addedAt: now,
      );

      provider.addProduct(product);
      expect(provider.totalItems, equals(1));
      expect(provider.products.first.name, 'Test Milk');

      provider.removeProduct('test-1');
      expect(provider.totalItems, equals(0));
    });
  });
}
