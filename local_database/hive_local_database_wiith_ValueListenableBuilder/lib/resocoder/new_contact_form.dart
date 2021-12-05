import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_local_database/resocoder/models/contact.dart';


class NewContactForm extends StatefulWidget {
  const NewContactForm({Key? key}) : super(key: key);

  @override
  _NewContactFormState createState() => _NewContactFormState();
}

class _NewContactFormState extends State<NewContactForm> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _age;
  late Stream<BoxEvent> box = Hive.box('contacts').watch();
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    streamSubscription = box.listen((event) {
      if(!event.deleted && event.value != null) {
        print((event.value as Contact).name);
      }
      print((event.key));
    });

    super.initState();
  }


  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  void addContact(Contact contact) {
    final contactsBox = Hive.box('contacts');
    contactsBox.add(contact);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => _name = value!,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _age = value!,
                ),
              ),
            ],
          ),
          ElevatedButton(
            child: const Text('Add New Contact'),
            onPressed: () {
              _formKey.currentState!.save();
              final newContact = Contact(_name, int.parse(_age));
              addContact(newContact);
            },
          ),
        ],
      ),
    );
  }
}
