part of 'working_bloc.dart';

abstract class WorkingEvent extends Equatable {
  const WorkingEvent();
  List<Object> get props => [];
}

class PauseShiftTimerEvent extends WorkingEvent {
  const PauseShiftTimerEvent();
}

class RefreshElapsedTimeEvent extends WorkingEvent {
  final DateTimeIntervals dateTimeIntervals;

  final Timesheet timesheet;
  const RefreshElapsedTimeEvent({this.dateTimeIntervals, this.timesheet});
  List<Object> get props => [dateTimeIntervals, timesheet];
}

class EndShiftEvent extends WorkingEvent {
  final DateTime endShiftDateTime;
  
  const EndShiftEvent(this.endShiftDateTime);
  @override
  List<Object> get props => [endShiftDateTime];
}

class RestartShiftTimerEvent extends WorkingEvent {
  const RestartShiftTimerEvent();
}

class StartShiftEvent extends WorkingEvent {
  final DateTime dateTime;
  const StartShiftEvent({@required this.dateTime});
  @override
  List<Object> get props => [dateTime];
}

class UpdateShiftStartEvent extends WorkingEvent {
  final DateTime dateTime;
  const UpdateShiftStartEvent({@required this.dateTime});
  @override
  List<Object> get props => [dateTime];
}
