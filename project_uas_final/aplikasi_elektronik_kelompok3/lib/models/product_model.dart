class Product {
  // Define a class to represent a product
  final int id; // Use int to match the Supabase table definition
  final String name;
  final String description;
  final int price;
  final int stok;
  final String
      imageUrl; // Change this to match the imageUrl column in your table
  final String? category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stok,
    required this.imageUrl,
    required this.category,
  });

  // Factory method to create a Product from a map (Supabase response)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int, // Use int for id
      name: map['nama'] as String,
      description: map['desc'] as String, // Match 'desc' column
      price: map['harga']
          as int, // Convert price to double if it's stored as a string
      stok: map['stok'] as int, // Match 'stok' column
      imageUrl: map['ImageUrl'] as String, // Match 'imageUrl' column
      category: map['category'] as String,
    );
  }

  // Convert a Product instance to a map (for sending data to Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id if needed for updates
      'name': name,
      'desc': description, // Match 'desc' column
      'price': price, // Convert price to string for consistency with your table
      'stok': stok,
      'imageUrl': imageUrl, // Match 'imageUrl' column
      'category': category, // Save enum as string
    };
  }
}

class pCart {
  final int pcartId;
  int qty;
  final int productId;
  bool isSelected = false;

  pCart({required this.pcartId, required this.qty, required this.productId});

  factory pCart.fromMap(Map<String, dynamic> map) {
    return pCart(
        pcartId: map['id'] as int,
        qty: map['qty'] as int,
        productId: map['product_id'] as int);
  }

  Map<String, dynamic> toMap() {
    return {'pcartId': pcartId, 'qty': qty, 'productId': productId};
  }
}

class historySaldo {
  final int saldoTerpakai;
  final String date;

  historySaldo({required this.saldoTerpakai, required this.date});

  factory historySaldo.fromMap(Map<String, dynamic> map) {
    return historySaldo(
      saldoTerpakai: map['total_amount'] as int,
      date: map['ordered_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'saldoTerpakai': saldoTerpakai,
      'qty': date,
    };
  }
}
