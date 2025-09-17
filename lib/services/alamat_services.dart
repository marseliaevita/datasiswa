import 'package:supabase_flutter/supabase_flutter.dart';

class AlamatService {
  final supabase = Supabase.instance.client;

  /// Ambil list dusun
  Future<List<String>> getDusunList() async {
    try {
      final response = await supabase.from('alamat').select('dusun');
      final list = (response as List)
          .map((e) => e['dusun'].toString())
          .toSet() 
          .toList();
      return list;
    } catch (e) {
      throw Exception("Gagal ambil dusun: $e");
    }
  }

  
  Future<List<String>> getProvinsiList() async {
    try {
      final response = await supabase.from('alamat').select('provinsi');
      final list = (response as List)
          .map((e) => e['provinsi'].toString())
          .toSet()
          .toList();
      return list;
    } catch (e) {
      throw Exception("Gagal ambil provinsi: $e");
    }
  }

  /// Ambil alamat berdasarkan dusun
  Future<Map<String, String>?> getAlamatByDusun(String dusun) async {
    try {
      final response = await supabase
          .from('alamat')
          .select()
          .eq('dusun', dusun)
          .single();
      if (response == null) return null;
      return {
        'desa': response['desa'] ?? '',
        'kecamatan': response['kecamatan'] ?? '',
        'kabupaten': response['kabupaten'] ?? '',
        'kodepos': response['kodepos'] ?? '',
        'provinsi': response['provinsi'] ?? '',
      };
    } catch (e) {
      throw Exception("Gagal ambil alamat: $e");
    }
  }
}
