import 'package:bloc_implementation/models/nation.dart';
import 'package:bloc_implementation/search_configuration.dart';
import 'package:equatable/equatable.dart';

abstract class PlayerListingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CountrySelectedEvent extends PlayerListingEvent {
  final NationModel nationModel;

  CountrySelectedEvent({required this.nationModel});

  @override
  List<Object> get props => [nationModel];
}

class SearchTextChangedEvent extends PlayerListingEvent {
  final String searchTerm;

  SearchTextChangedEvent({required this.searchTerm});
}

class AdvanceSearchChangeEvent extends PlayerListingEvent {
  final SearchConfiguration searchConfiguration;

  AdvanceSearchChangeEvent({required this.searchConfiguration});

  @override
  List<Object> get props => [searchConfiguration];
}
