import 'package:flutter/material.dart';
import 'package:flutter_architecture/src/model/Locals/person.dart';
import 'package:flutter_architecture/src/pages/management/management_viewmodel.dart';

class ManagementPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Management Page'),
      ),
      body: MyCustomForm(),
    );
  }
}

enum Gender { M, F }

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  Gender _gender;
  Person _person;
  ManagementViewModel _viewModel;

  @override
  void initState() {
    _gender = Gender.M;
    _person = Person();
    _person.sex = "M";
    _viewModel = ManagementViewModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Fullname",
                  hintText: "Fullname",
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Full Name';
                  }
                  return null;
                },
                onSaved: (String value) {
                  _person.name = value;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Age",
                  hintText: "Age",
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Age';
                  }
                  return null;
                },
                onSaved: (String value) {
                  _person.age = int.parse(value);
                },
              ),
              RadioListTile(
                  title: Text('Male'),
                  value: Gender.M,
                  groupValue: _gender,
                  onChanged: (Gender value) {
                    setState(() {
                      _gender = value;
                      _person.sex = "M";
                    });
                  }),
              RadioListTile(
                  title: Text('Female'),
                  value: Gender.F,
                  groupValue: _gender,
                  onChanged: (Gender value) {
                    setState(() {
                      _gender = value;
                      _person.sex = "F";
                    });
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please Enter Data'),
                        ),
                      );
                    } else {
                      _formKey.currentState.save();
                      String msg = await _viewModel.insert(_person);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                        ),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          )),
    );
  }
}
