import 'package:ambers_app/job_bloc/job_bloc.dart';
import 'package:ambers_app/job_bloc/job_event.dart';
import 'package:ambers_app/job_bloc/job_state.dart';
import 'package:ambers_app/models/amber_theme.dart';
import 'package:ambers_app/models/job_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobListScreen extends StatefulWidget {
  static const route = '/jobListScreen';

  final JobModel jobModel;
  final JobBloc jobBloc;

  JobListScreen({Key key, @required this.jobModel, @required this.jobBloc}) : super(key: key);

  @override
  _JobListScreen createState() => _JobListScreen();
}

class _JobListScreen extends State<JobListScreen> {
  static const title = 'Job List';
  final _titleController = TextEditingController();
  final _rateController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _scaffold(context);
  }

  @override
  void dispose() {
    _rateController.dispose();
    _descriptionController.dispose();
    _titleController.dispose();

    super.dispose();
  }

  Widget _scaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AmbersThemes.arrowColor(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _title(context),
            _rate(context),
            _notes(context),
            _button(context),
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      children: [
        Text(
          'Title',
          style: AmbersThemes.bodyText(context),
        ),
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _rate(BuildContext context) {
    return Column(
      children: [
        Text(
          'Rate',
          style: AmbersThemes.bodyText(context),
        ),
        TextField(
          controller: _rateController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }

  Widget _notes(BuildContext context) {
    return Column(
      children: [
        Text(
          'Notes',
          style: AmbersThemes.bodyText(context),
        ),
        TextField(
          controller: _descriptionController,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 2,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _button(BuildContext context) {
    return BlocBuilder(
      bloc: widget.jobBloc,
      builder: (context, JobState jobState) {
        if (jobState is NewJobState) {
          widget.jobBloc.add(LoadJobEvent());
          // Delay needed because widget is being rebuilt and
          // cannot be popped.
          Future.delayed(Duration(milliseconds: 250), () {
            Navigator.pop(context);
          });
          return Container();
        }
        return (widget.jobModel == null)
            ? RaisedButton(
                child: Text('Add', style: Theme.of(context).textTheme.headline5),
                onPressed: () {
                  _addAction(context);
                },
              )
            : RaisedButton(
                child: Text('Update', style: Theme.of(context).textTheme.headline5),
                onPressed: () {
                  /// Navigator.push(context, MaterialPageRoute(builder: (context) => Berky()));
                },
              );
      },
    );
  }

  void _addAction(BuildContext context) {
    final JobModel payload = JobModel(
      description: _descriptionController.text,
      title: _titleController.text,
      rate: _rateController.text,
    );
    widget.jobBloc.add(AddJobEvent(jobModel: payload));
  }
}
