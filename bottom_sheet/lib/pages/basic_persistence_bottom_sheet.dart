import 'package:flutter/material.dart';

class BasicPersistenceBottomSheet extends StatefulWidget {
  const BasicPersistenceBottomSheet({Key? key}) : super(key: key);

  @override
  _BasicPersistenceBottomSheetState createState() =>
      _BasicPersistenceBottomSheetState();
}

class _BasicPersistenceBottomSheetState
    extends State<BasicPersistenceBottomSheet> {
  AppBar _buildAppBar() {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
      title: Text(
        'BasicPersistenceBottomSheet',
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (DraggableScrollableNotification dsNotification) {
                print("Current extent ${dsNotification.extent}");
                print("Current minExtent ${dsNotification.minExtent}");

                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.2,
                maxChildSize: 0.7,
                builder: (BuildContext context, myScrollController) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.tealAccent[200],
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
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
    );
  }
}
