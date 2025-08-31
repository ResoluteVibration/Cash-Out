import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/enums.dart';
import '../../../../models/transaction.dart';
import '../../../../providers/user_provider.dart';
import '../../../../providers/transaction_provider.dart';

class GotMoneyPage extends StatefulWidget {
  const GotMoneyPage({super.key});

  @override
  State<GotMoneyPage> createState() => _GotMoneyPageState();
}

class _GotMoneyPageState extends State<GotMoneyPage> {
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

    if (user == null || amount <= 0 || _selectedMode == null) {
      if (mounted) {
        _showCustomSnackBar('Please fill out all required fields and login.', isSuccess: false);
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final txn = TransactionModel(
        id: '', // Firestore will generate
        userId: user.id,
        type: TransactionType.Income.name,
        amount: amount,
        description: description.isEmpty ? null : description,
        date: DateTime.now(),
        mode: _selectedMode!.name,
        category: _selectedCategory?.name ?? 'General',
      );

      await transactionProvider.addTransaction(txn);
      await userProvider.updateBalance(amount, TransactionType.Income.name);

      if (mounted) {
        Navigator.of(context).pop();
        _showCustomSnackBar('Income added successfully!', isSuccess: true);
      }
    } catch (e) {
      if (mounted) {
        _showCustomSnackBar('Failed to add income: ${e.toString()}', isSuccess: false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showCustomSnackBar(String message, {required bool isSuccess}) {
    final colors = Theme.of(context).colorScheme;
    final backgroundColor = isSuccess ? colors.primaryContainer : colors.errorContainer;
    final textColor = isSuccess ? colors.onPrimaryContainer : colors.onErrorContainer;
    final icon = isSuccess ? Icons.check_circle_outline : Icons.error_outline;
    final iconColor = isSuccess ? colors.onPrimaryContainer : colors.onErrorContainer;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final colors = userProvider.currentTheme.colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: Text('Got Money', style: TextStyle(color: colors.onPrimary)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountInput(colors),
            const SizedBox(height: 16.0),
            _buildDescriptionInput(colors),
            const SizedBox(height: 16.0),
            _buildCategoryDropdown(colors),
            const SizedBox(height: 16.0),
            _buildModeDropdown(colors),
            const SizedBox(height: 24.0),
            _buildAddTransactionButton(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput(ColorScheme colors) {
    return TextFormField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Amount',
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        prefixIcon: Icon(Icons.currency_rupee, color: colors.onSurface),
        filled: true,
        fillColor: colors.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDescriptionInput(ColorScheme colors) {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description (Optional)',
        labelStyle: TextStyle(color: colors.onSurfaceVariant),
        prefixIcon: Icon(Icons.description, color: colors.onSurface),
        filled: true,
        fillColor: colors.surfaceVariant.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
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
          hint: Row(
            children: [
              Icon(Icons.category, color: colors.onSurface),
              const SizedBox(width: 8),
              Text('Select Category', style: TextStyle(color: colors.onSurfaceVariant)),
            ],
          ),
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
          hint: Row(
            children: [
              Icon(Icons.payment, color: colors.onSurface),
              const SizedBox(width: 8),
              Text('Select Mode', style: TextStyle(color: colors.onSurfaceVariant)),
            ],
          ),
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
          : Text('Add Income', style: TextStyle(color: colors.onPrimary, fontSize: 18.0, fontWeight: FontWeight.bold)),
    );
  }
}
