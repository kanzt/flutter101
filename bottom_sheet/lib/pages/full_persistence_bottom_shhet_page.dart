import 'package:flutter/material.dart';

class FullPersistenceBottomSheetPage extends StatefulWidget {
  const FullPersistenceBottomSheetPage({Key? key}) : super(key: key);

  @override
  _FullPersistenceBottomSheetPageState createState() =>
      _FullPersistenceBottomSheetPageState();
}

class _FullPersistenceBottomSheetPageState
    extends State<FullPersistenceBottomSheetPage> {
  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      title: Text(
        'FullPersistenceBottomSheetPage',
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(children: [_buildAppBar()],),
              SafeArea(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.3,
                  minChildSize: 0.2,
                  maxChildSize: 1.0,
                  builder: (BuildContext context, myScrollController) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.tealAccent[200],
                        child:
                        NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowIndicator();
                            return true;
                          },
                          child: ListView.builder(
                            controller: myScrollController,
                            itemCount: 25,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                  title: Text(
                                    'Dish $index',
                                    style: TextStyle(color: Colors.black54),
                                  ));
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
