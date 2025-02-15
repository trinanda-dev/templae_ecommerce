// class UserModel {
//   final String nama;
//   final String email;
//   final String nomorHp;
//   final String namaToko;
//   final String? terakhirLogin;

//   UserModel({
//     required this.nama,
//     required this.email,
//     required this.nomorHp,
//     required this.namaToko,
//     this.terakhirLogin,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       nama: json['nama'],
//       email: json['email'],
//       nomorHp: json['nomor_hp'],
//       namaToko: json['nama_toko'],
//       terakhirLogin: json['terakhir_login'],
//     );
//   }
// }