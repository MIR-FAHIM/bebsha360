// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';

class ShowLanguage extends ConsumerWidget {
  ShowLanguage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppConstants.appSettingsBox).listenable(),
        builder: (context, appSettings, _) {
          final storedLanguage =
              Hive.box(AppConstants.appSettingsBox).get(AppConstants.appLocal);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 0.h),
                itemBuilder: (context, index) => ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.0),
                  minVerticalPadding: 0.0,
                  onTap: () {
                    Hive.box(AppConstants.appSettingsBox)
                        .put(AppConstants.appLocal, language[index].toMap());
                    context.nav.pop(context);
                  },
                  title: Text(
                    language[index].name,
                    style: AppTextStyle.title,
                  ),
                  trailing: Radio(
                    value: language[index].value,
                    groupValue: storedLanguage['value'] as String,
                    onChanged: (String? gender) {
                      Hive.box(AppConstants.appSettingsBox)
                          .put(AppConstants.appLocal, language[index].toMap());
                      context.nav.pop(context);
                    },
                  ),
                ),
                separatorBuilder: ((context, index) => const Divider(
                      thickness: 1.0,
                      color: AppColor.borderColor,
                    )),
                itemCount: language.length,
              ),
            ],
          );
        });
  }

  final List<AppLanguage> language = [
    AppLanguage(name: '\ud83c\uddfa\ud83c\uddf8 ENG', value: 'en'),
    AppLanguage(name: '🇧🇩 BD', value: 'bn'),
    // for arabic language
    AppLanguage(name: '🇸🇦 AR', value: 'ar'),
  ];
}

class AppLanguage {
  final String name;
  final String value;
  AppLanguage({
    required this.name,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'value': value,
    };
  }
}
