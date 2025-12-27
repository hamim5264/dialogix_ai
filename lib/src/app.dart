import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class DialogixApp extends ConsumerWidget {
  const DialogixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Dialogix AI',

      theme: AppTheme.light(),

      darkTheme: AppTheme.dark(),

      themeMode: ThemeMode.system,

      routerConfig: router,
    );
  }
}
