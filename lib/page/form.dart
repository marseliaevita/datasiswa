import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:datasiswa/models/siswa.dart';
import 'package:datasiswa/services/alamat_services.dart';
import 'package:datasiswa/services/siswa_services.dart';

class FormPage extends StatefulWidget {
  final Siswa? siswa;
  final String? siswaId; // untuk update Supabase

  const FormPage({super.key, this.siswa, this.siswaId});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final AlamatService alamatService = AlamatService();
  final SiswaService siswaService = SiswaService();

  // Controllers
  late TextEditingController nisnController;
  late TextEditingController namaController;
  late TextEditingController tempatLahirController;
  late TextEditingController tanggalLahirController;
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

  List<String> dusunSuggestion = [];
  List<String> provinsiSuggestion = [];

  @override
  void initState() {
    super.initState();

    nisnController = TextEditingController(text: widget.siswa?.nisn ?? "");
    namaController = TextEditingController(text: widget.siswa?.namaLengkap ?? "");
    selectedJK = widget.siswa?.jenisKelamin;
    selectedAgama = widget.siswa?.agama;

    // TTL pisah jadi tempat + tanggal
    if (widget.siswa?.ttl != null && widget.siswa!.ttl.contains(",")) {
      final parts = widget.siswa!.ttl.split(",");
      tempatLahirController = TextEditingController(text: parts[0].trim());
      tanggalLahirController = TextEditingController(text: parts[1].trim());
    } else {
      tempatLahirController = TextEditingController();
      tanggalLahirController = TextEditingController();
    }

    telpController = TextEditingController(text: widget.siswa?.telp ?? "");
    nikController = TextEditingController(text: widget.siswa?.nik ?? "");
    jalanController = TextEditingController(text: widget.siswa?.jalan ?? "");
    rtrwController = TextEditingController(text: widget.siswa?.rtrw ?? "");
    dusunController = TextEditingController(text: widget.siswa?.dusun ?? "");
    desaController = TextEditingController(text: widget.siswa?.desa ?? "");
    kecamatanController = TextEditingController(text: widget.siswa?.kecamatan ?? "");
    kabupatenController = TextEditingController(text: widget.siswa?.kabupaten ?? "");
    provinsiController = TextEditingController(text: widget.siswa?.provinsi ?? "");
    kodeposController = TextEditingController(text: widget.siswa?.kodepos ?? "");
    ayahController = TextEditingController(text: widget.siswa?.ayah ?? "");
    ibuController = TextEditingController(text: widget.siswa?.ibu ?? "");
    waliController = TextEditingController(text: widget.siswa?.wali ?? "");
    alamatWaliController = TextEditingController(text: widget.siswa?.alamatWali ?? "");

    _loadDusun();
    _loadProvinsi();
  }

  void _loadDusun() async {
    try {
      final list = await alamatService.getDusunList();
      setState(() => dusunSuggestion = list);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _loadProvinsi() async {
    try {
      final list = await alamatService.getProvinsiList();
      setState(() => provinsiSuggestion = list);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    nisnController.dispose();
    namaController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
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

  //=================== VALIDATOR ===================
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) return "Wajib diisi";
    return null;
  }

  String? validateNISN(String? value) {
    if (value == null || value.isEmpty) return "Wajib diisi";
    if (value.length != 10) return "NISN harus 10 karakter";
    return null;
  }

  String? validateTelp(String? value) {
    if (value == null || value.isEmpty) return "Wajib diisi";
    if (value.length < 12 || value.length > 15) return "Nomor HP harus 12-15 digit";
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Hanya boleh angka";
    return null;
  }

  String? validateNIK(String? value) {
    if (value == null || value.isEmpty) return "Wajib diisi";
    if (value.length != 16) return "NIK harus 16 karakter";
    return null;
  }

  String? validateRTRW(String? value) {
    if (value == null || value.isEmpty) return "Wajib diisi";
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Hanya boleh angka";
    return null;
  }

  //=================== SAVE DATA ===================
  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final siswa = Siswa(
      nisn: nisnController.text,
      namaLengkap: namaController.text,
      jenisKelamin: selectedJK ?? "",
      agama: selectedAgama ?? "",
      ttl: "${tempatLahirController.text}, ${tanggalLahirController.text}",
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

    try {
      if (widget.siswaId != null) {
        await siswaService.update(widget.siswaId!, siswa);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil diupdate")));
      } else {
        await siswaService.add(siswa);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data berhasil disimpan")));
      }
      Navigator.pop(context, siswa);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    }
  }

  //=================== BUILD WIDGET ===================
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
          filled: true,
          fillColor: Colors.blue[50], // ✅ biru muda
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: GoogleFonts.poppins(),
        validator: validator ?? (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  Widget _buildReadonlyField(String label, TextEditingController controller, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          filled: true,
          fillColor: Colors.blue[100], // ✅ biru lebih terang untuk readonly
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: GoogleFonts.poppins(color: Colors.black87),
      ),
    );
  }

  Widget _buildDropdownJK() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedJK,
        items: ["Laki-laki", "Perempuan"]
            .map((jk) => DropdownMenuItem(value: jk, child: Text(jk, style: GoogleFonts.poppins())))
            .toList(),
        onChanged: (value) => setState(() => selectedJK = value),
        decoration: InputDecoration(
          labelText: "Jenis Kelamin",
          labelStyle: GoogleFonts.poppins(),
          prefixIcon: const Icon(Icons.wc, color: Colors.blue),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.isEmpty ? "Wajib dipilih" : null,
      ),
    );
  }

  Widget _buildDropdownAgama() {
    final agamaList = ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Konghucu"];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedAgama,
        items: agamaList.map((agama) => DropdownMenuItem(value: agama, child: Text(agama, style: GoogleFonts.poppins()))).toList(),
        onChanged: (value) => setState(() => selectedAgama = value),
        decoration: InputDecoration(
          labelText: "Agama",
          labelStyle: GoogleFonts.poppins(),
          prefixIcon: const Icon(Icons.mosque, color: Colors.blue),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.isEmpty ? "Wajib dipilih" : null,
      ),
    );
  }

  Widget _buildTanggalField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: tanggalLahirController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Tanggal Lahir",
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
          filled: true,
          fillColor: Colors.blue[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validateRequired,
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime(2005),
            firstDate: DateTime(1980),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              tanggalLahirController.text = DateFormat('dd-MM-yyyy').format(picked);
            });
          }
        },
      ),
    );
  }

  Widget _buildDusunField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Autocomplete<String>(
        optionsBuilder: (textEditingValue) {
          if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
          return dusunSuggestion.where(
            (dusun) => dusun.toLowerCase().contains(textEditingValue.text.toLowerCase()),
          );
        },
        fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
          controller.text = dusunController.text;
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: "Dusun",
              prefixIcon: const Icon(Icons.house, color: Colors.blue),
              filled: true,
              fillColor: Colors.blue[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: validateRequired,
            onEditingComplete: onEditingComplete,
          );
        },
        onSelected: (selection) async {
          dusunController.text = selection;
          try {
            final alamatData = await alamatService.getAlamatByDusun(selection);
            if (alamatData != null) {
              setState(() {
                desaController.text = alamatData['desa']!;
                kecamatanController.text = alamatData['kecamatan']!;
                kabupatenController.text = alamatData['kabupaten']!;
                kodeposController.text = alamatData['kodepos']!;
                provinsiController.text = alamatData['provinsi']!;
              });
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.siswa != null;

    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: Text(isEdit ? "Edit Siswa" : "Tambah Siswa", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField("NISN", nisnController, icon: Icons.badge, validator: validateNISN),
                  _buildTextField("Nama Lengkap", namaController, icon: Icons.person, validator: validateRequired),
                  _buildDropdownJK(),
                  _buildDropdownAgama(),
                  _buildTextField("Tempat Lahir", tempatLahirController, icon: Icons.location_on, validator: validateRequired),
                  _buildTanggalField(),
                  _buildTextField("No Telepon/HP", telpController, icon: Icons.phone, validator: validateTelp),
                  _buildTextField("NIK", nikController, icon: Icons.perm_identity, validator: validateNIK),
                  _buildTextField("Jalan", jalanController, icon: Icons.home_filled, validator: validateRequired),
                  _buildTextField("RT/RW", rtrwController, icon: Icons.map, validator: validateRTRW),
                  _buildDusunField(),
                  _buildReadonlyField("Desa", desaController, icon: Icons.location_city),
                  _buildReadonlyField("Kecamatan", kecamatanController, icon: Icons.apartment),
                  _buildReadonlyField("Kabupaten", kabupatenController, icon: Icons.location_on),
                  _buildReadonlyField("Provinsi", provinsiController, icon: Icons.flag),
                  _buildReadonlyField("Kode Pos", kodeposController, icon: Icons.markunread_mailbox),
                  _buildTextField("Nama Ayah", ayahController, icon: Icons.male, validator: validateRequired),
                  _buildTextField("Nama Ibu", ibuController, icon: Icons.female, validator: validateRequired),
                  _buildTextField("Nama Wali", waliController, icon: Icons.people),
                  _buildTextField("Alamat Orang Tua/Wali", alamatWaliController, icon: Icons.location_pin),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        overlayColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                      ),
                      icon: const Icon(Icons.save),
                      label: Text(isEdit ? "Update" : "Simpan", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
