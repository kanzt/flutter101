import 'package:bloc_implementation/bloc/player_listing_bloc.dart';
import 'package:bloc_implementation/bloc/player_listing_events.dart';
import 'package:bloc_implementation/pages/advance_search_page.dart';
import 'package:bloc_implementation/pages/player_listing.dart';
import 'package:bloc_implementation/search_configuration.dart';
import 'package:bloc_implementation/services/repository.dart';
import 'package:bloc_implementation/themes/themes.dart';
import 'package:bloc_implementation/widgets/horizontal_bar.dart';
import 'package:bloc_implementation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final PlayerRepository playerRepository;
  const HomePage({Key? key, required this.playerRepository}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late final PlayerListingBloc _playerListingBloc;
  SearchConfiguration _searchConfiguration = SearchConfiguration();

  @override
  void initState() {
    super.initState();
    _playerListingBloc = PlayerListingBloc(playerRepository: widget.playerRepository);
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return _playerListingBloc;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Advanced Search"),
          icon: const Icon(Icons.filter_list),
          onPressed: () async {
            final resultMap = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdvancedSearchPage(
                      searchConfiguration: _searchConfiguration,
                    )));

            print(resultMap);
            _searchConfiguration = resultMap["search_configuration"];
            print(_searchConfiguration);
            _playerListingBloc
                .add(AdvanceSearchChangeEvent(searchConfiguration: _searchConfiguration));
          },
        ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: Text(
            'Football Players',
            style: appBarTextStyle,
          ),
        ),
        body: Column(
          children: const <Widget>[
            HorizontalBar(),
            SizedBox(height: 10.0),
            SearchBar(),
            SizedBox(height: 10.0),
            PlayerListing()
          ],
        ),
      ),
    );
  }
}

