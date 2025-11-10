import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: BudgetCalculator()));

class BudgetCalculator extends StatefulWidget {
  @override
  _BudgetCalculatorState createState() => _BudgetCalculatorState();
}

class _BudgetCalculatorState extends State<BudgetCalculator> {
  final income = TextEditingController();
  final rent = TextEditingController();
  final other = TextEditingController();
  double balance = 0;

  void calc() {
    setState(() {
      final i = double.tryParse(income.text) ?? 0;
      final r = double.tryParse(rent.text) ?? 0;
      final o = double.tryParse(other.text) ?? 0;
      balance = i - (r + o);
    });
  }

  Widget field(String label, TextEditingController c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration:
              InputDecoration(labelText: label, border: OutlineInputBorder()),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Budget Calculator"), backgroundColor: Colors.blue),
      body: Column(
        children: [
          field("Income", income),
          field("Rent", rent),
          field("Other Expenses", other),
          ElevatedButton(onPressed: calc, child: Text("Calculate")),
          Text("Remaining: ₹${balance.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
