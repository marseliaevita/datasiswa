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
  bool isLoading = true;

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
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await siswaService.deleteById(id);
        fetchData();

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
    if (result == true) fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Siswa")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchData,
              child: siswaList.isEmpty
                  ? const Center(child: Text("Belum ada data siswa"))
                  : ListView.builder(
                      itemCount: siswaList.length,
                      itemBuilder: (context, index) {
                        final siswa = siswaList[index];
                        return SiswaCard(
                          siswa: siswa,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(siswa: siswa),
                              ),
                            );
                            if (result == true) fetchData(); // refresh kalau ada hapus/edit
                          },
                          onEdit: () => _navigateToForm(
                              siswa: siswa, siswaId: siswa.id),
                          onDelete: () => _deleteSiswa(siswa.id),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
