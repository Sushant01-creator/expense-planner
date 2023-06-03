import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  //NewTransaction({super.key});
  late Function updateTransaction;

  NewTransaction(this.updateTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final addTitle = TextEditingController();

  final addAmount = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void submitData() {
    widget.updateTransaction(
      addTitle.text,
      double.parse(addAmount.text),
      selectedDate,
    );

    Navigator.of(context).pop();
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
                controller: addTitle,
                onSubmitted: (value) => submitData(),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Amount",
                ),
                controller: addAmount,
                keyboardType: TextInputType.number,
                onSubmitted: (value) => submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? "No date choosen"
                            : 'Picked Date is:${DateFormat.yMd().format(selectedDate)}',
                      ),
                    ),
                    TextButton(
                      onPressed: presentDatePicker,
                      child: Text("choose date"),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: submitData, child: const Text("Add Transactons"))
            ],
          ),
        ),
      ),
    );
  }
}
