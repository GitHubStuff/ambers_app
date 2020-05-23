import 'package:ambers_app/screens/job_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_package/flutterprojectpackage.dart';
import 'package:flutter_sqlite_controller/flutter_sqlite_controller.dart' as SQL;
import 'package:flutter_sqlite_developer/sqlite_screen_widget.dart';

import 'job_bloc/job_bloc.dart';
import 'models/job_model.dart';
import 'screens/amber_screen.dart';
import 'screens/working_screen.dart';

void main() => runApp(AmberApp());

final jobBloc = JobBloc();

class AmberApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ModeDefiniation.buttonModeColor = ModeColor(light: Color(0xf0cca9dd), dark: Colors.deepPurple);
    ModeDefiniation.primaryModeColor = ModeColor(light: Colors.purple, dark: Colors.purpleAccent);

    return ModeTheme(
      themeDataFunction: (brightness) => (brightness == Brightness.light) ? ModeTheme.light : ModeTheme.dark,
      defaultBrightness: Brightness.light,
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          home: SqliteScreenWidget(
            childWidget: Amber(),
            enabled: true,
            sqliteIdentity: SQL.SQLiteIdentity(databaseName: dbName),
          ),
          initialRoute: '/',
          routes: {
            Amber.route: (context) => AmberApp(),
            JobListScreen.route: (context) => JobListScreen(
                  jobBloc: jobBloc,
                  jobModel: null,
                ),
            WorkingScreen.route: (context) => WorkingScreen(),
          },
          theme: theme,
          title: 'AmberApp',
        );
      },
    );
  }
}
