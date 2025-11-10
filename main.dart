import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monthly Expense Manager',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: InputScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  final incomeController = TextEditingController();
  final rentController = TextEditingController();
  final foodController = TextEditingController();
  final transportController = TextEditingController();
  final othersController = TextEditingController();

  @override
  void dispose() {
    incomeController.dispose();
    rentController.dispose();
    foodController.dispose();
    transportController.dispose();
    othersController.dispose();
    super.dispose();
  }

  void _calculateAndNavigate() {
    if (_formKey.currentState!.validate()) {
      double income = double.parse(incomeController.text);
      double rent = double.parse(rentController.text);
      double food = double.parse(foodController.text);
      double transport = double.parse(transportController.text);
      double others = double.parse(othersController.text);

      double balance = income - (rent + food + transport + others);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            income: income,
            rent: rent,
            food: food,
            transport: transport,
            others: others,
            balance: balance,
          ),
        ),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        double? val = double.tryParse(value);
        if (val == null || val < 0) return 'Enter a valid positive number';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monthly Budget Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Monthly Income', incomeController),
              SizedBox(height: 10),
              _buildTextField('Rent / EMI', rentController),
              SizedBox(height: 10),
              _buildTextField('Food Expenses', foodController),
              SizedBox(height: 10),
              _buildTextField('Transport Expenses', transportController),
              SizedBox(height: 10),
              _buildTextField('Other Expenses', othersController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateAndNavigate,
                child: Text('Calculate Balance'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double income, rent, food, transport, others, balance;

  const ResultScreen({
    Key? key,
    required this.income,
    required this.rent,
    required this.food,
    required this.transport,
    required this.others,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isNegative = balance < 0;
    return Scaffold(
      appBar: AppBar(title: Text('Expense Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Monthly Income: ₹${income.toStringAsFixed(2)}"),
                Text("Rent / EMI: ₹${rent.toStringAsFixed(2)}"),
                Text("Food Expenses: ₹${food.toStringAsFixed(2)}"),
                Text("Transport Expenses: ₹${transport.toStringAsFixed(2)}"),
                Text("Other Expenses: ₹${others.toStringAsFixed(2)}"),
                Divider(thickness: 1, height: 30),
                Text(
                  "Remaining Balance: ₹${balance.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: isNegative ? Colors.red : Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  isNegative
                      ? "⚠️ You are overspending!"
                      : "✅ Great! You are saving money.",
                  style: TextStyle(
                    color: isNegative ? Colors.red : Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Go Back'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
