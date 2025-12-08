import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/app_color.dart';
import '../../models/static models/transaction_data.dart';
import '../../widget/form_widgets/custom_date_time.dart';

class TransactionController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var transactions = <TransactionData>[].obs;


  @override
  void onInit() {
    loadStaticData();
    super.onInit();
  }

  void loadStaticData() {
    transactions.assignAll([
      TransactionData(name: 'Marvin McKinney', date: '10 Jun 2023', amount: 5000, isDeposit: true),
      TransactionData(name: 'Leslie Alexander', date: '09 Jun 2023', amount: 2500, isDeposit: false),
      TransactionData(name: 'Guy Hawkins', date: '08 Jun 2023', amount: 12000, isDeposit: true),
      TransactionData(name: 'Marvin McKinney', date: '10 Jun 2023', amount: 5000, isDeposit: true),
      TransactionData(name: 'Leslie Alexander', date: '09 Jun 2023', amount: 2500, isDeposit: false),
      TransactionData(name: 'Guy Hawkins', date: '08 Jun 2023', amount: 12000, isDeposit: true),
      TransactionData(name: 'Marvin McKinney', date: '10 Jun 2023', amount: 5000, isDeposit: true),
      TransactionData(name: 'Leslie Alexander', date: '09 Jun 2023', amount: 2500, isDeposit: false),
      TransactionData(name: 'Guy Hawkins', date: '08 Jun 2023', amount: 12000, isDeposit: true),
    ]);
  }

  String get formattedDate => DateFormat('d/M/yyyy').format(selectedDate.value);

  /// Public method – pick a date and filter (placeholder)
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      builder: (context, child) => themedPicker(context, child!),
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;

      // ✅ Call your filter API / logic here
      // filterTransactionsByDate(picked);
    }
  }
  void updateDate(DateTime date) {
    selectedDate.value = date;
    // loadTransactionsByDate(date); // if you filter API/local list
  }

}