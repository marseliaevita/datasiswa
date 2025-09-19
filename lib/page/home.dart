import 'package:flutter/material.dart';
import 'package:datasiswa/models/siswa.dart';
import 'package:datasiswa/services/siswa_services.dart';
import 'package:datasiswa/page/form.dart';
import 'package:datasiswa/page/detail.dart';
import 'package:datasiswa/widgets/siswa_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final siswaService = SiswaService();
  List<Siswa> siswaList = [];
  List<Siswa> filteredSiswaList = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await siswaService.getAll();
      setState(() {
        siswaList = data;
        filteredSiswaList = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  void _filterSiswa(String query) {
    final filtered = siswaList.where((siswa) {
      final namaLower = siswa.namaLengkap.toLowerCase();
      final queryLower = query.toLowerCase();
      return namaLower.contains(queryLower);
    }).toList();

    setState(() {
      searchQuery = query;
      filteredSiswaList = filtered;
    });
  }

  Future<void> _deleteSiswa(String id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus"),
        content: const Text("Apakah kamu yakin ingin menghapus data siswa ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await siswaService.deleteById(id);
        setState(() {
          siswaList.removeWhere((s) => s.id == id);
          _filterSiswa(searchQuery);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil dihapus")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal hapus data: $e")),
        );
      }
    }
  }

  void _navigateToForm({Siswa? siswa, String? siswaId}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormPage(siswa: siswa, siswaId: siswaId),
      ),
    );

    if (result != null && result is Map) {
      final action = result['action'];
      final Siswa updatedSiswa = result['siswa'];

      setState(() {
        if (action == 'add') {
          siswaList.add(updatedSiswa);
        } else if (action == 'update') {
          final index = siswaList.indexWhere((s) => s.id == updatedSiswa.id);
          if (index != -1) siswaList[index] = updatedSiswa;
        }
        _filterSiswa(searchQuery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Data Siswa",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Kelola informasi siswa dengan mudah",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: _filterSiswa,
                  decoration: InputDecoration(
                    hintText: "Cari siswa...",
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: fetchData,
                    child: filteredSiswaList.isEmpty
                        ? const Center(
                            child: Text(
                              "Belum ada data siswa",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 12),
                            itemCount: filteredSiswaList.length,
                            itemBuilder: (context, index) {
                              final siswa = filteredSiswaList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: SiswaCard(
                                  siswa: siswa,
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailPage(siswa: siswa),
                                      ),
                                    );
                                    if (result == true) fetchData();
                                  },
                                  onEdit: () =>
                                      _navigateToForm(siswa: siswa, siswaId: siswa.id),
                                  onDelete: () => _deleteSiswa(siswa.id),
                                ),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.shade700,
        onPressed: () => _navigateToForm(),
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}
