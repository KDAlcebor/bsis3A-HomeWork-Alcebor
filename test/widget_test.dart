import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ExpensesHomePage(),
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 1 — ExpensesHomePage
// ─────────────────────────────────────────────
class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  final List<String> _expenses = [];

  Future<void> _openAddExpensePage() async {
    // Part A: Navigator.push with MaterialPageRoute
    final String? title = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );

    // Part B: Receive the returned data
    if (title != null && title.isNotEmpty && mounted) {
      setState(() => _expenses.add(title));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added: $title'),
          backgroundColor: Colors.indigo,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // Part A: "+ Add" button in AppBar
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Expense',
            onPressed: _openAddExpensePage,
          ),
        ],
      ),
      body: _expenses.isEmpty
          ? const Center(
              child: Text(
                'No expenses yet.\nTap + Add to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _expenses.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  title: Text(_expenses[index]),
                  subtitle: Text('Expense #${index + 1}'),
                );
              },
            ),
      // Part A: FloatingActionButton
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpensePage,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SCREEN 2 — AddExpensePage
// ─────────────────────────────────────────────
class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _titleController = TextEditingController();
  String? _errorMessage;

  void _save() {
    final String title = _titleController.text.trim();

    // Part B: Validate — show error if empty
    if (title.isEmpty) {
      setState(() => _errorMessage = 'Expense title cannot be empty.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an expense title.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Part B: Return title back to Home via Navigator.pop
    Navigator.pop(context, title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter expense details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            // Part B: TextField — label: "Expense title"
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Expense title',
                hintText: 'e.g. Coffee, Groceries...',
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
                prefixIcon: const Icon(Icons.edit_note),
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
            ),

            const SizedBox(height: 32),

            // Part B: Save button
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
