import 'package:ambers_app/models/job_model.dart';
import 'package:ambers_app/sqlite/ambers_app/table_timesheet/timesheet.g.dart';
import 'package:ambers_app/working_bloc/bloc/working_bloc.dart';
import 'package:ambers_app/working_bloc/inherited_work_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_time_popover/date_time_picker/common.dart';
import 'package:flutter_date_time_popover/flutter_date_time_popover.dart';
import 'package:flutter_project_package/tracers/tracers.dart' as Log;

const Size DateTimePickerWidgetSize = Size(275, 48);

class WorkingScreen extends StatelessWidget {
  static const route = '/workingScreen';
  static WorkingBloc _staticWorkingBlock;

  const WorkingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final JobModel jobModel = ModalRoute.of(context).settings.arguments;
    _staticWorkingBlock = WorkingBloc(jobModel);

    return InheritedWorkBloc(
      child: Scaffold(
        appBar: AppBar(
          title: Text(jobModel.title),
        ),
        body: _body(context),
      ),
      workingBloc: _staticWorkingBlock,
    );
  }

  Widget _body(BuildContext context) {
    Timesheet timesheet;
    Timesheet finalSheet;
    return Builder(
      builder: (context) {
        final WorkingBloc workingBloc = InheritedWorkBloc.of(context).workingBloc;
        return BlocBuilder(
          bloc: workingBloc,
          builder: (context, workingState) {
            String elapsedTimeCaption;
            if (workingState is ShiftStartedState) {
              timesheet = workingState.timesheet;
            } else if (workingState is UpdatedLapsedTimeState) {
              timesheet = workingState.timesheet;
              final hours = workingState.dateTimeIntervals.hours.toString();
              final minutes = workingState.dateTimeIntervals.minutes.toString().padLeft(2, '0');
              final seconds = workingState.dateTimeIntervals.seconds.toString().padLeft(2, '0');
              final JobModel jobModel = ModalRoute.of(context).settings.arguments;
              String earned = jobModel.earnings(
                workingState.dateTimeIntervals.hours,
                workingState.dateTimeIntervals.minutes,
                workingState.dateTimeIntervals.seconds,
              );
              elapsedTimeCaption = '$hours:$minutes:$seconds  $earned';
            } else if (workingState is EndedShiftState) {
              timesheet = finalSheet = workingState.timesheet;
              final hours = workingState.intervals.hours.toString();
              final minutes = workingState.intervals.minutes.toString().padLeft(2, '0');
              final seconds = workingState.intervals.seconds.toString().padLeft(2, '0');
              final JobModel jobModel = ModalRoute.of(context).settings.arguments;
              String earned = jobModel.earnings(
                workingState.intervals.hours,
                workingState.intervals.minutes,
                workingState.intervals.seconds,
              );
              elapsedTimeCaption = 'Total: $hours:$minutes:$seconds  $earned';
            }
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(workingBloc.jobModel.description),
                  ),
                  Text('Rate: \$${workingBloc.jobModel.rateString}/HR'),
                  _startShiftWidgets(context, timesheet),
                  _elapsedTimeWidget(context, elapsedTimeCaption),
                  Opacity(
                    child: _finishShiftWidgets(context, finalSheet),
                    opacity: (timesheet == null ? 0.0 : 1.0),
                  ),
                  _saveShift(context, finalSheet),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            );
          },
        );
      },
    );
  }

  Widget _startShiftWidgets(BuildContext context, Timesheet timesheet) {
    //DateTime dt = timesheet?.start;
    //final txt = (dt == null) ? 'NULL' : '${dt.toLocal().toString()} UTC:${dt.toUtc().toString()}';
    //Log.d('_startShiftWidget: Time going in-- $txt');
    if (timesheet == null) {
      final color = ModeColor(dark: Colors.white30, light: Colors.black87).color(context);
      return RaisedButton(
        onPressed: () {
          _staticWorkingBlock.add(UpdateShiftStartEvent(dateTime: DateTime.now().toUtc()));
        },
        child: Text(
          'START SHIFT',
          style: TextStyle(color: color),
        ),
      );
    }
    return Column(
      children: <Widget>[
        //_startButton(context),
        DateTimeInputWidget(
          pickerWidth: 300,
          dateTimeWidget: _startPicker,
          yAdjustment: 24.0,
          arrowAdjustment: 0.50,
          initialDateTime: DateTime.now(),
        ),
      ],
    );
  }

  Widget _startPicker(BuildContext context, DateTime dateTime, DateTimeInputState state) {
    //Log.v('_startPicker incoming state... ${state.toString()}');
    final String date = (dateTime == null) ? 'Start' : formattedDate(dateTime.toLocal());
    final String time = (dateTime == null) ? 'Shift' : formattedTime(dateTime.toLocal());
    final caption = '$date $time';
    if (dateTime != null && state != DateTimeInputState.noChange) {
      switch (state) {
        case DateTimeInputState.dismissed:
          _staticWorkingBlock.add(StartShiftEvent(dateTime: dateTime));
          break;
        case DateTimeInputState.displayed:
          _staticWorkingBlock.add(PauseShiftTimerEvent());
          break;
        case DateTimeInputState.inital:
          break;
        case DateTimeInputState.noChange:
          break;
        case DateTimeInputState.userSet:
          _staticWorkingBlock.add(UpdateShiftStartEvent(dateTime: dateTime.toUtc()));
          break;
      }
    }
    return Container(
      color: ModeColor(dark: Color(0xff263238), light: Colors.yellow).color(context),
      width: DateTimePickerWidgetSize.width,
      height: DateTimePickerWidgetSize.height,
      child: Center(
        child: Text(
          caption,
        ),
      ),
    );
  }

  Widget _elapsedTimeWidget(BuildContext context, String caption) {
    final double fontSize = textSizeMap[TextSizes.subtitle1];
    return Container(
      child: Center(
        child: Text(
          caption ?? '---',
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      ),
      color: ModeColor(light: Color(0xff259814), dark: Color(0xff0f4009)).color(context),
      height: DateTimePickerWidgetSize.height,
      width: DateTimePickerWidgetSize.width,
    );
  }

  Widget _finishShiftWidgets(BuildContext context, Timesheet finishTimesheet) {
    if (finishTimesheet == null) {
      final color = ModeColor(dark: Colors.white30, light: Colors.black87).color(context);
      return RaisedButton(
        onPressed: () {
          _staticWorkingBlock.add(EndShiftEvent(DateTime.now().toUtc()));
        },
        child: Text(
          'END SHIFT',
          style: TextStyle(color: color),
        ),
      );
    }
    return DateTimeInputWidget(
      pickerWidth: 300,
      dateTimeWidget: _finishPicker,
      arrowAdjustment: 0.20,
      initialDateTime: DateTime.now(),
    );
  }

  Widget _finishPicker(BuildContext context, DateTime dateTime, DateTimeInputState state) {
    final String date = (dateTime == null) ? 'Finish' : formattedDate(dateTime);
    final String time = (dateTime == null) ? 'Shift' : formattedTime(dateTime);
    final double fontSize = textSizeMap[TextSizes.subtitle1];
    Log.v('_finishPicker incoming state... ${state.toString()} time:$dateTime');
    //if (dateTime != null && state != DateTimeInputState.noChange) {
    switch (state) {
      case DateTimeInputState.dismissed:
        if (dateTime == null) {
          _staticWorkingBlock.add(RestartShiftTimerEvent());
        }
        break;
      case DateTimeInputState.displayed:
        _staticWorkingBlock.add(PauseShiftTimerEvent());
        break;
      case DateTimeInputState.inital:
        break;
      case DateTimeInputState.noChange:
        break;
      case DateTimeInputState.userSet:
        _staticWorkingBlock.add(EndShiftEvent(dateTime.toUtc()));
        break;
    }
    //}
    return Container(
      color: ModeColor(dark: Color(0xff263238), light: Colors.yellow).color(context),
      width: DateTimePickerWidgetSize.width,
      height: DateTimePickerWidgetSize.height,
      child: Center(
        child: Text(
          '$date $time',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }

  Widget _saveShift(BuildContext context, Timesheet timesheet) {
    if (timesheet == null) return Container();
    final color = ModeColor(dark: Colors.white30, light: Colors.black87).color(context);
    return RaisedButton(
      onPressed: () {},
      child: Text(
        'SAVE',
        style: TextStyle(color: color),
      ),
    );
  }
}
