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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
    final String? title = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );

    if (title != null && title.isNotEmpty && mounted) {
      setState(() => _expenses.add(title));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added: $title'),
          backgroundColor: Colors.teal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── DELETE — no undo ──
  void _deleteExpense(int index) {
    final String deleted = _expenses[index];

    setState(() => _expenses.removeAt(index));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted: $deleted'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        // No SnackBarAction = no UNDO button
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FAF8),
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Expense',
            onPressed: _openAddExpensePage,
          ),
        ],
      ),
      body: _expenses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 72,
                    color: Colors.teal.shade200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses yet.\nTap + Add to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.teal.shade300),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _expenses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey('$index-${_expenses[index]}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteExpense(index),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Icon(
                          Icons.receipt_long,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      title: Text(
                        _expenses[index],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Expense #${index + 1}',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade400,
                        ),
                        tooltip: 'Delete',
                        onPressed: () => _deleteExpense(index),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpensePage,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
        backgroundColor: Colors.teal,
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
      backgroundColor: const Color(0xFFF0FAF8),
      appBar: AppBar(
        title: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card
            Card(
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.add_card, color: Colors.teal.shade600, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Enter expense details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Expense title',
                hintText: 'e.g. Coffee, Groceries...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                errorText: _errorMessage,
                prefixIcon: const Icon(Icons.edit_note, color: Colors.teal),
                labelStyle: const TextStyle(color: Colors.teal),
              ),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: Colors.teal),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
