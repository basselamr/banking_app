// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:flutter/material.dart';
import '../Classes/User.dart';
import '../Classes/db_helper.dart';

class CustomersScreen extends StatefulWidget {
  final User current_user;
  Function update_current_user;
  CustomersScreen(
      {required this.current_user, required this.update_current_user});
  @override
  _CustomersScreenState createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  dbHelper database = dbHelper();
  Future<List<User>> getUsers() async {
    return database.readUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('My Customers'),
      ),
      body: FutureBuilder<List<User>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No users found.');
          } else {
            final users = snapshot.data;
            return ListView.separated(
              itemCount: users!.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: Colors.grey,
                  height: 1.0,
                  thickness: 1.0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];
                return ListTile(
                  title: Container(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.fname,
                                  style: const TextStyle(fontSize: 23)),
                              Row(
                                children: [
                                  Text(
                                    user.current_balance.toString(),
                                    style: const TextStyle(color: Colors.green),
                                  ),
                                  const Icon(Icons.attach_money_sharp,
                                      size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 50),
                          ),
                          onPressed: () {
                            showDialogue(context, user);
                            // Show the dialog
                          },
                          icon: const Text(
                            'Transfer Money',
                            style: TextStyle(color: Colors.indigo),
                          ),
                          label: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void showDialogue(BuildContext context, User user) {
    TextEditingController amount = TextEditingController();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(
              20.0), // Increase padding for a larger dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: amount,
                decoration:
                    const InputDecoration(labelText: 'Amount to Transfer'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                  TextButton(
                    onPressed: () {
                      double enteredAmount =
                          double.tryParse(amount.text) ?? 0.0;
                      if (enteredAmount <=
                          widget.current_user.current_balance) {
                        Navigator.pop(context);
                        widget.current_user.current_balance =
                            widget.current_user.current_balance - enteredAmount;
                        user.current_balance =
                            user.current_balance + enteredAmount;
                        database.updateUserBalance(
                            user.fname, user.current_balance);

                        database.insertTransfer(widget.current_user.fname,
                            user.fname, enteredAmount);
                        widget.update_current_user(
                            widget.current_user.current_balance);
                        showTransferSuccessSnackbar(context);
                        setState(() {
                          user.current_balance =
                              user.current_balance + enteredAmount;
                        });
                      } else {
                        Navigator.pop(context);
                        showTransferFailureSnackbar(context);
                      }
                    },
                    child: const Text('Transfer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTransferSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Money transferred successfully!'),
      ),
    );
  }

  void showTransferFailureSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Insufficient Balance To Complete Transaction:('),
      ),
    );
  }
}
