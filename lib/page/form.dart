import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/siswa.dart';

class FormPage extends StatefulWidget {
  final Siswa? siswa;

  const FormPage({super.key, this.siswa});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nisnController;
  late TextEditingController namaController;
  late TextEditingController ttlController;
  late TextEditingController telpController;
  late TextEditingController nikController;
  late TextEditingController jalanController;
  late TextEditingController rtrwController;
  late TextEditingController dusunController;
  late TextEditingController desaController;
  late TextEditingController kecamatanController;
  late TextEditingController kabupatenController;
  late TextEditingController provinsiController;
  late TextEditingController kodeposController;
  late TextEditingController ayahController;
  late TextEditingController ibuController;
  late TextEditingController waliController;
  late TextEditingController alamatWaliController;

  String? selectedJK;
  String? selectedAgama;

  @override
  void initState() {
    super.initState();
    nisnController = TextEditingController(text: widget.siswa?.nisn ?? "");
    namaController =
        TextEditingController(text: widget.siswa?.namaLengkap ?? "");
    selectedJK = widget.siswa?.jenisKelamin;
    selectedAgama = widget.siswa?.agama;
    ttlController = TextEditingController(text: widget.siswa?.ttl ?? "");
    telpController = TextEditingController(text: widget.siswa?.telp ?? "");
    nikController = TextEditingController(text: widget.siswa?.nik ?? "");
    jalanController = TextEditingController(text: widget.siswa?.jalan ?? "");
    rtrwController = TextEditingController(text: widget.siswa?.rtrw ?? "");
    dusunController = TextEditingController(text: widget.siswa?.dusun ?? "");
    desaController = TextEditingController(text: widget.siswa?.desa ?? "");
    kecamatanController =
        TextEditingController(text: widget.siswa?.kecamatan ?? "");
    kabupatenController =
        TextEditingController(text: widget.siswa?.kabupaten ?? "");
    provinsiController =
        TextEditingController(text: widget.siswa?.provinsi ?? "");
    kodeposController =
        TextEditingController(text: widget.siswa?.kodepos ?? "");
    ayahController = TextEditingController(text: widget.siswa?.ayah ?? "");
    ibuController = TextEditingController(text: widget.siswa?.ibu ?? "");
    waliController = TextEditingController(text: widget.siswa?.wali ?? "");
    alamatWaliController =
        TextEditingController(text: widget.siswa?.alamatWali ?? "");
  }

  @override
  void dispose() {
    nisnController.dispose();
    namaController.dispose();
    ttlController.dispose();
    telpController.dispose();
    nikController.dispose();
    jalanController.dispose();
    rtrwController.dispose();
    dusunController.dispose();
    desaController.dispose();
    kecamatanController.dispose();
    kabupatenController.dispose();
    provinsiController.dispose();
    kodeposController.dispose();
    ayahController.dispose();
    ibuController.dispose();
    waliController.dispose();
    alamatWaliController.dispose();
    super.dispose();
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      final siswa = Siswa(
        nisn: nisnController.text,
        namaLengkap: namaController.text,
        jenisKelamin: selectedJK ?? "",
        agama: selectedAgama ?? "",
        ttl: ttlController.text,
        telp: telpController.text,
        nik: nikController.text,
        jalan: jalanController.text,
        rtrw: rtrwController.text,
        dusun: dusunController.text,
        desa: desaController.text,
        kecamatan: kecamatanController.text,
        kabupaten: kabupatenController.text,
        provinsi: provinsiController.text,
        kodepos: kodeposController.text,
        ayah: ayahController.text,
        ibu: ibuController.text,
        wali: waliController.text,
        alamatWali: alamatWaliController.text,
      );
      Navigator.pop(context, siswa);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        style: GoogleFonts.poppins(),
        validator: (value) =>
            value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  Widget _buildDropdownJK() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedJK,
        items: ["Laki-laki", "Perempuan"]
            .map((jk) => DropdownMenuItem(
                  value: jk,
                  child: Text(jk, style: GoogleFonts.poppins()),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedJK = value;
          });
        },
        decoration: InputDecoration(
          labelText: "Jenis Kelamin",
          labelStyle: GoogleFonts.poppins(),
          prefixIcon: const Icon(Icons.wc, color: Colors.blue),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Wajib dipilih" : null,
      ),
    );
  }

  Widget _buildDropdownAgama() {
    final agamaList = [
      "Islam",
      "Kristen",
      "Katolik",
      "Hindu",
      "Buddha",
      "Konghucu"
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedAgama,
        items: agamaList
            .map((agama) => DropdownMenuItem(
                  value: agama,
                  child: Text(agama, style: GoogleFonts.poppins()),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedAgama = value;
          });
        },
        decoration: InputDecoration(
          labelText: "Agama",
          labelStyle: GoogleFonts.poppins(),
          prefixIcon: const Icon(Icons.mosque, color: Colors.blue),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Wajib dipilih" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.siswa != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Siswa" : "Tambah Siswa",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField("NISN", nisnController, icon: Icons.badge),
                  _buildTextField("Nama Lengkap", namaController,
                      icon: Icons.person),
                  _buildDropdownJK(),
                  _buildDropdownAgama(),
                  _buildTextField("Tempat, Tanggal Lahir", ttlController,
                      icon: Icons.cake),
                  _buildTextField("No Telepon/HP", telpController,
                      icon: Icons.phone),
                  _buildTextField("NIK", nikController,
                      icon: Icons.perm_identity),
                  _buildTextField("Jalan", jalanController,
                      icon: Icons.home_filled),
                  _buildTextField("RT/RW", rtrwController, icon: Icons.map),
                  _buildTextField("Dusun", dusunController, icon: Icons.house),
                  _buildTextField("Desa", desaController,
                      icon: Icons.location_city),
                  _buildTextField("Kecamatan", kecamatanController,
                      icon: Icons.apartment),
                  _buildTextField("Kabupaten", kabupatenController,
                      icon: Icons.location_on),
                  _buildTextField("Provinsi", provinsiController,
                      icon: Icons.flag),
                  _buildTextField("Kode Pos", kodeposController,
                      icon: Icons.markunread_mailbox),
                  _buildTextField("Nama Ayah", ayahController, icon: Icons.male),
                  _buildTextField("Nama Ibu", ibuController, icon: Icons.female),
                  _buildTextField("Nama Wali", waliController,
                      icon: Icons.people),
                  _buildTextField("Alamat Orang Tua/Wali", alamatWaliController,
                      icon: Icons.location_pin),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(Icons.save),
                      label: Text(
                        isEdit ? "Update" : "Simpan",
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
