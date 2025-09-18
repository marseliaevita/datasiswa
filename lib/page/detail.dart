import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:datasiswa/models/siswa.dart';

class DetailPage extends StatelessWidget {
  final Siswa siswa;

  const DetailPage({super.key, required this.siswa});

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue.shade600),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          value.isNotEmpty ? value : "-",
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Detail Siswa",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white, // judul putih
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Avatar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      siswa.namaLengkap.isNotEmpty
                          ? siswa.namaLengkap[0].toUpperCase()
                          : "?",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    siswa.namaLengkap,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "NISN: ${siswa.nisn}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info siswa
            _buildInfoTile("Jenis Kelamin", siswa.jenisKelamin, Icons.wc),
            _buildInfoTile("Agama", siswa.agama, Icons.mosque),
            _buildInfoTile("TTL", siswa.ttl, Icons.cake),
            _buildInfoTile("No HP", siswa.telp, Icons.phone),
            _buildInfoTile("NIK", siswa.nik, Icons.badge),
            _buildInfoTile(
              "Alamat",
              "${siswa.jalan}, RT/RW ${siswa.rtrw}, ${siswa.dusun}, ${siswa.desa}, ${siswa.kecamatan}, ${siswa.kabupaten}, ${siswa.provinsi} - ${siswa.kodepos}",
              Icons.home,
            ),

            const SizedBox(height: 12),
            Divider(thickness: 1, indent: 24, endIndent: 24, color: Colors.grey.shade300),

            // Info orang tua
            _buildInfoTile("Ayah", siswa.ayah, Icons.man),
            _buildInfoTile("Ibu", siswa.ibu, Icons.woman),

            const SizedBox(height: 12),
            Divider(thickness: 1, indent: 24, endIndent: 24, color: Colors.grey.shade300),

            // Info wali
            _buildInfoTile("Wali", siswa.wali, Icons.person),
            _buildInfoTile("Alamat Wali", siswa.alamatWali, Icons.location_on),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
