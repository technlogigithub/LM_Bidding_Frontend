class OnlinePaymentGetDetailsResponseModel {
  int? responseCode;
  bool? success;
  String? message;
  Result? result;

  OnlinePaymentGetDetailsResponseModel(
      {this.responseCode, this.success, this.message, this.result});

  OnlinePaymentGetDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    success = json['success'];
    message = json['message'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  int? totalAmount;
  String? userName;
  String? description;
  String? emailId;
  String? contactNumber;
  String? pgKey; // Razorpay key returned by backend

  Result(
      {this.totalAmount,
        this.userName,
        this.description,
        this.emailId,
        this.contactNumber,
        this.pgKey});

  Result.fromJson(Map<String, dynamic> json) {
    totalAmount = json['total_amount'];
    userName = json['user_name'];
    description = json['description'];
    emailId = json['email_id'];
    contactNumber = json['contact_number'];
    pgKey = json['pg_key']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_amount'] = this.totalAmount;
    data['user_name'] = this.userName;
    data['description'] = this.description;
    data['email_id'] = this.emailId;
    data['contact_number'] = this.contactNumber;
    data['pg_key'] = this.pgKey;
    return data;
  }
}
