import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datasiswa/models/siswa.dart';
import 'package:datasiswa/services/siswa_services.dart';
import 'package:datasiswa/page/form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SiswaService siswaService = SiswaService();

  void _navigateToForm({Siswa? siswa, String? siswaId}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormPage(siswa: siswa, siswaId: siswaId),
      ),
    );

    if (result != null) setState(() {});
  }

  void _deleteSiswa(String siswaId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah yakin ingin menghapus data ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus")),
        ],
      ),
    );
    if (confirm == true) {
      await siswaService.deleteById(siswaId);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Siswa", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Siswa>>(
        future: siswaService.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data siswa'));
          } else {
            final siswaList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: siswaList.length,
              itemBuilder: (context, index) {
                final siswa = siswaList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(siswa.namaLengkap, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    subtitle: Text("NISN: ${siswa.nisn} | ${siswa.jenisKelamin}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _navigateToForm(siswa: siswa, siswaId: siswa.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteSiswa(siswa.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
