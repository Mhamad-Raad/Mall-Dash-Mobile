/// Driver order data models matching backend API structure
class DriverOrder {
  final int id;
  final String orderNumber;
  final int? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? deliveryAddress;
  final String? buildingName;
  final String? floorNumber;
  final String? apartmentNumber;
  final int status;
  final String statusName;
  final double? totalAmount;
  final DateTime? createdAt;
  final DateTime? deliveryTime;
  final List<OrderItem>? items;
  final int? assignmentId;
  final bool? isAssigned;

  DriverOrder({
    required this.id,
    required this.orderNumber,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.deliveryAddress,
    this.buildingName,
    this.floorNumber,
    this.apartmentNumber,
    required this.status,
    required this.statusName,
    this.totalAmount,
    this.createdAt,
    this.deliveryTime,
    this.items,
    this.assignmentId,
    this.isAssigned,
  });

  factory DriverOrder.fromJson(Map<String, dynamic> json) {
    return DriverOrder(
      id: json['id'] ?? json['orderId'] ?? 0,
      orderNumber: json['orderNumber']?.toString() ?? '',
      customerId: json['customerId'] ?? json['userId'],
      customerName: json['customerName'] ?? json['userName'],
      customerPhone: json['customerPhone'] ?? json['phoneNumber'],
      deliveryAddress: json['deliveryAddress'] ?? json['address'],
      buildingName: json['buildingName'],
      floorNumber: json['floorNumber']?.toString(),
      apartmentNumber:
          json['apartmentNumber']?.toString() ??
          json['apartmentName']?.toString(),
      status: json['status'] ?? 0,
      statusName: _getStatusName(json['status'] ?? 0),
      totalAmount: (json['totalAmount'] ?? json['total'])?.toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      deliveryTime: json['deliveryTime'] != null
          ? DateTime.tryParse(json['deliveryTime'].toString())
          : null,
      items: json['items'] != null
          ? (json['items'] as List)
                .map((item) => OrderItem.fromJson(item))
                .toList()
          : null,
      assignmentId: json['assignmentId'],
      isAssigned: json['isAssigned'] ?? json['assigned'],
    );
  }

  static String _getStatusName(int status) {
    switch (status) {
      case 1:
        return 'Pending';
      case 2:
        return 'Confirmed';
      case 3:
        return 'Preparing';
      case 4:
        return 'Ready for Pickup';
      case 5:
        return 'Assigned to Driver';
      case 6:
        return 'Picked Up';
      case 7:
        return 'In Transit';
      case 8:
        return 'Delivered';
      case 9:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'buildingName': buildingName,
      'floorNumber': floorNumber,
      'apartmentNumber': apartmentNumber,
      'status': status,
      'statusName': statusName,
      'totalAmount': totalAmount,
      'createdAt': createdAt?.toIso8601String(),
      'deliveryTime': deliveryTime?.toIso8601String(),
      'items': items?.map((item) => item.toJson()).toList(),
      'assignmentId': assignmentId,
      'isAssigned': isAssigned,
    };
  }
}

/// Order item model
class OrderItem {
  final int id;
  final String productName;
  final int quantity;
  final double price;
  final String? imageUrl;

  OrderItem({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? json['productId'] ?? 0,
      productName: json['productName'] ?? json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? json['unitPrice'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}

/// Order assignment request model
class OrderAssignmentRequest {
  final int assignmentId;

  OrderAssignmentRequest({required this.assignmentId});

  Map<String, dynamic> toJson() {
    return {'assignmentId': assignmentId};
  }
}

/// Update order status request model
class UpdateOrderStatusRequest {
  final int status;

  UpdateOrderStatusRequest({required this.status});

  Map<String, dynamic> toJson() {
    return {'status': status};
  }
}

/// Delivery status enum matching backend values
enum DeliveryStatus {
  pending(1),
  confirmed(2),
  preparing(3),
  readyForPickup(4),
  assignedToDriver(5),
  pickedUp(6),
  inTransit(7),
  delivered(8),
  cancelled(9);

  final int value;
  const DeliveryStatus(this.value);

  static DeliveryStatus fromValue(int value) {
    return DeliveryStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => DeliveryStatus.pending,
    );
  }

  String get displayName {
    switch (this) {
      case DeliveryStatus.pending:
        return 'Pending';
      case DeliveryStatus.confirmed:
        return 'Confirmed';
      case DeliveryStatus.preparing:
        return 'Preparing';
      case DeliveryStatus.readyForPickup:
        return 'Ready for Pickup';
      case DeliveryStatus.assignedToDriver:
        return 'Assigned to Driver';
      case DeliveryStatus.pickedUp:
        return 'Picked Up';
      case DeliveryStatus.inTransit:
        return 'In Transit';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.cancelled:
        return 'Cancelled';
    }
  }
}
