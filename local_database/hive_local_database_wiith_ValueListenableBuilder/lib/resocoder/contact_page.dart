import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_local_database/resocoder/models/contact.dart';

import 'new_contact_form.dart';

class ContactPage extends StatelessWidget {
  ContactPage({
    Key? key,
  }) : super(key: key);

  final ValueListenable _valueListenable = Hive.box<dynamic>('contacts').listenable();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hive Tutorial'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildListView()),
            const NewContactForm(),
          ],
        ));
  }

  Widget _buildListView() {
    return ValueListenableBuilder<dynamic>(
      valueListenable: _valueListenable,
      builder: (context, contactsBox, _) {
        return ListView.builder(
          itemCount: contactsBox.length,
          itemBuilder: (context, index) {
            final contact = contactsBox.getAt(index) as Contact;

            return ListTile(
              title: Text(contact.name),
              subtitle: Text(contact.age.toString()),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      contactsBox.putAt(
                        index,
                        Contact('${contact.name}*', contact.age + 1),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      contactsBox.deleteAt(index);
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
