import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartTile extends StatelessWidget {
  final String productCart;
  final int priceCart;
  final String imageAssets;
  final int quantity;
  final bool itemSelected;
  Function(bool?)? selectItem;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? increaseQuantity;
  final Function(BuildContext)? decreaseQuantity;

  CartTile({
    super.key,
    required this.productCart,
    required this.priceCart,
    required this.imageAssets,
    required this.quantity,
    required this.itemSelected,
    required this.selectItem,
    required this.deleteFunction,
    required this.increaseQuantity,
    required this.decreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4A148C), // Warna utama yang lebih gelap
                Color(0xFF9C27B0), // Warna pelengkap ungu yang lebih cerah
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF9C27B0).withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox dengan warna hijau saat aktif
              Checkbox(
                value: itemSelected,
                onChanged: selectItem,
                activeColor: Colors.green,
                checkColor: Colors.white,
                side: BorderSide(
                  color: itemSelected
                      ? Colors.transparent
                      : Colors.green, // Outline putih jika belum dicentang
                  width: 2.0, // Ukuran garis outline
                ),
              ),
              // Gambar produk dengan border melingkar
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageAssets,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productCart,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 10),
                    Text(
                      formatCurrency(priceCart),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      decreaseQuantity?.call(context);
                    },
                    color: Colors.red,
                  ),
                  Text(
                    quantity.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      increaseQuantity?.call(context);
                    },
                    color: Colors.green,
                  ),
                ],
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     // Tombol untuk menambah jumlah
              //     Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.8),
              //         shape: BoxShape.circle,
              //       ),
              //       child: IconButton(
              //         onPressed: () {
              //           increaseQuantity?.call(context);
              //         },
              //         icon: Icon(
              //           Icons.add,
              //           color: Color(0xFF4A148C),
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: 5),
              //     // Menampilkan jumlah produk
              //     Container(
              //       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.6),
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //       child: Text(
              //         quantity.toString(),
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: 5),
              //     // Tombol untuk mengurangi jumlah
              //     Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.8),
              //         shape: BoxShape.circle,
              //       ),
              //       child: IconButton(
              //         onPressed: () {
              //           decreaseQuantity?.call(context);
              //         },
              //         icon: Icon(
              //           Icons.remove,
              //           color: Color(0xFF4A148C),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatCurrency(int price) {
  return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (Match m) => '${m[1]}.')}';
}
