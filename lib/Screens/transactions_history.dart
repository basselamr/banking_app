import 'package:flutter/material.dart';
import '../Classes/db_helper.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key});

  @override
  Widget build(BuildContext context) {
    dbHelper obj = dbHelper();
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.keyboard_backspace_sharp),
        onPressed: () => Navigator.pop(context),
      )),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: obj.getTransfers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Display a message when there are no transactions
              return const Center(
                child: Text(
                  'No transactions found.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              final transfers = snapshot.data;
              return SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Sender Name')),
                    DataColumn(label: Text('Receiver Name')),
                    DataColumn(label: Text('Amount')),
                  ],
                  rows: transfers!.map<DataRow>((transfer) {
                    return DataRow(
                      cells: [
                        DataCell(Text(transfer['senderName'])),
                        DataCell(Text(transfer['receiverName'])),
                        DataCell(Text(transfer['amount'].toString())),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
