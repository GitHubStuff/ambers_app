import 'package:after_layout/after_layout.dart';
import 'package:ambers_app/job_bloc/inherited_job_bloc.dart';
import 'package:ambers_app/models/amber_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_package/flutterprojectpackage.dart';
import 'package:flutter_project_package/tracers/tracers.dart' as Log;
import 'package:flutter_sqlite_controller/flutter_sqlite_controller.dart' as SQL;

import 'job_list_screen.dart';

///-------------------------------------------------------------------------------------
class Amber extends StatefulWidget {
  const Amber({Key key}) : super(key: key);
  static const route = '/Amber';

  @override
  _Amber createState() => _Amber();
}

///-------------------------------------------------------------------------------------
class _Amber extends State<Amber> with WidgetsBindingObserver, AfterLayoutMixin<Amber> {
  bool hideSpinner = true;
  SQL.SQLiteLink link;

  // ignore: non_constant_identifier_names
  Size get ScreenSize => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Log.t('Amber initState()');
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Log.t('Amber afterFirstLayout()');
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    Log.t('Amber didChangeDependencies()');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Log.t('Amber didChangeAppLifecycleState ${state.toString()}');
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    ModeTheme.of(context).setBrightness(brightness);
    Log.t('Amber didChangePlatformBrightness ${brightness.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    Log.t('Amber build()');
    return InheritedJobBloc(
      child: HudScaffold.progressText(
        context,
        hide: hideSpinner,
        indicatorColors: ModeColor(light: Colors.purpleAccent, dark: Colors.purple),
        progressText: 'Amber Showable spinner',
        scaffold: Scaffold(
          appBar: AppBar(
            title: Text("Amber's Timesheet"),
            actions: <Widget>[
              _jobButton(context),
            ],
          ),
          body: body(),
          floatingActionButton: FloatingActionButton(
            heroTag: 'main',
            onPressed: () {
              setState(() {
                hideSpinner = false;
                Future.delayed(Duration(seconds: 3), () {
                  setState(() {
                    hideSpinner = true;
                  });
                });
              });
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    Log.t('Amber didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    Log.t('Amber deactivate()');
    super.deactivate();
  }

  @override
  void dispose() {
    Log.t('Amber dispose()');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Scaffold body
  Widget body() {
    Log.t('Amber body()');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Amber Template', style: Theme.of(context).textTheme.headline5),
          RaisedButton(
            child: Text('Toggle Mode', style: Theme.of(context).textTheme.headline5),
            onPressed: () {
              ModeTheme.of(context).toggleBrightness();
            },
          ),
          RaisedButton(
            child: Text('Next Screen', style: Theme.of(context).textTheme.headline5),
            onPressed: () {
              /// Navigator.push(context, MaterialPageRoute(builder: (context) => Berky()));
            },
          ),
        ],
      ),
    );
  }

  Widget _jobButton(BuildContext context) {
    return InheritedJobBloc(
      child: Padding(
        padding: const EdgeInsets.only(right: 24.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, JobListScreen.route);
          },
          child: _iconText(context),
        ),
      ),
    );
  }

  // Widget _icon(BuildContext context) {
  //   return Icon(
  //     Icons.add,
  //     color: ModeColor(light: Colors.white, dark: Colors.purple).color(context),
  //     size: 26.0,
  //   );
  // }

  Widget _iconText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        'JOBS',
        style: AmbersThemes.buttonText(context),
      ),
    );
  }
}
