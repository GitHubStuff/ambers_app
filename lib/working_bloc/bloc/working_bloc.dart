import 'dart:async';

import 'package:ambers_app/models/job_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'working_event.dart';
part 'working_state.dart';

class WorkingBloc extends Bloc<WorkingEvent, WorkingState> {
  JobModel jobModel;

  WorkingBloc(this.jobModel);

  @override
  WorkingState get initialState => WorkingInitial();

  @override
  Stream<WorkingState> mapEventToState(
    WorkingEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
