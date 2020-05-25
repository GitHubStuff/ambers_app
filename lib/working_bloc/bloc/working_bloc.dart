import 'dart:async';

import 'package:ambers_app/models/job_model.dart';
import 'package:ambers_app/sqlite/ambers_app/table_timesheet/timesheet.g.dart';
import 'package:bloc/bloc.dart';
import 'package:date_time_intervals/dateinterval.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_package/tracers/tracers.dart' as Log;

part 'working_event.dart';
part 'working_state.dart';

class WorkingBloc extends Bloc<WorkingEvent, WorkingState> {
  JobModel jobModel;
  Timesheet _timesheet;
  Timer _timer;

  WorkingBloc(this.jobModel);

  @override
  WorkingState get initialState => WorkingInitial();

  @override
  Stream<WorkingState> mapEventToState(WorkingEvent event) async* {
    if (event is StartShiftEvent) {
      yield* _startShift(event.dateTime);
    } else if (event is UpdateShiftStartEvent) {
      yield* _updateShiftStart(event.dateTime);
    } else if (event is RefreshElapsedTimeEvent) {
      yield UpdatedLapsedTimeState(
        dateTimeIntervals: event.dateTimeIntervals,
        timesheet: event.timesheet,
      );
    } else if (event is PauseShiftTimerEvent) {
      _timer?.cancel();
      yield ShiftTimerPausedEvent();
    }
  }

  Stream<WorkingState> _startShift(DateTime dateTime) async* {
    _timesheet = Timesheet(
      start: dateTime,
      jobid: jobModel.recordId,
      rate: jobModel.rateValue,
    );
    yield ShiftStartedState(timesheet: _timesheet);
  }

  Stream<WorkingState> _updateShiftStart(DateTime dateTime) async* {
    _timesheet = Timesheet(
      start: dateTime,
      jobid: jobModel.recordId,
      rate: jobModel.rateValue,
    );
    _timer?.cancel();
    int currentSeconds;
    _timer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) {
      final currentTime = DateTime.now().toUtc();
      final calendarItems = DateTimeIntervals(
        setOfCalendarItems: {
          CalendarItem.hours,
          CalendarItem.minutes,
          CalendarItem.seconds,
        },
        startEvent: dateTime.toUtc(),
        endEvent: currentTime,
      );
      if (currentSeconds != calendarItems.seconds) {
        Log.w(
            'BLOC:start:${dateTime.toLocal().toString()}, now: ${currentTime.toLocal().toString()} hours:${calendarItems.hours}');
        this.add(RefreshElapsedTimeEvent(
          dateTimeIntervals: calendarItems,
          timesheet: _timesheet,
        ));
      }
      currentSeconds = calendarItems.seconds;
    });
  }
}
