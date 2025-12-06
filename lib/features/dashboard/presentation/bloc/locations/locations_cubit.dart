import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/location_entity.dart';
import '../../../domain/usecases/get_locations_usecase.dart';
import 'locations_state.dart';

class LocationsCubit extends Cubit<LocationsState> {
  LocationsCubit(this._getLocations) : super(const LocationsState());

  final GetLocationsUseCase _getLocations;

  static const String _defaultOrdering = 'name';

  Future<void> fetch({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    if (state.hasData && !forceRefresh) {
      return;
    }

    emit(
      state.copyWith(
        status: LocationsStatus.loading,
        resetMessage: true,
      ),
    );

    final result = await _getLocations(ordering: _defaultOrdering);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LocationsStatus.failure,
          message: failure.message,
        ),
      ),
      (locations) => emit(
        state.copyWith(
          status: LocationsStatus.success,
          locations: locations,
          resetMessage: true,
        ),
      ),
    );
  }

  LocationEntity? findById(int? id) {
    if (id == null) return null;
    for (final LocationEntity location in state.locations) {
      if (location.id == id) return location;
    }
    return null;
  }
}
