import 'package:flutter/material.dart';

const String dbName = 'amber.db';

class JobModel {
  final int recordId;
  final String title;
  final String description;
  final String rate;
  double get rateValue => double.parse(rate);
  JobModel({
    this.recordId,
    @required this.title,
    @required this.description,
    @required this.rate,
  });
}
