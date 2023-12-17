import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../Dashboard/dashboard.dart';
import '../../Database/database_helper.dart';

class AddCustomerPage extends StatefulWidget {
  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _selectedGender = 'Male';
  List<String> _selectedHabits = [];

  Future<void> saveCustomerData() async {
    final database = await DatabaseHelper().database;

    // Check if the 'customers' table exists, and create it if not
    await database.execute('''
    CREATE TABLE IF NOT EXISTS customers (
      id INTEGER PRIMARY KEY,
      name TEXT,
      email TEXT,
      gender TEXT,
      habits TEXT
    )
  ''');

    await database.insert(
      'customers',
      {
        'name': _nameController.text,
        'email': _emailController.text,
        'gender': _selectedGender,
        'habits': _selectedHabits.join(', '),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Navigate to the DashboardPage after saving customer data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(customer: {
          'name': _nameController.text,
          'email': _emailController.text,
          'gender': _selectedGender,
        }),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
        elevation: 5,
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  items: ['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  children: [
                    Text('Habits:'),
                    CheckboxListTile(
                      title: Text('Reading'),
                      value: _selectedHabits.contains('Reading'),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            _selectedHabits.add('Reading');
                          } else {
                            _selectedHabits.remove('Reading');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Writing'),
                      value: _selectedHabits.contains('Writing'),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            _selectedHabits.add('Writing');
                          } else {
                            _selectedHabits.remove('Writing');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Playing'),
                      value: _selectedHabits.contains('Playing'),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            _selectedHabits.add('Playing');
                          } else {
                            _selectedHabits.remove('Playing');
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Binge watching'),
                      value: _selectedHabits.contains('Binge watching'),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            _selectedHabits.add('Binge watching');
                          } else {
                            _selectedHabits.remove('Binge watching');
                          }
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await saveCustomerData();
                    // Add logic to navigate or show a success message
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Save Customer',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
