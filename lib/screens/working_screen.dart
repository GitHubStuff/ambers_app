import 'package:ambers_app/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_time_popover/date_time_picker/common.dart';
import 'package:flutter_date_time_popover/flutter_date_time_popover.dart';

const Size PickerSize = Size(250, 30);

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
        Text(workingJob.description),
        Text('\$${workingJob.rateString}'),
        _startButton(context, workingJob),
        DateTimeInputWidget(
          pickerWidth: 300,
          dateTimeWidget: _startPicker,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceAround,
    ));
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

  Widget _startPicker(BuildContext context, DateTime dateTime) {
    final result = dateTime ?? DateTime.now();
    final String date = formattedDate(result);
    final String time = formattedTime(result);
    final double fontSize = textSizeMap[TextSizes.subtitle1];
    return Container(
      color: ModeColor(light: Color(0xffbdbdbd), dark: Colors.yellow).color(context),
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

  Widget _finishPicker(DateTime result) {
    final String date = formattedDate(result);
    final String time = formattedTime(result);
    final double fontSize = textSizeMap[TextSizes.caption];
    return Container(
      width: PickerSize.width,
      height: PickerSize.height,
      child: Text(
        '$date $time',
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
