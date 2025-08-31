// lib/models/enums.dart

/// Enum for transaction types (income/expense)
enum TransactionType {
  Income,
  Expense,
}

/// Enum for transaction modes (e.g., cash, card, UPI, etc.)
enum TransactionMode {
  Cash,
  Card,
  Upi,
  BankTransfer,
  Cheque,
}

/// Enum for transaction categories (customizable)
enum TransactionCategory {
  Food,
  Travel,
  Shopping,
  Bills,
  Entertainment,
  Health,
  Education,
  Savings,
  Investments,
  Other,
}

/// Enum for contact types
enum ContactType {
  Lent,
  Taken,
}
