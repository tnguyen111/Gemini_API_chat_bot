import 'package:responsive_framework/responsive_framework.dart';

import 'main_interface/main_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        top: true,
        bottom: true,
        left: false,
        right: false,
        child: ResponsiveBreakpoints.of(context).isMobile
            ? mobilePortrait(ref)
            : mobileLandscape(ref));
  }
}
