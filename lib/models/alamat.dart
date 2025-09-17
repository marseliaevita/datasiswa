class Alamat {
  final int id;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String kodepos;

  Alamat({
    required this.id,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.kodepos,
  });

  factory Alamat.fromJson(Map<String, dynamic> json) {
    return Alamat(
      id: json['id'],
      dusun: json['dusun'],
      desa: json['desa'],
      kecamatan: json['kecamatan'],
      kabupaten: json['kabupaten'],
      kodepos: json['kodepos'],
    );
  }
}
