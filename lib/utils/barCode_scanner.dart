import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/pos_product_controller/product_controller.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';

Future<void> barCodeScanner(
    {required BuildContext context, required WidgetRef ref}) async {
  String barCode = await FlutterBarcodeScanner.scanBarcode(
    "#ffff66",
    "Cancel",
    true,
    ScanMode.BARCODE,
  );

  if (barCode.isNotEmpty && barCode != "-1") {
    await ref
        .read(posProductsControllerProvider.notifier)
        .getSearchedProducts(barCode: barCode);
    final searchedProduct =
        ref.read(posProductsControllerProvider.notifier).searchedProduct;

    if (searchedProduct != null) {
      final cartBox = Hive.box<HiveCartModel>(AppConstants.cartBox);

      HiveCartModel cartModel = HiveCartModel(
        id: searchedProduct.id!,
        name: searchedProduct.name!,
        code: searchedProduct.code!,
        thumbnail: searchedProduct.thumbnail!,
        subTotal: searchedProduct.subtotal!,
        productsQTY: 1,
      );

      await cartBox.add(cartModel);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "Product successfully added to cart",
          style: AppTextStyle.normalBody.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            "Product not found",
            style: AppTextStyle.normalBody.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColor.redColor,
        ),
      );
    }
  } else {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          "Process canceled",
          style: AppTextStyle.normalBody.copyWith(
            color: Colors.black,
          ),
        ),
        // give background color warning,
        backgroundColor: Colors.yellowAccent,
      ),
    );
  }
}
