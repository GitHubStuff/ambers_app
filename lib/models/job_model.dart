import 'package:ambers_app/sqlite/ambers_app/table_jobs/jobs.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String dbName = 'amber.db';

class JobModel {
  final num recordId;
  final String title;
  final String description;
  final String rate;
  double get rateValue => double.parse(rate);
  String get rateString => rateValue.toStringAsFixed(2);
  String earnings(num hours, num minutes, num seconds) {
    if (hours == 0 && minutes == 0 && seconds == 0) return '';
    final formatCurrency = NumberFormat.simpleCurrency();

    num perSecond = rateValue / 3600.0;
    num amount = (hours * rateValue) + (minutes * 60 * perSecond) + (seconds * perSecond);
    String tally = formatCurrency.format(amount);
    return '$tally';
  }

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
