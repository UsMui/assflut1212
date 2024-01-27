import 'package:assignment_s12/sql_helper.dart';
import 'package:flutter/material.dart';

import 'commend_model.dart';
// Assuming your SQLHelper file is named sql_helper.dart

class FormExample extends StatefulWidget {
  const FormExample({Key? key}) : super(key: key);

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  List<CommendModel> _userList = [];
  CommendModel? _selectedUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }


  Future<void> _loadData() async {
    final items = await SQLHelper.getItems();
    setState(() {
      _userList = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        hintText: "Input your name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Input your email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String name = _userNameController.text;
                      String email = _emailController.text;

                      if (_selectedUser == null) {

                        CommendModel newUser = CommendModel(name: name, email: email);
                        await SQLHelper.createItem(newUser);
                      } else {

                        _selectedUser!.name = name;
                        _selectedUser!.email = email;
                        await SQLHelper.updateItem(_selectedUser!);
                      }

                      _userNameController.clear();
                      _emailController.clear();
                      _selectedUser = null;

                      _loadData();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _userList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      subtitle: Row(
                        children: [
                          Column(
                            children: [
                              Text(_userList[index].name ?? "", ),
                              Text(_userList[index].email ?? ""),
                            ],
                          ),
                          SizedBox(width: 20,),
                          IconButton(
                            icon: Icon(
                              Icons.update,
                              color: Colors.blue,
                              size: 30.0,
                            ),
                            onPressed: () {

                              setState(() {
                                _selectedUser = _userList[index];
                                _userNameController.text = _selectedUser!.name!;
                                _emailController.text = _selectedUser!.email!;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 30.0,
                            ),
                            onPressed: () async {
                              await SQLHelper.deleteItem(_userList[index].id!);
                              _loadData();
                            },
                          ),
                        ],
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