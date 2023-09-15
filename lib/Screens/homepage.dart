import 'package:flutter/material.dart';
import 'customers_screen.dart';
import '../Screens/transactions_history.dart';
import '../Classes/User.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextStyle balanceText = const TextStyle(color: Colors.black, fontSize: 13);
  final current_user = User(
    fname: 'Bassel',
    lname: 'Amr',
    email: 'bassel@gmail.com',
    phone_num: '01167836409',
    current_balance: 3000,
  );

  void updateCurrentUserBalance(double newBalance) {
    setState(() {
      current_user.current_balance = newBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        extendBodyBehindAppBar: false,
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          toolbarHeight: 50,
          title: const Text(
            'Banking App',
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('Assets/Images/cash.jpg'),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Set border radius
                        side: const BorderSide(
                            color: Colors.white), // Set border color
                      ),
                      fixedSize: const Size(180, 40),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'View All Customers',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => CustomersScreen(
                                current_user: current_user,
                                update_current_user: updateCurrentUserBalance,
                              )),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Set border radius
                        side: const BorderSide(
                            color: Colors.white), // Set border color
                      ),
                      fixedSize: const Size(180, 40),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'History',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const Transactions()),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextButton(
                      onPressed:
                          null, // Replace 'null' with your intended action
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0), // Set border radius
                          side: const BorderSide(
                              color: Colors.white), // Set border color
                        ),
                        fixedSize: const Size(180, 40),
                        backgroundColor: Colors.white,
                      ),
                      child: Text.rich(TextSpan(children: [
                        const TextSpan(
                            text: 'Current Balance is ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: "${current_user.current_balance}\$",
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 100, 211, 104),
                                fontWeight: FontWeight.bold))
                      ]))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
