import 'package:ambers_app/models/job_model.dart';
import 'package:ambers_app/sqlite/ambers_app/table_jobs/jobs.g.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_package/tracers/tracers.dart' as Log;
import 'package:flutter_sqlite_controller/flutter_sqlite_controller.dart' as SQL;

class JobBloc extends Bloc<JobEvent, JobState> {
  JobModel _jobModel;

  @override
  JobState get initialState => InitialJobState(_jobModel);

  @override
  Stream<JobState> mapEventToState(JobEvent event) async* {
    if (event is AddJobEvent) {
      yield* _addJob(event.jobModel);
    }
  }

  Stream<JobState> _addJob(JobModel job) async* {
    final t = SQL.SqliteController.initialize(name: dbName);
    Log.t('${t.toString()}');
    Jobs jobs = Jobs(name: job.title, description: job.description, rate: job.rateValue);
    final id = await jobs.create(link: SQL.SQLiteLink());
    final result = JobModel(
      description: job.description,
      title: job.title,
      rate: job.rate,
      recordId: id,
    );
    yield NewJobState(jobModel: result);
  }
}

abstract class JobEvent extends Equatable {
  const JobEvent();
  @override
  List<Object> get props => [];
}

class AddJobEvent extends JobEvent {
  final JobModel jobModel;
  const AddJobEvent({@required this.jobModel});

  @override
  List<Object> get props => [jobModel];
}

abstract class JobState extends Equatable {
  const JobState();
  @override
  List<Object> get props => [];
}

class InitialJobState extends JobState {
  final JobModel jobModel;
  const InitialJobState(this.jobModel);
}

class NewJobState extends JobState {
  final JobModel jobModel;
  const NewJobState({this.jobModel});
  @override
  List<Object> get props => [jobModel];
}
