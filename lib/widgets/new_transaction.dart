import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  const NewTransaction(
    this.addNewTransaction, {
    Key? key,
  }) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) return;

    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0 || _selectedDate == null) return;

    widget.addNewTransaction(title, amount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        _selectedDate = value;
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
                right: 10,
                left: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              TextField(
                decoration: const InputDecoration(labelText: "Title"),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Amount"),
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate as DateTime)}'),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: const Text("Choose Date",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _submitData,
                  child: const Text(
                    "Add Transaction",
                  ))
            ])),
      ),
    );
  }
}
