part of 'location_cubit.dart';


sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationSuccess extends LocationState {
  final String address;

  LocationSuccess(this.address);
}

final class LocationFailure extends LocationState {
  final String message;

  LocationFailure(this.message);
}


