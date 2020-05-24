import 'package:ambers_app/models/job_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

class LoadJobEvent extends JobEvent {
  const LoadJobEvent();
}
