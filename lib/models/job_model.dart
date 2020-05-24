import 'package:ambers_app/sqlite/ambers_app/table_jobs/jobs.g.dart';
import 'package:flutter/material.dart';

const String dbName = 'amber.db';

class JobModel {
  final num recordId;
  final String title;
  final String description;
  final String rate;
  double get rateValue => double.parse(rate);
  String get rateString => rateValue.toStringAsFixed(2);

  JobModel({
    this.recordId,
    @required this.title,
    @required this.description,
    @required this.rate,
  });

  factory JobModel.fromDB(Jobs jobs) {
    return JobModel(
      recordId: jobs.rowid,
      title: jobs.name,
      description: jobs.description,
      rate: jobs.rate.toString(),
    );
  }
}
