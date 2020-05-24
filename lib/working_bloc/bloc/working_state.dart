part of 'working_bloc.dart';

abstract class WorkingState extends Equatable {
  const WorkingState();
}

class WorkingInitial extends WorkingState {
  @override
  List<Object> get props => [];
}
