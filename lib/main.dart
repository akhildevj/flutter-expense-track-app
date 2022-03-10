import 'package:flutter/material.dart';

import './models/transaction.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Expense Track App',
        home: const MyHomePage(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'QuickSand',
          textTheme: const TextTheme(
              titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  final List<Transaction> _userTransactions = [
    Transaction(
        id: DateTime.now().toString(),
        title: "Flipkart",
        amount: 7500,
        date: DateTime.now()),
    Transaction(
        id: DateTime.now().toString(),
        title: "Amazon",
        amount: 8800,
        date: DateTime.now().subtract(const Duration(days: 1))),
    Transaction(
        id: DateTime.now().toString(),
        title: "Myntra",
        amount: 6600,
        date: DateTime.now().subtract(const Duration(days: 1))),
    Transaction(
        id: DateTime.now().toString(),
        title: "Swiggy",
        amount: 150,
        date: DateTime.now().subtract(const Duration(days: 2))),
    Transaction(
        id: DateTime.now().toString(),
        title: "Zomato",
        amount: 200,
        date: DateTime.now().subtract(const Duration(days: 2))),
    Transaction(
        id: DateTime.now().toString(),
        title: "Uber",
        amount: 600,
        date: DateTime.now().subtract(const Duration(days: 3))),
    Transaction(
        id: DateTime.now().toString(),
        title: "SBI",
        amount: 10000,
        date: DateTime.now().subtract(const Duration(days: 4))),
    Transaction(
        id: DateTime.now().toString(),
        title: "LIC",
        amount: 2500,
        date: DateTime.now().subtract(const Duration(days: 5))),
  ];

  // final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((tx) =>
            tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTransaction = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text("Expense Track App"),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: const Icon(Icons.add))
      ],
    );

    final transactionListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
          transactions: _userTransactions,
          deleteTransaction: _deleteTransaction),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Show Chart"),
                  Switch(
                      value: _showChart,
                      onChanged: (value) {
                        setState(() {
                          _showChart = value;
                        });
                      }),
                ],
              ),
            if (!isLandscape)
              SizedBox(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.3,
                  child: Chart(recentTransactions: _recentTransactions)),
            if (!isLandscape) transactionListWidget,
            if (isLandscape)
              _showChart
                  ? SizedBox(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(recentTransactions: _recentTransactions))
                  : transactionListWidget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
