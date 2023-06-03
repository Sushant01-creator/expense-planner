import 'dart:io';

import 'package:expense_planner/widget/card.dart';
import 'package:expense_planner/widget/new_transaction.dart';
import '../model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widget/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    Expense_planner(),
  );
}

class Expense_planner extends StatelessWidget {
  Expense_planner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expense_planner",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
            titleLarge: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: const TextStyle(
                  fontFamily: 'OpenS',
                  fontSize: 20,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //MyHomePage({super.key});
  final List<Transaction> transactions = [
    // Transaction(
    //   id: "first",
    //   title: "new_shoes",
    //   amount: 200.22,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: "second",
    //   title: "hand_bag",
    //   amount: 100.55,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransaction {
    return transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addTransaction(String txTitle, double txAmount, DateTime choosenDate) {
    final txVar = Transaction(
      title: txTitle,
      amount: txAmount,
      date: choosenDate,
      id: DateTime.now.toString(),
    );

    setState(() {
      transactions.add(txVar);
    });
  }

  void startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void removeTransaction(String id) {
    setState(() {
      return transactions.removeWhere((element) => element.id == id);
    });
  }

  bool showChart = false;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Expense_planner"),
      actions: <Widget>[
        IconButton(
          onPressed: () => startAddNewTransaction(context),
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );

    final isLandScape = MediaQuery.of(context).orientation == Orientation;
    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.6,
      child: TransactionList(transactions, removeTransaction),
    );

    final bodyPage = Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,

      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isLandScape)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("show ChartBar"),
              Switch(
                  value: showChart,
                  onChanged: (val) {
                    setState(() {
                      showChart = val;
                    });
                  })
            ],
          ),
        if (!isLandScape)
          Container(
            height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                0.3,
            child: Chart(_recentTransaction),
          ),
        if (!isLandScape) txListWidget,
        if (isLandScape)
          showChart
              ? Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.7,
                  child: Chart(_recentTransaction),
                )
              : txListWidget,
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: bodyPage,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => startAddNewTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
