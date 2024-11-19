class PaymentModel {
  int? amount;
  String? currency;
  Source? source;
  String? successUrl;
  String? failureUrl;
  String? reference;
  String? capture;
  Customer? customer;
  String? processingChannelId;

  PaymentModel(
      {this.amount,
        this.currency,
        this.source,
        this.successUrl,
        this.failureUrl,
        this.reference,
        this.capture,
        this.customer,
        this.processingChannelId});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
    source =
    json['source'] != null ? Source.fromJson(json['source']) : null;
    successUrl = json['success_url'];
    failureUrl = json['failure_url'];
    reference = json['reference'];
    capture = json['capture'];
    customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    processingChannelId = json['processing_channel_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    if (source != null) {
      data['source'] = source!.toJson();
    }
    data['success_url'] = successUrl;
    data['failure_url'] = failureUrl;
    data['reference'] = reference;
    data['capture'] = capture;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['processing_channel_id'] = processingChannelId;
    return data;
  }
}

class Source {
  String? type;

  Source({this.type});

  Source.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    return data;
  }
}

class Customer {
  String? email;
  String? name;
  Phone? phone;

  Customer({this.email, this.name, this.phone});

  Customer.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'] != null ? Phone.fromJson(json['phone']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    if (phone != null) {
      data['phone'] = phone!.toJson();
    }
    return data;
  }
}

class Phone {
  String? countryCode;
  String? number;

  Phone({this.countryCode, this.number});

  Phone.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['number'] = number;
    return data;
  }
}
