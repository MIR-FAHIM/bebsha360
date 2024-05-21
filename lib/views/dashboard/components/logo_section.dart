import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readypos_flutter/gen/assets.gen.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Container(
        //   padding: EdgeInsets.only(bottom: 1.w, right: 1.w, top: 1.h),
        //   child: Image.asset(
        //     AdaptiveTheme.of(context).mode.isDark
        //         ? Assets.pngs.logoBebsha
        //         : Assets.pngs.logoBebsha,
        //     fit: BoxFit.fill,
        //   ),
        // ),
      ],
    );
  }
}
