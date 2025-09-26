import 'package:flutter/material.dart';

class PesanPage extends StatefulWidget {
  const PesanPage({Key? key}) : super(key: key);

  @override
  State<PesanPage> createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  // Daftar menu makanan
  final List<Map<String, dynamic>> makanan = [
    {"nama": "Nasi Putih", "harga": 5000, "stok": 10},
    {"nama": "Tempe", "harga": 3000, "stok": 20},
    {"nama": "Tahu", "harga": 3000, "stok": 15},
    {"nama": "Ikan Goreng", "harga": 7000, "stok": 8},
  ];

  // Daftar menu minuman
  final List<Map<String, dynamic>> minuman = [
    {"nama": "Es Teh", "harga": 4000, "stok": 12},
    {"nama": "Es Jeruk", "harga": 5000, "stok": 8},
    {"nama": "Air Mineral", "harga": 3000, "stok": 25},
  ];

  // Pesanan user
  final List<Map<String, dynamic>> pesanan = [];
  int totalPenghasilan = 0;

  // Tambah pesanan
  void tambahPesanan(Map<String, dynamic> item) {
    setState(() {
      pesanan.add(item);
      totalPenghasilan += item["harga"] as int;
    });
  }

  // Konfirmasi pesanan
  void konfirmasiPesanan() {
    if (pesanan.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Belum ada pesanan!")));
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Pesanan Berhasil"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...pesanan.map((e) => Text("${e["nama"]} - Rp ${e["harga"]}")),
              const Divider(),
              Text("Total: Rp $totalPenghasilan"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuList(String title, List<Map<String, dynamic>> menu) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final item = menu[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(item["nama"]),
                    subtitle: Text(
                      "Rp ${item["harga"]} | Stok: ${item["stok"]}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Colors.green),
                      onPressed: () => tambahPesanan(item),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesan Menu")),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildMenuList("Makanan", makanan),
                const VerticalDivider(),
                _buildMenuList("Minuman", minuman),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            color: Colors.blueGrey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Total Sementara: Rp $totalPenghasilan",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: konfirmasiPesanan,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Pesan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
