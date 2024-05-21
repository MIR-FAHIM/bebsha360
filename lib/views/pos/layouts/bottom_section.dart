import 'dart:async';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/components/custom_button.dart';
import 'package:readypos_flutter/components/custom_text_field.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/cart_controller/cart_controller.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_controller.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_provider.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/utils/global_function.dart';
import 'package:readypos_flutter/views/pos/components/customer_shimmerEffect.dart';

class BottomSection extends ConsumerWidget {
  const BottomSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    final currency = ref.watch(appcurrencyNotifierProvider.notifier);
    final subTotal = ref.watch(cartController).subTotalAmount;
    return Container(
      // height: context.isTabletLandsCape ? 150.h : 110.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 15.r),
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).mode.isDark
            ? AppColor.darkBackgroundColor
            : AppColor.whiteColor,
        border: Border(
          top: BorderSide(
            color: AppColor.borderColor,
            width: 1.w,
          ),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _chooseCustomerBottomSheet(context);
                if (ref
                        .read(customerControllerProvider.notifier)
                        .customerList ==
                    null) {
                  ref.read(customerControllerProvider.notifier).getCustomers();
                }
              },
              child: Container(
                // height: context.isTabletLandsCape ? 60.h : 35.h,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      context.isTabletLandsCape
                          ? SvgPicture.asset(
                              Assets.svgs.profile,
                            )
                          : SvgPicture.asset(
                              Assets.svgs.profile,
                              height: 24.h,
                              width: 24.w,
                            ),
                      Gap(12.w),
                      Expanded(
                        child: selectedCustomer != null
                            ? MediaQuery.sizeOf(context).shortestSide > 600
                                ? Text(
                                    selectedCustomer.name!,
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  )
                                : Text(
                                    selectedCustomer.name!,
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontSize: context.isTabletLandsCape
                                          ? 12.sp
                                          : 15.sp,
                                    ),
                                  )
                            : MediaQuery.sizeOf(context).shortestSide > 600
                                ? Text(
                                    S.of(context).chooseCustomer,
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  )
                                : Text(
                                    S.of(context).chooseCustomer,
                                    style: AppTextStyle.normalBody.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                      ),
                      Gap(12.w),
                      SvgPicture.asset(Assets.svgs.arrowDown2)
                    ]),
              ),
            ),
            Gap(10.h),
            SizedBox(
              width: double.infinity,
              child: Hero(
                tag: "btn",
                child: CustomButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: AdaptiveTheme.of(context).mode.isDark
                          ? AppColor.whiteColor.withOpacity(0.5)
                          : AppColor.darkBackgroundColor.withOpacity(0.5),
                      builder: (context) =>
                          Consumer(builder: (context, ref, _) {
                        final posStoreLoading =
                            ref.watch(posStoreControllerProvider);
                        return AlertDialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
                          icon: CircleAvatar(
                            backgroundColor: const Color(0xffEDFFE5),
                            radius: 45.r,
                            child: context.isTabletLandsCape
                                ? SvgPicture.asset(
                                    Assets.svgs.shopImg,
                                  )
                                : SvgPicture.asset(
                                    Assets.svgs.shopImg,
                                    height: 42.h,
                                    width: 40.w,
                                  ),
                          ),
                          content:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(
                              "Would you like to confirm the order?",
                              style: AppTextStyle.title,
                              textAlign: TextAlign.center,
                            ),
                            Gap(24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 120.w,
                                  // height:
                                  //     context.isTabletLandsCape ? 80.h : 48.h,
                                  child: CustomButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    text: "Cancel",
                                    isBackgrounColor: false,
                                  ),
                                ),
                                Gap(16.w),
                                SizedBox(
                                  width: 120.w,
                                  // height:
                                  //     context.isTabletLandsCape ? 80.h : 48.h,
                                  child: posStoreLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : CustomButton(
                                          onPressed: () async {
                                            if (ref
                                                    .read(cartController)
                                                    .subTotalAmount <=
                                                0) {
                                              context.nav.pop();
                                              GlobalFunction.showCustomSnackbar(
                                                message:
                                                    "Please add product first",
                                                isSuccess: false,
                                              );
                                              return;
                                            }

                                            await posStore(
                                                    context: context, ref: ref)
                                                .then((value) {
                                              if (value != null) {
                                                context.nav.pop();
                                                context.nav.pop();
                                                ref
                                                    .read(selectedIndexProvider
                                                        .notifier)
                                                    .state = 0;
                                                ref
                                                    .read(
                                                        bottomTabControllerProvider
                                                            .notifier)
                                                    .state
                                                    .jumpToPage(0);
                                                context.nav.pushNamed(
                                                  Routes.pdfView,
                                                  arguments: value,
                                                );
                                              }
                                            });
                                          },
                                          text: "Confirm",
                                        ),
                                ),
                              ],
                            )
                          ]),
                        );
                      }),
                    );
                  },
                  isArrowRight: true,
                  text: "Grand Total: ${currency.currencyValue(subTotal)}",
                ),
              ),
            )
          ]),
    );
  }

  Future<String?> posStore(
      {required BuildContext context, required WidgetRef ref}) async {
    final Box<HiveCartModel> cartBox =
        Hive.box<HiveCartModel>(AppConstants.cartBox);
    final subTotal = ref.read(cartController).subTotalAmount.toStringAsFixed(2);
    final cuponId = ref.read(cuponControllerProvider.notifier).cuponId;
    final customerId = ref.read(selectedCustomerProvider)?.id;

    final List<int> productIds = [];
    final List<int> productQuantities = [];
    final List<double> pricingList = [];
    for (var item in cartBox.values.toList()) {
      productIds.add(item.id);
      productQuantities.add(item.productsQTY);
      pricingList.add(item.subTotal);
    }

    String? pdfUrl = await ref.read(posStoreControllerProvider.notifier).store(
      data: {
        'customer_id': customerId,
        'product_ids': productIds,
        'qty': productQuantities,
        'coupon_id': cuponId,
        'paid_amount': subTotal,
        'price': pricingList,
        'payment_status': 1,
        'type': "Sales"
      },
    );

    if (pdfUrl != null) {
      // clear hive cart, cupon, customer
      cartBox.clear();
      ref.read(cuponControllerProvider.notifier).clearCupon();
      ref.read(selectedCustomerProvider.notifier).state = null;
      ref.read(cartController.notifier).clearFiles();
      GlobalFunction.showCustomSnackbar(
          message: "Order successfully Placed", isSuccess: true);
      return pdfUrl;
    } else {
      GlobalFunction.showCustomSnackbar(
          message: "Something went wrong", isSuccess: false);
      return null;
    }
  }

  Future<dynamic> _chooseCustomerBottomSheet(context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Consumer(builder: (context, ref, _) {
          Timer? searchTimer;
          final loading = ref.watch(customerControllerProvider);
          final customerList =
              ref.watch(customerControllerProvider.notifier).customerList;
          return Container(
            height: 0.85.sh,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                addCustomer(context, ref),
                Gap(20.h),
                SizedBox(
                  // height: context.isTabletLandsCape ? 100.h : 60.h,
                  child: CustomTextField(
                    controller: ref.watch(searchCustomerTextController),
                    onChanged: (value) async {
                      searchTimer?.cancel();
                      searchTimer = Timer(
                        const Duration(seconds: 1),
                        () {
                          ref
                              .read(customerControllerProvider.notifier)
                              .getCustomers(query: value);
                        },
                      );
                    },
                    hint: S.of(context).searchNameOrMobile,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: SvgPicture.asset(
                        Assets.svgs.searchNormal,
                      ),
                    ),
                  ),
                ),
                Gap(25.h),
                Expanded(
                  child: loading
                      ? const CustomerShimmer()
                      : customerList != null
                          ? ListView.builder(
                              itemCount: customerList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: InkWell(
                                    onTap: () {
                                      final Box<HiveCartModel> cartBox =
                                          Hive.box<HiveCartModel>(
                                              AppConstants.cartBox);

                                      if (ref.read(selectedCustomerProvider) !=
                                              null &&
                                          ref
                                                  .read(
                                                      selectedCustomerProvider)
                                                  ?.id ==
                                              customerList[index].id) {
                                        ref.invalidate(
                                            selectedCustomerProvider);
                                        ref
                                            .read(cartController.notifier)
                                            .setGroupDiscount(0);
                                        ref
                                            .read(cartController.notifier)
                                            .calculateSubTotal(
                                                cartBox.values.toList());

                                        return;
                                      } else {
                                        ref
                                            .read(cartController.notifier)
                                            .clearFiles();
                                        ref
                                            .read(cartController.notifier)
                                            .calculateSubTotal(
                                                cartBox.values.toList());
                                        ref
                                            .read(selectedCustomerProvider
                                                .notifier)
                                            .state = customerList[index];
                                        ref
                                            .read(cartController.notifier)
                                            .setGroupDiscount(
                                                customerList[index]
                                                    .group
                                                    ?.dicountPercent);
                                      }

                                      Navigator.pop(context);
                                    },
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Container(
                                      // height: context.isTabletLandsCape
                                      //     ? 90.h
                                      //     : 56.h,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(15.h),
                                      decoration: BoxDecoration(
                                        color: ref
                                                    .watch(
                                                        selectedCustomerProvider)
                                                    ?.id ==
                                                customerList[index].id
                                            ? AppColor.primaryColor
                                                .withOpacity(0.2)
                                            : null,
                                        border: Border.all(
                                          color: AppColor.borderColor
                                              .withOpacity(0.8),
                                          width: 1.w,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        "${customerList[index].name} (${customerList[index].phone})",
                                        style: AppTextStyle.normalBody,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text(
                              "No Customer Found",
                              style: AppTextStyle.normalBody,
                            )),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Row addCustomer(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(S.of(context).chooseCustomer, style: AppTextStyle.title),
              Gap(8.w),
              TextButton(
                onPressed: () {
                  context.nav.pushNamed(Routes.addNewCustomer);
                  ref
                      .read(customerGroupControllerProvider.notifier)
                      .getCustomerGroup();
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColor.primaryColor.withOpacity(0.1),
                  foregroundColor: AppColor.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add),
                    Gap(4.w),
                    Text(
                      S.of(context).neww,
                      style: AppTextStyle.normalBody.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
            color: Colors.red,
            size: 24.r,
          ),
        )
      ],
    );
  }
}
