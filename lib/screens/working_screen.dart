import 'package:ambers_app/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_time_popover/date_time_picker/common.dart';
import 'package:flutter_date_time_popover/flutter_date_time_popover.dart';

const Size PickerSize = Size(275, 48);

class WorkingScreen extends StatelessWidget {
  static const route = '/workingScreen';

  const WorkingScreen({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    final JobModel workingModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(workingModel.title),
      ),
      body: _body(context, workingModel),
    );
  }

  Widget _body(BuildContext context, JobModel workingJob) {
    return Center(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(workingJob.description),
        ),
        Text('Rate: \$${workingJob.rateString}/HR'),
        _startShiftWidgets(context, workingJob),
        _elapsedTimeWidget(context),
        _finishShiftWidgets(context, workingJob),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    ));
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
      width: PickerSize.width,
      height: PickerSize.height,
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
      height: PickerSize.height,
      width: PickerSize.width,
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
      width: PickerSize.width,
      height: PickerSize.height,
      child: Center(
        child: Text(
          '$date $time',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
