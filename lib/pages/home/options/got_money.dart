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
        type: 'Income',
        amount: amount,
        description: description.isEmpty ? null : description,
        date: DateTime.now(),
        mode: _selectedMode!.name,
        category: TransactionCategory.Savings.name, // Category is now set to Savings by default
      );

      await transactionProvider.addTransaction(txn);

      final newAmount = (user.amount ?? 0) + amount;
      await userProvider.updateAmount(newAmount);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Income added successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add income: ${e.toString()}')),
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
        title: Text('Got Money', style: TextStyle(color: colors.onPrimary)),
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
          hint: Text('Select Mode', style: TextStyle(color: colors.onSurfaceVariant)),
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
