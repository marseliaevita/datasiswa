import 'package:flutter/material.dart';
import 'package:datasiswa/models/siswa.dart';
import 'package:datasiswa/services/siswa_services.dart';
import 'package:datasiswa/widgets/siswa_card.dart';
import 'package:datasiswa/page/form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SiswaService siswaService = SiswaService();

  void _navigateToForm({Siswa? siswa, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormPage(siswa: siswa),
      ),
    );

    if (result != null && result is Siswa) {
      setState(() {
        if (index != null) {
          siswaService.update(index, result);
        } else {
          siswaService.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final siswaList = siswaService.getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Siswa"),
        backgroundColor: Colors.blue,
      ),
      body: siswaList.isEmpty
          ? const Center(child: Text("Belum ada data siswa"))
          : ListView.builder(
              itemCount: siswaList.length,
              itemBuilder: (context, index) {
                final siswa = siswaList[index];
                return SiswaCard(
                  siswa: siswa,
                  onEdit: () => _navigateToForm(siswa: siswa, index: index),
                  onDelete: () {
                    setState(() {
                      siswaService.delete(index);
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}