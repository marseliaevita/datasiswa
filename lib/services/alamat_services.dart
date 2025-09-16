import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AlamatService {
  final supabase = Supabase.instance.client;

  /// Mendapatkan list dusun untuk autocomplete
  Future<List<String>> getDusunList() async {
    // Cek koneksi internet
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      throw Exception("Tidak ada koneksi internet");
    }

    try {
      final response = await supabase
          .from('alamat')
          .select('dusun') // hanya ambil dusun
          .order('dusun');

      // supabase response bisa List<dynamic>
      final dusunList = (response as List)
          .map((e) => e['dusun'].toString())
          .toSet()
          .toList(); // unik

      return dusunList;
    } catch (e) {
      throw Exception("Gagal koneksi ke Supabase: $e");
    }
  }

  /// Mendapatkan data alamat berdasarkan dusun
  Future<Map<String, String>?> getAlamatByDusun(String dusun) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      throw Exception("Tidak ada koneksi internet");
    }

    try {
      final response = await supabase
          .from('alamat')
          .select()
          .eq('dusun', dusun)
          .limit(1);

      if ((response as List).isNotEmpty) {
        final data = response[0];
        return {
          'desa': data['desa'] ?? '',
          'kecamatan': data['kecamatan'] ?? '',
          'kabupaten': data['kabupaten'] ?? '',
          'kodepos': data['kode_pos'] ?? '',
        };
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Gagal koneksi ke Supabase: $e");
    }
  }
}
