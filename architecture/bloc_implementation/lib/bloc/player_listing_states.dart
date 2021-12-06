import 'package:bloc_implementation/models/api_models.dart';
import 'package:equatable/equatable.dart';

abstract class PlayerListingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlayerUninitializedState extends PlayerListingState {}

class PlayerFetchingState extends PlayerListingState {}

class PlayerFetchedState extends PlayerListingState {
  final List<Players> players;

  @override
  List<Object> get props => [players];

  PlayerFetchedState({required this.players});

  PlayerFetchedState copyWith({
    required List<Players> players,
  }) {
    return PlayerFetchedState(
      players: players,
    );
  }
}

class PlayerErrorState extends PlayerListingState {}

class PlayerEmptyState extends PlayerListingState {}
