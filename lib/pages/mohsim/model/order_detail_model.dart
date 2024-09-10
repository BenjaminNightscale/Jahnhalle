import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail {
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deliveredAt;
  final int? orderId;
  final String? paymentMethod;
  final String? orderStatus;
  final List<Item>? items;
  final Table? table;
  final String? status;

  OrderDetail({
    this.createdAt,
    this.updatedAt,
    this.deliveredAt,
    this.orderId,
    this.paymentMethod,
    this.orderStatus,
    this.items,
    this.table,
    this.status,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        deliveredAt: json['deliveredAt'],
        orderId: json["orderId"],
        paymentMethod: json["paymentMethod"],
        orderStatus: json["orderStatus"],
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        table: json["table"] == null ? null : Table.fromJson(json["table"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deliveredAt": deliveredAt,
        "orderId": orderId,
        "paymentMethod": paymentMethod,
        "orderStatus": orderStatus,
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "table": table?.toJson(),
        "status": status,
      };
}

class Item {
  final int? quantity;
  final double? price;
  final String? imageUrl;
  final String? name;
  final List<String>? ingredients;
  final String? id;
  final String? category;

  Item({
    this.quantity,
    this.price,
    this.imageUrl,
    this.name,
    this.ingredients,
    this.id,
    this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        imageUrl: json["imageUrl"],
        name: json["name"],
        ingredients: json["ingredients"] == null
            ? []
            : List<String>.from(json["ingredients"]!.map((x) => x)),
        id: json["id"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "price": price,
        "imageUrl": imageUrl,
        "name": name,
        "ingredients": ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x)),
        "id": id,
        "category": category,
      };
}

class Table {
  final String? tableNumber;
  final String? capacity;

  Table({
    this.tableNumber,
    this.capacity,
  });

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        tableNumber: json["tableNumber"],
        capacity: json["capacity"],
      );

  Map<String, dynamic> toJson() => {
        "tableNumber": tableNumber,
        "capacity": capacity,
      };
}
