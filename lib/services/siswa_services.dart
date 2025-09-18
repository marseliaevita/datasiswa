import 'package:datasiswa/models/siswa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SiswaService {
  final supabase = Supabase.instance.client;

  /// Get semua siswa beserta data orang tua, wali & alamat
  Future<List<Siswa>> getAll() async {
    try {
      final response = await supabase
          .from('siswa')
          .select('*, orang_tua(*), wali(*), alamat(*)');

      final dataList = response as List<dynamic>;

      return dataList.map((data) {
        final orangTuaList = data['orang_tua'] as List<dynamic>;
        final waliList = data['wali'] as List<dynamic>;
        final alamatData = data['alamat'];

        final orangTua = orangTuaList.isNotEmpty ? orangTuaList[0] : null;
        final wali = waliList.isNotEmpty ? waliList[0] : null;

        return Siswa(
          id: data['id'].toString(),
          nisn: data['nisn'] ?? '',
          namaLengkap: data['nama_lengkap'] ?? '',
          jenisKelamin: data['jenis_kelamin'] ?? '',
          agama: data['agama'] ?? '',
          ttl: data['ttl'] ?? '',
          telp: data['telp'] ?? '',
          nik: data['nik'] ?? '',
          jalan: data['jalan'] ?? '',
          rtrw: data['rtrw'] ?? '',
          dusun: alamatData != null ? alamatData['dusun'] ?? '' : '',
          desa: alamatData != null ? alamatData['desa'] ?? '' : '',
          kecamatan: alamatData != null ? alamatData['kecamatan'] ?? '' : '',
          kabupaten: alamatData != null ? alamatData['kabupaten'] ?? '' : '',
          provinsi: alamatData != null ? alamatData['provinsi'] ?? '' : '',
          kodepos: alamatData != null ? alamatData['kodepos'] ?? '' : '',
          ayah: orangTua != null ? orangTua['nama_ayah'] ?? '' : '',
          ibu: orangTua != null ? orangTua['nama_ibu'] ?? '' : '',
          wali: wali != null ? wali['nama_wali'] ?? '' : '',
          alamatWali: wali != null ? wali['alamat_wali'] ?? '' : '',
        );
      }).toList();
    } catch (e) {
      throw Exception("Gagal ambil data: $e");
    }
  }

  /// Tambah siswa baru
  Future<void> add(Siswa siswa) async {
    try {
      // Cari alamat_id dari tabel alamat
      final alamat = await supabase
          .from('alamat')
          .select('id')
          .eq('dusun', siswa.dusun)
          .maybeSingle();

      if (alamat == null) {
        throw Exception("Alamat dengan dusun '${siswa.dusun}' tidak ditemukan");
      }

      final alamatId = alamat['id'];

      // Insert siswa
      final siswaData = await supabase.from('siswa').insert({
        'nisn': siswa.nisn,
        'nama_lengkap': siswa.namaLengkap,
        'jenis_kelamin': siswa.jenisKelamin,
        'agama': siswa.agama,
        'ttl': siswa.ttl,
        'telp': siswa.telp,
        'nik': siswa.nik,
        'jalan': siswa.jalan,
        'rtrw': siswa.rtrw,
        'alamat_id': alamatId,
      }).select().single();

      final siswaId = siswaData['id'];

      // Insert orang tua
      await supabase.from('orang_tua').insert({
        'siswa_id': siswaId,
        'nama_ayah': siswa.ayah,
        'nama_ibu': siswa.ibu,
        'alamat_ortu': siswa.alamatWali,
      });

      // Insert wali (opsional)
      if (siswa.wali.isNotEmpty) {
        await supabase.from('wali').insert({
          'siswa_id': siswaId,
          'nama_wali': siswa.wali,
          'alamat_wali': siswa.alamatWali,
        });
      }
    } catch (e, stack) {
      print("Error add siswa: $e");
      print(stack);
      throw Exception("Gagal tambah data: $e");
    }
  }

  /// Update data siswa
  Future<void> update(String siswaId, Siswa siswa) async {
    try {
      // Cari alamat_id dari tabel alamat
      final alamat = await supabase
          .from('alamat')
          .select('id')
          .eq('dusun', siswa.dusun)
          .maybeSingle();

      if (alamat == null) {
        throw Exception("Alamat dengan dusun '${siswa.dusun}' tidak ditemukan");
      }

      final alamatId = alamat['id'];

      // Update siswa
      await supabase.from('siswa').update({
        'nisn': siswa.nisn,
        'nama_lengkap': siswa.namaLengkap,
        'jenis_kelamin': siswa.jenisKelamin,
        'agama': siswa.agama,
        'ttl': siswa.ttl,
        'telp': siswa.telp,
        'nik': siswa.nik,
        'jalan': siswa.jalan,
        'rtrw': siswa.rtrw,
        'alamat_id': alamatId,
      }).eq('id', siswaId);

      // === Orang tua ===
      final orangTua = await supabase
          .from('orang_tua')
          .select('id')
          .eq('siswa_id', siswaId)
          .maybeSingle();

      if (orangTua != null) {
        await supabase.from('orang_tua').update({
          'nama_ayah': siswa.ayah,
          'nama_ibu': siswa.ibu,
          'alamat_ortu': siswa.alamatWali,
        }).eq('siswa_id', siswaId);
      } else {
        await supabase.from('orang_tua').insert({
          'siswa_id': siswaId,
          'nama_ayah': siswa.ayah,
          'nama_ibu': siswa.ibu,
          'alamat_ortu': siswa.alamatWali,
        });
      }

      // === Wali ===
      final wali = await supabase
          .from('wali')
          .select('id')
          .eq('siswa_id', siswaId)
          .maybeSingle();

      if (siswa.wali.isNotEmpty) {
        if (wali != null) {
          await supabase.from('wali').update({
            'nama_wali': siswa.wali,
            'alamat_wali': siswa.alamatWali,
          }).eq('siswa_id', siswaId);
        } else {
          await supabase.from('wali').insert({
            'siswa_id': siswaId,
            'nama_wali': siswa.wali,
            'alamat_wali': siswa.alamatWali,
          });
        }
      } else {
        // Hapus wali kalau kosong
        if (wali != null) {
          await supabase.from('wali').delete().eq('siswa_id', siswaId);
        }
      }
    } catch (e, stack) {
      print("Error update siswa: $e");
      print(stack);
      throw Exception("Gagal update data: $e");
    }
  }

  /// Hapus siswa beserta orang_tua & wali
  Future<void> deleteById(String siswaId) async {
    try {
      await supabase.from('wali').delete().eq('siswa_id', siswaId);
      await supabase.from('orang_tua').delete().eq('siswa_id', siswaId);
      await supabase.from('siswa').delete().eq('id', siswaId);
    } catch (e, stack) {
      print("Error delete siswa: $e");
      print(stack);
      throw Exception("Gagal hapus data: $e");
    }
  }
}
