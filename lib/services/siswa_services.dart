import '../models/siswa.dart';

class SiswaService {
  final List<Siswa> _siswaList = [];

  List<Siswa> getAll() => _siswaList;

  void add(Siswa siswa) {
    _siswaList.add(siswa);
  }

  void update(int index, Siswa siswa) {
    _siswaList[index] = siswa;
  }

  void delete(int index) {
    _siswaList.removeAt(index);
  }
}
