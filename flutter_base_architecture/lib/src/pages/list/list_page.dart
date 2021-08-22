import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_architecture/src/config/app_route.dart';
import 'package:flutter_architecture/src/model/Locals/person.dart';
import 'package:flutter_architecture/src/pages/list/list_viewmodel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:logger/logger.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ListViewModel viewModel;
  var _isVisible;
  ScrollController _hideButtonController;
  Logger _logger;
  @override
  initState() {
    viewModel = ListViewModel();
    _logger = Logger();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds
             */
          print("**** $_isVisible up"); //Move IO away from setState
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds
               */
            print("**** ${_isVisible} down"); //Move IO away from setState
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    viewModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List'),
      ),
      body: Container(
        child: FutureBuilder<List<Person>>(
          future: viewModel.getItem(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: Text("Loading"),
                ),
              );
            }
            var item = snapshot.data as List<Person>;
            return ListView.separated(
              controller: _hideButtonController,
              separatorBuilder: (context, index) => Divider(
                height: 0,
                thickness: 1,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  actionPane: SlidableScrollActionPane(),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        _logger.d("operation", "Delete data at index : $index");
                        await viewModel.deleteItem(index);
                        setState(() {

                        });
                      }
                    ),
                  ],
                  child: ListTile(
                    title: Text(
                      item[index].name ?? '',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                        "age: ${item[index].age}, sex: ${item[index].sex}"),
                    onTap: () {
                      // todo navigate to detail page
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          onPressed: () async {
            _logger.d("Navigation", "Navigate to $AppRoute.managementRoute");
            await Navigator.pushNamed(context, AppRoute.managementRoute);
            setState(() {

            });
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
