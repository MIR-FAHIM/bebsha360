import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/customers_model/customer_group_model.dart';
import 'package:readypos_flutter/models/customers_model/customer_model.dart';
import 'package:readypos_flutter/services/customer_service_provider.dart';
import 'package:readypos_flutter/services/pos_products_service_provider.dart';
import 'package:readypos_flutter/services/pos_service_provider.dart';

final posStoreControllerProvider =
    StateNotifierProvider<POSStoreController, bool>((ref) {
  return POSStoreController(ref);
});

final customerControllerProvider =
    StateNotifierProvider<CustomerController, bool>((ref) {
  return CustomerController(ref);
});

final cuponControllerProvider =
    StateNotifierProvider<CuponController, bool>((ref) {
  return CuponController(ref);
});

final customerGroupControllerProvider =
    StateNotifierProvider<CustomerGroupController, bool>((ref) {
  return CustomerGroupController(ref);
});

final addCustomerControllerProvider =
    StateNotifierProvider<AddCustomerController, bool>((ref) {
  return AddCustomerController(ref);
});

class POSStoreController extends StateNotifier<bool> {
  final Ref ref;
  POSStoreController(this.ref) : super(false);

  Future<String?> store({required Map<String, dynamic> data}) async {
    try {
      state = true;
      final response = await ref.read(posServiceProvider).store(data: data);
      if (response.statusCode == 200) {
        final url = response.data['data']['invoice_pdf_url'];
        return url;
      }
      return null;
    } catch (e) {
      state = false;
      return null;
    } finally {
      state = false;
    }
  }
}

class CustomerController extends StateNotifier<bool> {
  final Ref ref;
  CustomerController(this.ref) : super(false);

  List<CustomerModel>? _customerList;
  List<CustomerModel>? get customerList => _customerList;

  Future<void> getCustomers({String? query}) async {
    try {
      state = true;
      final response = query != null
          ? await ref
              .read(customerServiceProvider)
              .getSearchedCustomers(query: query)
          : await ref.read(customerServiceProvider).getCustomers();

      final List<dynamic> customersData = response.data['data']['customers'];
      _customerList = null;
      _customerList = customersData.isEmpty
          ? null
          : customersData.map((e) => CustomerModel.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }
}

class CuponController extends StateNotifier<bool> {
  final Ref ref;
  CuponController(this.ref) : super(false);
  double? _discount;
  int? _cuponId;
  double? get discount => _discount;
  int? get cuponId => _cuponId;

  Future<bool> applyCupon({required String code, required String price}) async {
    try {
      state = true;
      final response = await ref.read(posProductsServiceProvider).cuponApply(
        data: {
          'code': code,
          'price': price,
        },
      );
      if (response.data['data']['discount'] != null) {
        _cuponId = response.data['data']['id'];
        _discount = response.data['data']['discount'];
      }
      return true;
    } catch (e) {
      state = false;
      return false;
    } finally {
      state = false;
    }
  }

  void clearCupon() {
    _cuponId = null;
    _discount = null;
  }
}

class CustomerGroupController extends StateNotifier<bool> {
  final Ref ref;
  CustomerGroupController(this.ref) : super(false);

  List<CustomerGroupModel>? _customerGroupList;
  List<CustomerGroupModel>? get customerGroupList => _customerGroupList;

  Future<void> getCustomerGroup() async {
    try {
      state = true;
      final response =
          await ref.read(customerServiceProvider).getCustomersGroup();

      final List<dynamic> customersGroupData =
          response.data['data']['customerGroups'];
      _customerGroupList = null;
      _customerGroupList = customersGroupData.isEmpty
          ? null
          : customersGroupData
              .map((e) => CustomerGroupModel.fromMap(e))
              .toList();
    } catch (e) {
      rethrow;
    } finally {
      state = false;
    }
  }
}

class AddCustomerController extends StateNotifier<bool> {
  final Ref ref;
  AddCustomerController(this.ref) : super(false);

  Future<bool> addCustomer({required Map<String, dynamic> data}) async {
    try {
      state = true;
      final response =
          await ref.read(customerServiceProvider).addCustomer(data: data);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      state = false;
      return false;
    } finally {
      state = false;
    }
  }
}
