import 'package:flutter/material.dart';
import '../../Database/database_helper.dart';

class EditCustomerPage extends StatefulWidget {
  final Map<String, dynamic> customer;
  final VoidCallback reloadCustomers; // Add this line

  EditCustomerPage({required this.customer, required this.reloadCustomers});

  @override
  _EditCustomerPageState createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String _selectedGender = 'Male';
  List<String> _selectedHabits = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing customer data
    nameController.text = widget.customer['name'];
    emailController.text = widget.customer['email'];
    _selectedGender = widget.customer['gender'];
    // Assuming habits are stored as a comma-separated string
    _selectedHabits = widget.customer['habits'].split(', ');
  }

  Future<void> updateCustomerData() async {
    try {
      final database = await DatabaseHelper().database;

      await database.update(
        'customers',
        {
          'name': nameController.text,
          'email': emailController.text,
          'gender': _selectedGender,
          'habits': _selectedHabits.join(', '), // Join habits into a string
        },
        where: 'id = ?',
        whereArgs: [widget.customer['id']],
      );

      // Navigate back to the previous screen (DashboardPage)
      Navigator.pop(context);

      // Call the callback to reload customers
      widget.reloadCustomers(); // Trigger reload here
    } catch (e) {
      print('Error updating customer data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
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
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
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
                    // Add more CheckboxListTile widgets for other habits
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await updateCustomerData();
                    // Add logic to navigate or show a success message
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text(
                    'Update Customer',
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
