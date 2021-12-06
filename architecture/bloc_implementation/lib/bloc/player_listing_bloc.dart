import 'package:bloc/bloc.dart';
import 'package:bloc_implementation/bloc/player_listing_events.dart';
import 'package:bloc_implementation/bloc/player_listing_states.dart';
import 'package:bloc_implementation/models/api_models.dart';
import 'package:bloc_implementation/services/repository.dart';

class PlayerListingBloc extends Bloc<PlayerListingEvent, PlayerListingState> {
  final PlayerRepository playerRepository;

  /// flutter_bloc v.8.x มีการเปลี่ยน API โดยเปลี่ยนจาก return yield เป็น emit callback
  /// Youtube codeMobile: https://www.youtube.com/watch?v=xREy39B2kTw&t=130s
  PlayerListingBloc({required this.playerRepository})
      : super(PlayerUninitializedState()) {
    on<CountrySelectedEvent>(_onCountrySelectedEvent);
    on<SearchTextChangedEvent>(_onSearchTextChangedEvent);
    on<AdvanceSearchChangeEvent>(_onAdvanceSearchChangeEvent);
  }

  _onAdvanceSearchChangeEvent(AdvanceSearchChangeEvent event, Emitter emit) async {
    print("_onAdvanceSearchChangeEvent");
    emit(PlayerFetchingState());
    try {
      List<Players> players =
      await playerRepository.fetchPlayersSearchConfiguration(event.searchConfiguration);

      parseResponse(players, emit);
    } catch (_) {
      emit(PlayerErrorState());
    }
  }

  _onSearchTextChangedEvent(SearchTextChangedEvent event, Emitter emit) async {
    print("_onSearchTextChangedEvent");
    emit(PlayerFetchingState());
    try {
      List<Players> players =
          await playerRepository.fetchPlayersByName(event.searchTerm);

      parseResponse(players, emit);
    } catch (_) {
      emit(PlayerErrorState());
    }
  }

  _onCountrySelectedEvent(CountrySelectedEvent event, Emitter emit) async {

    print("_onCountrySelectedEvent");
    emit(PlayerFetchingState());
    try {
      List<Players> players = await playerRepository
          .fetchPlayersByCountry(event.nationModel.countryId);

      parseResponse(players, emit);
    } catch (_) {
      emit(PlayerErrorState());
    }
  }

  void parseResponse(List<Players> players, Emitter<dynamic> emit) {
    if (players.isEmpty) {
      emit(PlayerEmptyState());
    } else {
      emit(PlayerFetchedState(players: players));
    }
  }

  /// For flutter_bloc below 7.x
// @override
// Stream<PlayerListingEvent> transform(Stream<PlayerListingEvent> events) {
//   return (events as PublishSubject<PlayerListingEvent>)
//       .transform(DebounceStreamTransformer(Duration(milliseconds: 250)));
// }

// @override
// void onTransition(Transition<PlayerListingEvent, PlayerListingState> transition) {
//   super.onTransition(transition);
//   print(transition);
// }

// @override
// Stream<PlayerListingState> mapEventToState(
//     PlayerListingState currentState, PlayerListingEvent event) async* {
//   print("mapEventToState");
//   yield PlayerFetchingState();
//   try {
//     List<Players> players = [];
//     if (event is CountrySelectedEvent) {
//       players = await playerRepository
//           .fetchPlayersByCountry(event.nationModel.countryId);
//     } else if (event is SearchTextChangedEvent) {
//       print("hitting service");
//       players = await playerRepository.fetchPlayersByName(event.searchTerm);
//     }
//     if (players.isEmpty) {
//       yield PlayerEmptyState();
//     } else {
//       yield PlayerFetchedState(players: players);
//     }
//   } catch (_) {
//     yield PlayerErrorState();
//   }
// }
}
