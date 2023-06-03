import 'package:expense_planner/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactionReceiver;
  final Function deleteTransaction;
  const TransactionList(this.transactionReceiver, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: transactionReceiver.isEmpty
            ? LayoutBuilder(builder: (ctx, constrain) {
                return Column(
                  children: <Widget>[
                    Text(
                      'transaction is empty!',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: constrain.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/image/waiting.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              })
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: FittedBox(
                            child: Text(
                              '\$${transactionReceiver[index].amount}',
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        transactionReceiver[index].title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd()
                            .format(transactionReceiver[index].date),
                      ),
                      trailing: MediaQuery.of(context).size.width > 460
                          ? TextButton(
                              onPressed: () => deleteTransaction(
                                  transactionReceiver[index].id),
                              child: Text('Delete'),
                            )
                          : IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deleteTransaction(
                                  transactionReceiver[index].id),
                            ),
                    ),
                  );
                },
                itemCount: transactionReceiver.length,
              ));
  }
}
