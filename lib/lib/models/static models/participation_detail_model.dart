class ParticipationDetailModel {
  final String orderId;
  final String sellerName;
  final String orderDate;
  final String title;
  final String serviceInfo;
  final String duration;
  final String amount;
  final String status;
  final Duration countdownDuration;

  // Order Details
  final String revisions;
  final String fileTypes;
  final String resolution;
  final String package;

  // Order Summary
  final String subtotal;
  final String serviceFee;
  final String total;
  final String deliveryDate;

  // Delivery Section
  final String deliveryFileName;
  final String deliveryFileSubtitle;
  final String deliveryImagePath;
  final bool showDeliverySection;

  ParticipationDetailModel({
    required this.orderId,
    required this.sellerName,
    required this.orderDate,
    required this.title,
    required this.serviceInfo,
    required this.duration,
    required this.amount,
    required this.status,
    required this.countdownDuration,
    required this.revisions,
    required this.fileTypes,
    required this.resolution,
    required this.package,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
    required this.deliveryDate,
    required this.deliveryFileName,
    required this.deliveryFileSubtitle,
    required this.deliveryImagePath,
    required this.showDeliverySection,
  });
}