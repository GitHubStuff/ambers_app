import 'package:ambers_app/models/job_model.dart';
import 'package:ambers_app/sqlite/ambers_app/table_jobs/jobs.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_package/tracers/tracers.dart' as Log;
import 'package:flutter_sqlite_controller/flutter_sqlite_controller.dart' as SQL;

import 'job_event.dart';
import 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  JobModel _jobModel;

  @override
  JobState get initialState => InitialJobState(_jobModel);

  @override
  Stream<JobState> mapEventToState(JobEvent event) async* {
    if (event is AddJobEvent) {
      yield* _addJob(event.jobModel);
    } else if (event is LoadJobEvent) {
      yield* _loadJobs();
    }
  }

  Stream<JobState> _addJob(JobModel job) async* {
    final t = await SQL.SqliteController.initialize(name: dbName);
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

Stream<JobState> _loadJobs() async* {
  List<Jobs> jobs = await Jobs.read();
  yield LoadedJobsState(jobs: jobs);
}
