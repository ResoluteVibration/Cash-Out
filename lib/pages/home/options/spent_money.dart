import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/enums.dart';
import '../../../../models/transaction.dart';
import '../../../../providers/user_provider.dart';
import '../../../../providers/transaction_provider.dart';

class SpentMoneyPage extends StatefulWidget {
  const SpentMoneyPage({super.key});

  @override
  State<SpentMoneyPage> createState() => _SpentMoneyPageState();
}

class _SpentMoneyPageState extends State<SpentMoneyPage> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  TransactionMode? _selectedMode;
  TransactionCategory? _selectedCategory;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addTransaction() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final description = _descriptionController.text.trim();
    final user = userProvider.currentUser;

    if (user == null || amount <= 0 || _selectedMode == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final txn = TransactionModel(
        id: '', // Firestore will generate
        userId: user.id!,
        contactId: null,
        type: 'Expense',
        amount: amount,
        description: description.isEmpty ? null : description,
        date: DateTime.now(),
        mode: _selectedMode!.name,
        category: _selectedCategory!.name,
      );

      await transactionProvider.addTransaction(txn);

      final newAmount = (user.amount ?? 0) - amount;
      await userProvider.updateAmount(newAmount);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add expense: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final colors = userProvider.currentTheme.colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text('Lost Money', style: TextStyle(color: colors.onPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountInput(colors),
            const SizedBox(height: 24.0),
            _buildDescriptionInput(colors),
            const SizedBox(height: 16.0),
            _buildModeDropdown(colors),
            const SizedBox(height: 16.0),
            _buildCategoryDropdown(colors),
            const SizedBox(height: 24.0),
            _buildAddTransactionButton(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput(ColorScheme colors) {
    return TextField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Amount',
        labelStyle: TextStyle(color: colors.onSurface),
        prefixIcon: Icon(Icons.attach_money, color: colors.onSurface),
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
      style: TextStyle(color: colors.onSurface, fontSize: 24.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescriptionInput(ColorScheme colors) {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description (Optional)',
        labelStyle: TextStyle(color: colors.onSurface),
        prefixIcon: Icon(Icons.description, color: colors.onSurface),
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildModeDropdown(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TransactionMode>(
          isExpanded: true,
          hint: Text('Select Mode', style: TextStyle(color: colors.onSurfaceVariant),          ),
          value: _selectedMode,
          items: TransactionMode.values.map((mode) {
            return DropdownMenuItem<TransactionMode>(
              value: mode,
              child: Text(mode.name, style: TextStyle(color: colors.onSurface)),
            );
          }).toList(),
          onChanged: (mode) => setState(() => _selectedMode = mode),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TransactionCategory>(
          isExpanded: true,
          hint: Text('Spent on', style: TextStyle(color: colors.onSurfaceVariant)),
          value: _selectedCategory,
          items: TransactionCategory.values.map((category) {
            return DropdownMenuItem<TransactionCategory>(
              value: category,
              child: Text(category.name, style: TextStyle(color: colors.onSurface)),
            );
          }).toList(),
          onChanged: (category) => setState(() => _selectedCategory = category),
        ),
      ),
    );
  }

  Widget _buildAddTransactionButton(ColorScheme colors) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _addTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: colors.onPrimary)
          : Text('Add Expense', style: TextStyle(color: colors.onPrimary, fontSize: 18.0, fontWeight: FontWeight.bold)),
    );
  }
}
