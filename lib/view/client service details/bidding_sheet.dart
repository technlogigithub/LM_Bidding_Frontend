import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';

class BidBottomSheet extends StatefulWidget {
  const BidBottomSheet({super.key});

  @override
  State<BidBottomSheet> createState() => _BidBottomSheetState();
}

class _BidBottomSheetState extends State<BidBottomSheet> {
  final TextEditingController bidController = TextEditingController();
  int quantity = 1; // default qty
  Duration remaining = const Duration(minutes: 10); // 10 min countdown
  Timer? timer;

  // Example data
  int currentBid = 12000;
  int minIncrement = 500;

  @override
  void initState() {
    super.initState();
    bidController.text = (currentBid + minIncrement).toString();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remaining.inSeconds > 0) {
        setState(() {
          remaining = Duration(seconds: remaining.inSeconds - 1);
        });
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    bidController.dispose();
    super.dispose();
  }

  String formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  void increaseBid() {
    int currentValue = int.tryParse(bidController.text) ?? currentBid;
    currentValue += minIncrement;
    bidController.text = currentValue.toString();
    setState(() {});
  }

  void decreaseBid() {
    int currentValue = int.tryParse(bidController.text) ?? currentBid;
    if (currentValue - minIncrement >= currentBid) {
      currentValue -= minIncrement;
      bidController.text = currentValue.toString();
      setState(() {});
    }
  }

  Widget buildCounterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 26, color: AppColors.appColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grab handle
          Container(
            height: 5,
            width: 50,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Title & countdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Place Your Bid",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "⏱ ${formatTime(remaining)}",
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Enter your bid amount for this project. Make sure it is above the current highest bid.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
          ),
          const SizedBox(height: 20),

          // Info card
          Card(
            color: Colors.grey[100],
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Current Highest Bid",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text("₹ $currentBid",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.appColor)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Min Increment",
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text("₹ $minIncrement",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Bid amount input with +/- buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCounterButton(Icons.remove, decreaseBid),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Center(
                          child: TextField(
                            controller: bidController,
                            readOnly: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.appColor),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      buildCounterButton(Icons.add, increaseBid),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCounterButton(Icons.remove, () {
                        if (quantity > 1) setState(() => quantity--);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "$quantity",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      buildCounterButton(Icons.add, () {
                        setState(() => quantity++);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: AppColors.appColor,
                elevation: 4,
              ),
              onPressed: () {
                final bidAmount = bidController.text.trim();
                if (bidAmount.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a bid amount")),
                  );
                  return;
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Your bid of ₹$bidAmount x $quantity has been placed!"),
                  ),
                );
              },
              child: Text(
                "Submit Bid",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.appWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
