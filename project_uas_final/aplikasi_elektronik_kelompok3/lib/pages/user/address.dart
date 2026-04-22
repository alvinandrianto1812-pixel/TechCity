import 'package:flutter/material.dart';
import 'package:aplikasi_elektronik_kelompok3/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String userId = supabase.auth.currentUser!.id;
  List<Map<String, dynamic>> addresses = [];

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

  // Function to show dialog for adding new address
  Future<void> _showAddAddressDialog() async {
    TextEditingController addressController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Address'),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(hintText: "Enter new address"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                // Add logic to save the address to the database
                _addAddress(addressController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to add address to the list (you can modify it to save to database)
  Future<void> _addAddress(String newAddress) async {
    // Logic for adding the new address (for example, inserting into Supabase)
    try {
      await supabase.from('address').insert({
        'userId': userId,
        'alamat': newAddress,
      });

      fetchAddress(); // Fetch the addresses again to refresh the list
    } catch (e) {
      print('Error adding address: $e');
    }
  }

  Future<void> deleteAddress(int id) async {
    await supabase.from('address').delete().eq('id', id);
    fetchAddress();
  }

  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Addresses",
          style: TextStyle(
              color: const Color(0xFFFFFBEF), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddAddressDialog, // Show dialog on button press
              color: Colors.white),
        ],
        centerTitle: true,
        backgroundColor: const Color(0xFF4A148C),
      ),
      body: addresses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Slidable(
                    endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: StretchMotion(), // Motion effect for sliding
                      children: [
                        SlidableAction(
                          onPressed: (context) => deleteAddress(addresses[index]
                              ['id']), // Call the delete function when pressed
                          icon: Icons.delete, // delete icon
                          backgroundColor:
                              Colors.red.shade400, // Red background
                          foregroundColor: Colors.white, // White icon color
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        )
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(
                                255, 86, 41, 141), // Warna utama
                            const Color(
                                0xFF9C4DFF), // Gradasi warna ungu yang lebih muda
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF703030).withOpacity(0.3),
                            spreadRadius: 2, // How much the shadow spreads
                            blurRadius: 7, // Blur radius for the shadow
                            offset: Offset(
                                0, 3), // Changes the position of the shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            addresses[index]['alamat'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
