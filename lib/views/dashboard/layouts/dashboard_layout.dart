import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/controllers/dashboard_controller/dashoard.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/views/dashboard/components/financial_section.dart';
import 'package:readypos_flutter/views/dashboard/components/logo_section.dart';
import 'package:readypos_flutter/views/dashboard/components/purchase_sale_graph.dart';
import 'package:readypos_flutter/views/dashboard/components/user_info_section.dart';

class DashBoardLayout extends ConsumerStatefulWidget {
  const DashBoardLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DashBoardLayoutState();
}

class _DashBoardLayoutState extends ConsumerState<DashBoardLayout> {
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.sizeOf(context).shortestSide > 600;
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: isLargeScreen
      //       ? context.isTabletLandsCape
      //           ? 340.h
      //           : 240.h
      //       : 230.h,
      //   automaticallyImplyLeading: false,
      //   surfaceTintColor: AdaptiveTheme.of(context).mode.isDark
      //       ? AppColor.darkBackgroundColor
      //       : Colors.white,
      //   flexibleSpace: Container(
      //     width: double.infinity,
      //     padding: EdgeInsets.symmetric(horizontal: 16.w),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Gap(68.h),
      //         const LogoSection(),
      //         Gap(12.h),
      //         const UserInfo(),
      //       ],
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          Container(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : AppColor.whiteColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(68.h),
                const LogoSection(),
                Gap(12.h),
                const UserInfo(),
                Gap(12.h),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer(
                builder: (context, ref, _) {
                  final asyncValue = ref.watch(dashboardInfoControllerProvider);
                  return asyncValue.when(
                      data: (data) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            ref.refresh(dashboardPeriodicProvider);
                            ref.refresh(dashboardInfoControllerProvider);
                          },
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                FinancialSection(
                                  dashboardInfo: data,
                                ),
                                PurchaseAndSaleGraph(
                                  dashboardInfo: data,
                                ),
                                Gap(40.h),
                              ],
                            ),
                          ),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) {
                        return Text('Error: $error');
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
