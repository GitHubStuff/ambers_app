import 'package:ambers_app/job_bloc/job_bloc.dart';
import 'package:flutter/cupertino.dart';

class InheritedJobBloc extends InheritedWidget {
  final JobBloc jobBloc = JobBloc();

  InheritedJobBloc({Widget child}) : super(child: child);

  static InheritedJobBloc of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<InheritedJobBloc>();

  bool updateShouldNotify(InheritedJobBloc oldWidget) => true;
}
