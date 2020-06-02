import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mailapp/routes.dart';

import 'database/db_provider.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DbProvider>(
      builder: (_) => DbProvider(),
      dispose: (_, value) => value.dispose(),
      child: MaterialApp(
          title: 'Mail List',
          theme: ThemeData(
            brightness: Brightness.dark,
          ),
          initialRoute: '/',
          routes: routes),
    );
  }
}