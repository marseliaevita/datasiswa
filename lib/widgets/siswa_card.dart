import 'package:flutter/material.dart';
import 'package:datasiswa/models/siswa.dart';

class SiswaCard extends StatelessWidget {
  final Siswa siswa;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap; 

  const SiswaCard({
    super.key,
    required this.siswa,
    this.onEdit,
    this.onDelete,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        onTap: onTap, // ✅ biar bisa dipakai di HomePage
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            siswa.namaLengkap.isNotEmpty
                ? siswa.namaLengkap[0].toUpperCase()
                : "?",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(siswa.namaLengkap),
        subtitle: Text("NISN: ${siswa.nisn}\nHP: ${siswa.telp}"),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
