import 'dart:async';

import 'package:ambers_app/models/job_model.dart';
import 'package:ambers_app/sqlite/ambers_app/table_timesheet/timesheet.g.dart';
import 'package:bloc/bloc.dart';
import 'package:date_time_intervals/dateinterval.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_package/tracers/tracers.dart' as Log;
import 'package:flutter_sqlite_controller/flutter_sqlite_controller.dart' as SQL;

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
    } else if (event is RestartShiftTimerEvent) {
      yield* _updateShiftStart(_timesheet.start ?? DateTime.now());
    } else if (event is EndShiftEvent) {
      yield* _endShift(event.endShiftDateTime);
    } else if (event is SaveShiftEvent) {
      yield* _saveTimesheet(_timesheet);
    }
  }

  Stream<WorkingState> _saveTimesheet(Timesheet timesheet) async* {
    final t = await SQL.SqliteController.initialize(name: dbName);
    Log.t('(working_bloc.dart) ${t.toString()}');
    final id = await timesheet.create(link: SQL.SQLiteLink());
    Log.t('(working_bloc.dart) -- saved work $id');
    yield ShiftSavedState();
  }

  Stream<WorkingState> _startShift(DateTime dateTime) async* {
    _timesheet = Timesheet(
      start: dateTime,
      jobid: jobModel.recordId,
      rate: jobModel.rateValue,
    );
    yield ShiftStartedState(timesheet: _timesheet);
  }

  Stream<WorkingState> _endShift(DateTime endDateTime) async* {
    _timer?.cancel(); //Just good house keeping
    _timesheet = Timesheet(
      start: _timesheet.start,
      jobid: jobModel.recordId,
      rate: jobModel.rateValue,
      finish: endDateTime,
    );
    final calendarItems = DateTimeIntervals(
      setOfCalendarItems: {
        CalendarItem.hours,
        CalendarItem.minutes,
        CalendarItem.seconds,
      },
      startEvent: _timesheet.start.toUtc(),
      endEvent: endDateTime.toUtc(),
    );
    yield EndedShiftState(
      timesheet: _timesheet,
      intervals: calendarItems,
    );
  }

  Stream<WorkingState> _updateShiftStart(DateTime dateTime) async* {
    _timesheet = Timesheet(
      start: dateTime,
      finish: _timesheet?.finish,
      jobid: jobModel.recordId,
      rate: jobModel.rateValue,
    );
    _timer?.cancel();
    if (_timesheet.finish != null) {
      yield* _endShift(_timesheet.finish);
    } else {
      int currentSeconds;
      _timer = Timer.periodic(Duration(milliseconds: 900), (Timer t) {
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
          this.add(RefreshElapsedTimeEvent(
            dateTimeIntervals: calendarItems,
            timesheet: _timesheet,
          ));
        }
        currentSeconds = calendarItems.seconds;
      });
    }
  }
}
