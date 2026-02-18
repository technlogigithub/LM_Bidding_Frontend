import '../Post/Get_Post_List_Model.dart';

class ParticipationOrder {
  final String orderId;
  final String sellerName;
  final String orderDate;
  final String title;
  final String duration;
  final String amount;
  final String status;
  final Duration countdownDuration;
  final Map<String, dynamic>? postBodyData; // Store dynamic post_body fields
  final List<Media>? mediaList; // Store media (images/videos)

  ParticipationOrder({
    required this.orderId,
    required this.sellerName,
    required this.orderDate,
    required this.title,
    required this.duration,
    required this.amount,
    required this.status,
    required this.countdownDuration,
    this.postBodyData,
    this.mediaList,
  });
}