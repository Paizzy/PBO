import 'package:flutter/material.dart';

import 'dashboard.dart'; // biar bisa akses MenuItem

class DetailPage extends StatelessWidget {
  final MenuItem item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.nama)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nama,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text("Harga: Rp ${item.harga}"),
                Text("Stok: ${item.stok}"),
                const SizedBox(height: 12),
                // ini contoh polymorphism: memanggil info()
                Text(
                  "Info Lengkap: ${item.info}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
