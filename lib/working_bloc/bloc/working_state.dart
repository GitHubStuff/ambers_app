part of 'working_bloc.dart';

abstract class WorkingState extends Equatable {
  const WorkingState();
  List<Object> get props => [];
}

class WorkingInitial extends WorkingState {
  const WorkingInitial();
}

class ShiftStartedState extends WorkingState {
  final Timesheet timesheet;
  const ShiftStartedState({this.timesheet});
  @override
  List<Object> get props => [timesheet];
}

class ShiftTimerPausedEvent extends WorkingState {
  const ShiftTimerPausedEvent();
}

class UpdatedLapsedTimeState extends WorkingState {
  final DateTimeIntervals dateTimeIntervals;
  final Timesheet timesheet;
  const UpdatedLapsedTimeState({this.dateTimeIntervals, this.timesheet});
  @override
  List<Object> get props => [dateTimeIntervals, timesheet];
}