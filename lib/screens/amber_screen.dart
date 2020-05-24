import 'package:after_layout/after_layout.dart';
import 'package:ambers_app/job_bloc/job_bloc.dart';
import 'package:ambers_app/main.dart';
import 'package:ambers_app/models/constants.dart';
import 'package:ambers_app/models/job_model.dart';
import 'package:ambers_app/screens/working_screen.dart';
import 'package:ambers_app/sqlite/ambers_app/table_jobs/jobs.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Color cardColor = ModeColor(light: Colors.grey[300], dark: Colors.grey[700]).color(context);
    return HudScaffold.progressText(
      context,
      hide: hideSpinner,
      indicatorColors: ModeColor(light: Colors.purpleAccent, dark: Colors.purple),
      progressText: 'Amber Showable spinner',
      scaffold: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: _icon(context),
                onPressed: () {
                  ModeTheme.of(context).toggleBrightness();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Text("Amber's Timesheet"),
          actions: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(cardColor: cardColor),
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return Constants.mainList.map((item) {
                    return PopupMenuItem(
                      child: Text(item),
                      value: item,
                    );
                  }).toList();
                },
                onSelected: (text) => _menuChoices(context, text),
              ),
            ),
          ],
        ),
        body: _body(),
        floatingActionButton: FloatingActionButton(
          heroTag: 'amber_screen',
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
          tooltip: 'Jobs',
          child: Icon(Icons.add),
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

  void _menuChoices(BuildContext context, String choice) {
    switch (choice) {
      case Constants.newJob:
        Navigator.pushNamed(context, JobListScreen.route);
        break;
    }
  }

  /// Scaffold body
  Widget _body() {
    Log.t('Amber body()');
    return Center(
      child: Container(
        height: 400,
        child: _listView(context),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return BlocBuilder(
      bloc: jobBloc,
      builder: (context, jobState) {
        num itemCount = 0;
        List<Jobs> jobs = [];
        if (jobState is InitialJobState) {
          jobBloc.add(LoadJobEvent());
          return Text('Loading jobs...');
        } else if (jobState is LoadedJobsState) {
          itemCount = jobState.jobs.length;
          jobs.addAll(jobState.jobs);
        }

        return ListView.separated(
          itemBuilder: (context, index) {
            final JobModel job = JobModel.fromDB(jobs[index]);
            final title = '\$${job.rateString} ==> ${job.title}';
            final subtitle = '${job.description}';
            final evenColor = ModeColor(
              light: Color(0xfffff0f5),
              dark: Color(0xffe6e6fa),
            ).color(context);
            final oddColor = ModeColor(
              light: Color(0xffF0F8FF),
              dark: Color(0xffFFFAFA),
            ).color(context);
            return Card(
              color: (index % 2) == 0 ? evenColor : oddColor,
              child: ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    color: ModeColor(light: Colors.purpleAccent, dark: Colors.purple).color(context),
                  ),
                ),
                selected: true,
                subtitle: Text(
                  subtitle,
                  style: TextStyle(
                    color: ModeColor(light: Colors.purpleAccent, dark: Colors.purple).color(context),
                  ),
                ),
                onTap: () async {
                  JobModel jobInfo = JobModel.fromDB(jobs[index]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkingScreen(),
                      settings: RouteSettings(
                        arguments: jobInfo,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          separatorBuilder: (_, __) => Divider(
            color: ModeColor(
              light: Colors.purpleAccent,
              dark: Colors.purple,
            ).color(context),
          ),
          itemCount: itemCount,
        );
      },
    );
  }

  Widget _icon(BuildContext context) {
    return Icon(
      Icons.lightbulb_outline,
      color: ModeColor(light: Colors.white, dark: Colors.purple).color(context),
      size: 26.0,
    );
  }
}
