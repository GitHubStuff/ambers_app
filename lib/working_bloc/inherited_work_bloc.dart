import 'package:flutter_date_time_popover/date_time_picker/common.dart';

import 'bloc/working_bloc.dart';

class InheritedWorkBloc extends InheritedWidget {
  static InheritedWorkBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedWorkBloc>();
  }

  final WorkingBloc workingBloc;

  const InheritedWorkBloc({Widget child, @required this.workingBloc}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
