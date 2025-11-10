import 'package:flutter/material.dart';

void main() {
  runApp(LoanEligibilityApp());
}

class LoanEligibilityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Eligibility Checker',
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

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final salaryController = TextEditingController();
  final emiController = TextEditingController();
  final loanController = TextEditingController();

  void _resetForm() {
    nameController.clear();
    ageController.clear();
    salaryController.clear();
    emiController.clear();
    loanController.clear();
  }

  void _checkEligibility() {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text.trim();
      int age = int.parse(ageController.text);
      double salary = double.parse(salaryController.text);
      double existingEmi = double.parse(emiController.text);
      double requestedLoan = double.parse(loanController.text);

      double maxLoan = salary * 10;

      // New EMI (assuming 10% of loan per year as simple estimate)
      double newEmi = requestedLoan * 0.1;

      double dti = ((existingEmi + newEmi) / salary) * 100;

      String eligibilityMessage = "";
      bool eligible = true;

      if (age < 21 || age > 60) {
        eligible = false;
        eligibilityMessage += "❌ Age should be between 21 and 60.\n";
      }
      if (requestedLoan > maxLoan) {
        eligible = false;
        eligibilityMessage += "❌ Loan requested exceeds 10× monthly salary.\n";
      }
      if (dti > 60) {
        eligible = false;
        eligibilityMessage += "❌ Debt-to-Income Ratio exceeds 60%.\n";
      }

      if (eligible) {
        eligibilityMessage =
            "✅ Eligible for loan!\nApproved Loan: ₹${requestedLoan.toStringAsFixed(2)}\nEstimated EMI: ₹${newEmi.toStringAsFixed(2)}\nDTI: ${dti.toStringAsFixed(1)}%";
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            name: name,
            age: age,
            salary: salary,
            existingEmi: existingEmi,
            requestedLoan: requestedLoan,
            dti: dti,
            eligible: eligible,
            message: eligibilityMessage,
          ),
        ),
      );
    }
  }

  Widget _buildTextField(
      String label, TextEditingController controller, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter $label';
        if (type == TextInputType.number ||
            type == TextInputType.numberWithOptions()) {
          double? val = double.tryParse(value);
          if (val == null || val < 0) return 'Enter a valid positive value';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Loan Eligibility - Input")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Name", nameController, TextInputType.text),
              SizedBox(height: 10),
              _buildTextField("Age", ageController, TextInputType.number),
              SizedBox(height: 10),
              _buildTextField(
                  "Monthly Salary (₹)", salaryController, TextInputType.number),
              SizedBox(height: 10),
              _buildTextField("Existing EMI/Debts (₹)", emiController,
                  TextInputType.number),
              SizedBox(height: 10),
              _buildTextField("Loan Amount Requested (₹)", loanController,
                  TextInputType.number),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _checkEligibility,
                    child: Text("Check Eligibility"),
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 12)),
                  ),
                  OutlinedButton(
                    onPressed: _resetForm,
                    child: Text("Reset"),
                    style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final String name, message;
  final int age;
  final double salary, existingEmi, requestedLoan, dti;
  final bool eligible;

  const ResultScreen({
    Key? key,
    required this.name,
    required this.age,
    required this.salary,
    required this.existingEmi,
    required this.requestedLoan,
    required this.dti,
    required this.eligible,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Loan Eligibility Result")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: $name", style: TextStyle(fontSize: 16)),
                Text("Age: $age", style: TextStyle(fontSize: 16)),
                Text("Monthly Salary: ₹${salary.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16)),
                Text("Existing Debts: ₹${existingEmi.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16)),
                Text("Loan Requested: ₹${requestedLoan.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Divider(),
                Text(
                  "Eligibility Result:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                    color: eligible ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Back"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
