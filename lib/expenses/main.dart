import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'list.dart';
import 'create.dart';
import '../chart/main.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Consum',
        amount: 38.47,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: 'Cinema',
        amount: 4.95,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openaddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => CreateExpense(saveExpense: _addExpense));
  }

  void _addExpense(Expense newExpense) {
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _insertExpense(int expenseIndex, Expense newExpense) {
    setState(() {
      _registeredExpenses.insert(expenseIndex, newExpense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Expense "${expense.title}" deleted.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _insertExpense(expenseIndex, expense);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpnseTracker'),
        actions: [
          IconButton(
            onPressed: _openaddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: ExpensesList(
                expenses: _registeredExpenses,
                removeExpenseFunction: _removeExpense),
          ),
        ],
      ),
    );
  }
}
