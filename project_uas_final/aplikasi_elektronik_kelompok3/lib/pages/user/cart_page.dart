import 'package:aplikasi_elektronik_kelompok3/models/product_model.dart';
import 'package:aplikasi_elektronik_kelompok3/pages/user/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';

// Define the Cart screen as a StatefulWidget
class Cart extends StatefulWidget {
  const Cart({super.key}); // Constructor with an optional key
  @override
  State<Cart> createState() => _CartState();
  // Create the state for the Cart widget
}

// Define the state class for the Cart widget
class _CartState extends State<Cart> {
  String userId = supabase.auth.currentUser!.id;
  List<pCart> pcart = [];
  Map<int, Product> productMap = {};
  bool isLoading = true;
  List<Map<String, dynamic>> addresses = [];
  int? selectedAddressId;
  int totalPrice = 0;
  bool isPlacingOrder = false;
  int saldo = 0;
  String paymentMethod = 'cash'; // Default payment method

  Future<void> fetchSaldo() async {
    final data = await supabase
        .from('Pelanggan')
        .select('saldo')
        .eq('id', userId)
        .single();

    setState(() {
      saldo = data['saldo'];
    });
  }

  Future<void> fetchProducts() async {
    try {
      final response =
          await supabase.from('cart_items').select().eq('user_id', userId);
      final List data = response;
      setState(() {
        pcart = data.map((item) => pCart.fromMap(item)).toList();
        isLoading = false;
      });
      await fetchProductsDetails();
      calculatePrice();
    } catch (e) {
      print('Error in fetching pCart : $e');
    }
  }

  Future<void> fetchAddress() async {
    try {
      final response = await supabase
          .from('address')
          .select('id, alamat')
          .eq('userId', userId);

      List fetchedAddresses = response as List;

      setState(() {
        addresses = fetchedAddresses
            .map((address) => {
                  'id': address['id'] as int,
                  'alamat': address['alamat'] as String,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching addresses: $e');
    }
  }

  Future<void> fetchProductsDetails() async {
    for (var item in pcart) {
      if (!productMap.containsKey(item.productId)) {
        final product = await getProductById(item.productId);
        productMap[item.productId] = product;
      }
    }
  }

  Future<Product> getProductById(int id) async {
    final response =
        await supabase.from('Produk').select().eq('id', id).single();
    return Product.fromMap(response);
  }

  Future<void> deleteFromCart(int id) async {
    await supabase.from('cart_items').delete().eq('id', id);
    setState(() {
      fetchProducts();
      calculatePrice();
    });
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      pcart[index].isSelected = !pcart[index].isSelected;
      calculatePrice();
    });
  }

  void showSelectedItem() {
    List<pCart> selectedItems = pcart.where((item) => item.isSelected).toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada item yang dipilih untuk pembelian.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      DropdownButton<int>(
                        hint: Text('Select Address'),
                        value: selectedAddressId,
                        items: addresses.map<DropdownMenuItem<int>>(
                            (Map<String, dynamic> address) {
                          return DropdownMenuItem<int>(
                            value: address['id'],
                            child: Text(address['alamat']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setModalState(() {
                            selectedAddressId = newValue;
                          });
                          print('Selected Address ID: $selectedAddressId');
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButton<String>(
                        hint: Text('Select Payment Method'),
                        value: paymentMethod,
                        items: ['cash', 'credit'].map((String method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Text(method == 'cash' ? 'Cash' : 'Credit'),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setModalState(() {
                            paymentMethod = newValue!;
                          });
                          print('Selected Payment Method: $paymentMethod');
                        },
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: selectedItems.length,
                          itemBuilder: (context, index) {
                            final item = selectedItems[index];
                            final product = productMap[item.productId];

                            if (product == null) return SizedBox.shrink();

                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    product.imageUrl,
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${product.name} x${item.qty}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Rp ${(item.qty * product.price).toStringAsFixed(0)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isPlacingOrder
                            ? null
                            : () async {
                                await placeOrder(selectedItems);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF56C26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: isPlacingOrder
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  'Confirm Purchase',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchAddress();
    fetchSaldo();
  }

  void calculatePrice() {
    int total = 0;
    for (var item in pcart) {
      if (item.isSelected && productMap.containsKey(item.productId)) {
        total += item.qty * productMap[item.productId]!.price;
      }
    }
    setState(() {
      totalPrice = total;
    });
  }

  void updateQuantityLocally(int index, int newQty) {
    setState(() {
      pcart[index].qty = newQty;
      calculatePrice();
    });
  }

  Future<void> increaseQuantity(int index) async {
    int newQty = pcart[index].qty + 1;
    final product = productMap[pcart[index].productId];

    // Mengecek apakah kuantitas yang diinginkan melebihi stok
    if (product != null && newQty <= product.stok) {
      updateQuantityLocally(index, newQty);
      await supabase
          .from('cart_items')
          .update({'qty': newQty}).eq('id', pcart[index].pcartId);

      calculatePrice();
    } else {
      // Menampilkan Toast/Notifikasi bahwa stok tidak cukup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok tidak cukup untuk menambah kuantitas'),
          duration: Duration(seconds: 2), // Menentukan durasi toast
        ),
      );
    }
  }

  Future<void> decreaseQuantity(int index) async {
    int newQty = pcart[index].qty - 1;
    if (newQty <= 0) {
      await deleteFromCart(pcart[index].pcartId);
    } else {
      updateQuantityLocally(index, newQty);

      await supabase
          .from('cart_items')
          .update({'qty': newQty}).eq('id', pcart[index].pcartId);
    }

    calculatePrice();
  }

  Future<void> placeOrder(List<pCart> selectedItems) async {
    if (selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon pilih alamat sebelum memesan.')),
      );
      return;
    }

    // Hanya lakukan pengecekan saldo jika metode pembayaran "Credit"
    if (paymentMethod == 'credit' && saldo < totalPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saldo tidak cukup untuk melakukan pembelian.')),
      );
      return;
    }

    setState(() {
      isPlacingOrder = true;
    });

    try {
      // Insert ke tabel 'orders' dan ambil data yang diinsert
      final orderResponse = await supabase.from('orders').insert({
        'user_id': userId,
        'total_amount': totalPrice,
        'status': 'processing',
        'shipping_address_id': selectedAddressId,
        'payment_method': paymentMethod, // Simpan metode pembayaran
      }).select();

      if (orderResponse == null || orderResponse.isEmpty) {
        throw Exception('Gagal membuat order.');
      }

      final orderId = orderResponse[0]['id'] as int;
      print('Order berhasil dibuat dengan ID: $orderId');

      // Persiapkan data untuk 'order_items'
      List<Map<String, dynamic>> orderItems = selectedItems.map((item) {
        return {
          'order_id': orderId,
          'qty': item.qty,
          'product_id': item.productId,
        };
      }).toList();

      // Insert ke tabel 'order_items'
      final orderItemsResponse =
          await supabase.from('order_items').insert(orderItems).select();

      if (orderItemsResponse == null || orderItemsResponse.isEmpty) {
        throw Exception('Gagal menambahkan item ke order.');
      }

      // Perbarui stok di tabel Produk
      for (var item in selectedItems) {
        final product = productMap[item.productId];
        if (product != null) {
          int newStock = product.stok - item.qty;

          // Update the product stock in the database
          await supabase
              .from('Produk')
              .update({'stok': newStock}).eq('id', item.productId);
        }
      }

      // Hapus hanya item yang dipilih dari 'cart_items'
      List<int> selectedCartIds =
          selectedItems.map((item) => item.pcartId).toList();
      String orCondition = selectedCartIds.map((id) => 'id.eq.$id').join(',');
      await supabase.from('cart_items').delete().or(orCondition);

      print('Item cart berhasil dihapus.');

      // Perbarui saldo jika menggunakan metode "Credit"
      if (paymentMethod == 'credit') {
        int newSaldo = saldo - totalPrice;
        await supabase
            .from('Pelanggan')
            .update({'saldo': newSaldo}).eq('id', userId);
      }

      setState(() {
        pcart.removeWhere((item) => selectedCartIds.contains(item.pcartId));
        calculatePrice();
        fetchSaldo();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase Successful!')),
      );

      Navigator.pop(context); // Tutup bottom sheet
    } catch (e) {
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error placing order.')),
      );
    } finally {
      setState(() {
        isPlacingOrder = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFFFBEF),
            )),
        backgroundColor: const Color(0xFF4A148C),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: pcart.length,
                    itemBuilder: (context, index) {
                      final item = pcart[index];
                      final product = productMap[item.productId];

                      if (product == null) return SizedBox.shrink();

                      return CartTile(
                        productCart: product.name,
                        priceCart: product.price,
                        imageAssets: product.imageUrl,
                        quantity: item.qty,
                        itemSelected: item.isSelected,
                        selectItem: (value) => checkBoxChanged(value, index),
                        deleteFunction: (context) =>
                            deleteFromCart(item.pcartId),
                        increaseQuantity: (context) => increaseQuantity(index),
                        decreaseQuantity: (context) => decreaseQuantity(index),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF4A148C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total Price : \n' + formatCurrency(totalPrice),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            'Credit : ${formatCurrency(saldo)}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          showSelectedItem();
                        },
                        icon: Icon(Icons.shopping_cart_checkout),
                        label: Text("Proceed to Checkout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

String formatCurrency(int price) {
  return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]}.')}';
}
