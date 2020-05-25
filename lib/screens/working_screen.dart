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

  const WorkingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final JobModel jobModel = ModalRoute.of(context).settings.arguments;
    final WorkingBloc workingBloc = WorkingBloc(jobModel);

    return InheritedWorkBloc(
      child: Scaffold(
        appBar: AppBar(
          title: Text(jobModel.title),
        ),
        body: _body(context),
      ),
      workingBloc: workingBloc,
    );
  }

  Widget _body(BuildContext context) {
    Timesheet timesheet;
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
              elapsedTimeCaption = '$hours:$minutes:$seconds';
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
                  _finishShiftWidgets(context),
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
    DateTime dt = timesheet?.start;
    final txt = (dt == null) ? 'NULL' : '${dt.toLocal().toString()} UTC:${dt.toUtc().toString()}';
    Log.d('_startShiftWidget: Time going in-- $txt');
    return Column(
      children: <Widget>[
        //_startButton(context),
        DateTimeInputWidget(
          pickerWidth: 300,
          dateTimeWidget: _startPicker,
          yAdjustment: 24.0,
          arrowAdjustment: 0.50,
          initialDateTime: timesheet?.start,
        ),
      ],
    );
  }

  Widget _startButton(BuildContext context) {
    final workBloc = InheritedWorkBloc.of(context).workingBloc;
    return Container(
        child: Column(
      children: <Widget>[
        RaisedButton(
          child: Text(
            'START',
            style: TextStyle(fontSize: 22.0),
          ),
          onPressed: () {
            workBloc.add(StartShiftEvent(
              dateTime: DateTime.now(),
            ));
          },
        )
      ],
    ));
  }

  Widget _startPicker(BuildContext context, DateTime dateTime, DateTimeInputState state) {
    final String date = (dateTime == null) ? 'Start' : formattedDate(dateTime.toLocal());
    final String time = (dateTime == null) ? 'Shift' : formattedTime(dateTime.toLocal());
    final caption = '$date $time';
    Log.v('_startPicker caption: $caption state:${EnumToString.parse(state)} ');
    if (dateTime != null && state != DateTimeInputState.noChange) {
      try {
        final workBloc = InheritedWorkBloc.of(context).workingBloc;
        switch (state) {
          case DateTimeInputState.dismissed:
            break;
          case DateTimeInputState.displayed:
            workBloc.add(PauseShiftTimerEvent());
            break;
          case DateTimeInputState.inital:
            break;
          case DateTimeInputState.noChange:
            break;
          case DateTimeInputState.userSet:
            workBloc.add(UpdateShiftStartEvent(dateTime: dateTime.toUtc()));
            break;
        }
      } catch (error) {
        Log.e('${error.toString()}');
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

  Widget _finishShiftWidgets(BuildContext context) {
    return Container();
    return Column(
      children: <Widget>[
        _finishButton(context),
        DateTimeInputWidget(
          pickerWidth: 300,
          dateTimeWidget: _finishPicker,
          arrowAdjustment: 0.20,
        ),
      ],
    );
  }

  Widget _finishButton(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        RaisedButton(
          child: Text(
            'FINISH',
            style: TextStyle(fontSize: 22.0),
          ),
          onPressed: () {},
        )
      ],
    ));
  }

  Widget _finishPicker(BuildContext context, DateTime dateTime, DateTimeInputState state) {
    final String date = (dateTime == null) ? 'Finish' : formattedDate(dateTime);
    final String time = (dateTime == null) ? 'Shift' : formattedTime(dateTime);
    final double fontSize = textSizeMap[TextSizes.subtitle1];
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
}
