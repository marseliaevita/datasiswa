import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datasiswa/models/siswa.dart';

class SiswaCard extends StatelessWidget {
  final Siswa siswa;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SiswaCard({
    super.key,
    required this.siswa,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar bulat dengan icon
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, size: 30, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            
            // Info siswa
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    siswa.namaLengkap,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "NISN: ${siswa.nisn}",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    "No HP: ${siswa.telp}",
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Tombol Edit & Delete
            Column(
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
          ],
        ),
      ),
    );
  }
}
