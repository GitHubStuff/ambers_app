import 'package:ambers_app/models/job_model.dart';
import 'package:ambers_app/sqlite/ambers_app/table_jobs/jobs.g.dart';
import 'package:equatable/equatable.dart';

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

class LoadedJobsState extends JobState {
  final List<Jobs> jobs;
  const LoadedJobsState({this.jobs});
  @override
  List<Object> get props => [jobs];
}
