import 'package:ambers_app/models/job_model.dart';
import 'package:ambers_app/working_bloc/bloc/working_bloc.dart';
import 'package:ambers_app/working_bloc/inherited_work_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_time_popover/date_time_picker/common.dart';
import 'package:flutter_date_time_popover/flutter_date_time_popover.dart';

const Size DateTimePickerWidgetSize = Size(275, 48);

class WorkingScreen extends StatelessWidget {
  static const route = '/workingScreen';

  const WorkingScreen({Key key}) : super(key: key);

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
    return Builder(
      builder: (context) {
        final WorkingBloc workingBloc = InheritedWorkBloc.of(context).workingBloc;
        return BlocBuilder(
          bloc: workingBloc,
          builder: (context, workingState) {
            return Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(workingBloc.jobModel.description),
                  ),
                  Text('Rate: \$${workingBloc.jobModel.rateString}/HR'),
                  _startShiftWidgets(context, workingBloc.jobModel),
                  _elapsedTimeWidget(context),
                  _finishShiftWidgets(context, workingBloc.jobModel),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
            );
          },
        );
      },
    );
  }

  Widget _startShiftWidgets(BuildContext context, JobModel workingJob) {
    return Column(
      children: <Widget>[
        _startButton(context, workingJob),
        DateTimeInputWidget(
          pickerWidth: 300,
          dateTimeWidget: _startPicker,
          yAdjustment: 24.0,
          arrowAdjustment: 0.50,
        ),
      ],
    );
  }

  Widget _startPicker(BuildContext context, DateTime dateTime) {
    final String date = (dateTime == null) ? 'Start' : formattedDate(dateTime);
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

  Widget _startButton(BuildContext context, JobModel workingJob) {
    return Container(
        child: Column(
      children: <Widget>[
        RaisedButton(
          child: Text(
            'START',
            style: TextStyle(fontSize: 22.0),
          ),
          onPressed: () {},
        )
      ],
    ));
  }

  Widget _elapsedTimeWidget(BuildContext context) {
    final double fontSize = textSizeMap[TextSizes.subtitle1];
    return Container(
      child: Center(
        child: Text(
          '---',
          style: TextStyle(fontSize: fontSize, color: Colors.white),
        ),
      ),
      color: ModeColor(light: Color(0xff259814), dark: Color(0xff0f4009)).color(context),
      height: DateTimePickerWidgetSize.height,
      width: DateTimePickerWidgetSize.width,
    );
  }

  Widget _finishShiftWidgets(BuildContext context, JobModel workingJob) {
    return Column(
      children: <Widget>[
        _finishButton(context, workingJob),
        DateTimeInputWidget(
          pickerWidth: 300,
          dateTimeWidget: _finishPicker,
          arrowAdjustment: 0.20,
        ),
      ],
    );
  }

  Widget _finishButton(BuildContext context, JobModel workingJob) {
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

  Widget _finishPicker(BuildContext context, DateTime dateTime) {
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
