import 'package:flutter/material.dart';
import 'login_page.dart';

class MenuItem {
  final String nama;
  final int harga;
  int stok;

  MenuItem({required this.nama, required this.harga, required this.stok});

  // Encapsulasi dengan method copy
  MenuItem copy() => MenuItem(nama: nama, harga: harga, stok: stok);

  // Polymorphism (akan dioverride di subclass)
  String get info => "$nama - Rp$harga (Stok: $stok)";
}

/// Subclass untuk contoh Inheritance
class FoodItem extends MenuItem {
  FoodItem({required String nama, required int harga, required int stok})
    : super(nama: nama, harga: harga, stok: stok);

  @override
  String get info => "Makanan: $nama - Rp$harga (Stok: $stok)";
}

class DrinkItem extends MenuItem {
  DrinkItem({required String nama, required int harga, required int stok})
    : super(nama: nama, harga: harga, stok: stok);

  @override
  String get info => "Minuman: $nama - Rp$harga (Stok: $stok)";
}

/// ===================== DASHBOARD =====================
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // initial (mutable) menu lists
  final List<MenuItem> makananList = [
    MenuItem(nama: 'Nasi Putih', harga: 5000, stok: 20),
    MenuItem(nama: 'Tempe Goreng', harga: 3000, stok: 20),
    MenuItem(nama: 'Tahu Goreng', harga: 3000, stok: 20),
    MenuItem(nama: 'Ikan Goreng', harga: 7000, stok: 15),
    MenuItem(nama: 'Ayam Goreng', harga: 8000, stok: 10),
    MenuItem(nama: 'Sayur Asem', harga: 2000, stok: 10),
    MenuItem(nama: 'Telur Dadar', harga: 2000, stok: 15),
    MenuItem(nama: 'Bakwan Jagung', harga: 2000, stok: 10),
    MenuItem(nama: 'Perkedel', harga: 2000, stok: 15),
    MenuItem(nama: 'Tumis Kangkung', harga: 3000, stok: 10),
    MenuItem(nama: 'Pepes Ikan', harga: 8000, stok: 15),
    MenuItem(nama: 'Semur Jengkol', harga: 5000, stok: 20),
    MenuItem(nama: 'Sayur Lodeh', harga: 3000, stok: 10),
  ];

  final List<MenuItem> minumanList = [
    MenuItem(nama: 'Es Teh', harga: 4000, stok: 10),
    MenuItem(nama: 'Teh Hangat', harga: 3000, stok: 10),
    MenuItem(nama: 'Es Jeruk', harga: 5000, stok: 10),
    MenuItem(nama: 'Jeruk Hangat', harga: 4000, stok: 10),
    MenuItem(nama: 'Es Kopyor', harga: 5000, stok: 15),
    MenuItem(nama: 'Es Campur', harga: 10000, stok: 10),
    MenuItem(nama: 'Wedang Jahe', harga: 8000, stok: 10),
    MenuItem(nama: 'Soda Gembira', harga: 8000, stok: 15),
    MenuItem(nama: 'Air Mineral', harga: 3000, stok: 15),
  ];

  // riwayat: setiap elemen = 1 transaksi (List<MenuItem>)
  final List<List<MenuItem>> riwayatPesanan = [];

  // helper: total semua transaksi
  int get totalPenghasilan {
    return riwayatPesanan.fold<int>(
      0,
      (sum, trx) => sum + trx.fold<int>(0, (s, it) => s + it.harga),
    );
  }

  /// ---------- DYNAMIC MENU: show dialog dan add ----------
  Future<void> _showAddMenuDialog() async {
    String category = 'Makanan';
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();
    final TextEditingController stokCtrl = TextEditingController(text: '1');

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Tambah Menu Baru'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // category dropdown
              Row(
                children: [
                  const Text('Kategori: '),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: category,
                    items: const [
                      DropdownMenuItem(
                        value: 'Makanan',
                        child: Text('Makanan'),
                      ),
                      DropdownMenuItem(
                        value: 'Minuman',
                        child: Text('Minuman'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) category = v;
                      // can't call setState inside dialog builder here; field is local
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama menu'),
              ),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Harga (angka)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stokCtrl,
                decoration: const InputDecoration(labelText: 'Stok (angka)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );

    // if user confirmed, validate and add
    if (result == true) {
      final name = nameCtrl.text.trim();
      final price = int.tryParse(priceCtrl.text.trim());
      final stok = int.tryParse(stokCtrl.text.trim()) ?? 1;
      if (name.isEmpty || price == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama atau harga tidak valid')),
        );
        return;
      }

      setState(() {
        final newItem = MenuItem(nama: name, harga: price, stok: stok);
        if (category == 'Makanan') {
          makananList.add(newItem);
        } else {
          minumanList.add(newItem);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu berhasil ditambahkan')),
      );
    }
  }

  /// ---------- Open Pesan page and receive List<MenuItem> ----------
  Future<void> _openPesanPage() async {
    final List<MenuItem>? hasil = await Navigator.push<List<MenuItem>>(
      context,
      MaterialPageRoute(
        builder: (_) => PesanPage(
          makanan: makananList.map((e) => e.copy()).toList(),
          minuman: minumanList.map((e) => e.copy()).toList(),
        ),
      ),
    );

    // safe handling: jika ada hasil (list item), tambahkan sebagai satu transaksi
    if (hasil != null && hasil.isNotEmpty) {
      setState(() {
        // add as one transaction (list)
        riwayatPesanan.add(List<MenuItem>.from(hasil));
      });
    }
  }

  void _showTotalDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Total Penghasilan'),
        content: Text('Rp ${totalPenghasilan}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openListPage(String title, List<MenuItem> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MenuListPage(title: title, menuList: items),
      ),
    );
  }

  void _hapusTransaksi(int idx) {
    setState(() => riwayatPesanan.removeAt(idx));
  }

  Widget _smallCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: () {
              // pindah ke halaman login dan hapus Dashboard dari stack
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // small control row: tambah menu + spacer
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _showAddMenuDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Menu Baru'),
                ),
                const SizedBox(width: 12),
              ],
            ),

            const SizedBox(height: 3),

            // grid tombol kecil
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.6,
              children: [
                _smallCard(
                  'Makanan',
                  Icons.fastfood,
                  Colors.orange,
                  () => _openListPage('Makanan', makananList),
                ),
                _smallCard(
                  'Minuman',
                  Icons.local_drink,
                  Colors.blue,
                  () => _openListPage('Minuman', minumanList),
                ),
                _smallCard(
                  'Total Penghasilan',
                  Icons.monetization_on,
                  Colors.green,
                  _showTotalDialog,
                ),
                _smallCard('Alamat', Icons.location_on, Colors.red, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur alamat menyusul')),
                  );
                }),
                _smallCard(
                  'Pesan',
                  Icons.shopping_cart,
                  Colors.purple,
                  _openPesanPage,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // header riwayat + ringkasan total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Pesanan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (riwayatPesanan.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Belum ada pesanan'),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: riwayatPesanan.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, idx) {
                  final transaksi = riwayatPesanan[idx];
                  final subtotal = transaksi.fold<int>(
                    0,
                    (s, it) => s + it.harga,
                  );
                  return Card(
                    child: ExpansionTile(
                      title: Text('Pesanan ${idx + 1}'),
                      subtitle: Text('Total: Rp $subtotal'),
                      children: [
                        ...transaksi.map(
                          (it) => ListTile(
                            title: Text(it.nama),
                            trailing: Text('Rp ${it.harga}'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            bottom: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _hapusTransaksi(idx),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// ===================== VIEW PAGE =====================
class MenuListPage extends StatelessWidget {
  final String title;
  final List<MenuItem> menuList;

  const MenuListPage({super.key, required this.title, required this.menuList});

  void _showDetail(BuildContext ctx, MenuItem item) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(item.nama),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Harga: Rp ${item.harga}'),
            Text('Stok: ${item.stok}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: menuList.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = menuList[index];
          return ListTile(
            title: Text(item.nama),
            trailing: Text('Rp ${item.harga}'),
            onTap: () => _showDetail(context, item),
          );
        },
      ),
    );
  }
}

/// ===================== PESAN PAGE =====================
class PesanPage extends StatefulWidget {
  final List<MenuItem> makanan;
  final List<MenuItem> minuman;

  const PesanPage({super.key, required this.makanan, required this.minuman});

  @override
  State<PesanPage> createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  final List<MenuItem> keranjang = [];

  void _add(MenuItem item) {
    setState(() => keranjang.add(item.copy()));
  }

  void _removeAt(int i) => setState(() => keranjang.removeAt(i));

  int get subtotal => keranjang.fold<int>(0, (s, it) => s + it.harga);

  void _confirm() {
    if (keranjang.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keranjang kosong')));
      return;
    }
    // return the selected items to the caller (Dashboard)
    Navigator.pop(context, List<MenuItem>.from(keranjang));
  }

  Widget _columnMenu(String title, List<MenuItem> list) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final it = list[index];
                return ListTile(
                  title: Text(it.nama),
                  subtitle: Text('Stok: ${it.stok}'),
                  trailing: Text('Rp ${it.harga}'),
                  onTap: () => _add(it),
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
      appBar: AppBar(title: const Text('Pesan Menu')),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _columnMenu('Makanan', widget.makanan),
                const VerticalDivider(width: 1),
                _columnMenu('Minuman', widget.minuman),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total sementara: Rp $subtotal',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _confirm,
                    child: const Text('Pesan Sekarang'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: keranjang.length,
                    itemBuilder: (context, i) {
                      final it = keranjang[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(it.nama),
                              Text(
                                'Rp ${it.harga}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeAt(i),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
