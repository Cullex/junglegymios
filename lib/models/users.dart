class UserModel {
  int? id;
  String? username;
  String? name;
  String? last_name;
  int? status;
  String? email;
  String? msisdn;
  int? isAdmin;


  UserModel({
    this.id,
    this.username,
    this.name,
    this.last_name,
    this.status,
    this.email,
    this.msisdn,
    this.isAdmin
});

  factory UserModel.fromJson(Map<String,dynamic>json){
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      last_name: json['last_name'] ?? '',
      status: json['status'] ?? 0,
      email: json['email'] ?? '',
      msisdn: json['msisdn'] ?? '',
      isAdmin: json['isAdmin'] ?? 0,
    );
  }
  static List<UserModel> fromJsonList(List<dynamic>jsonList) {
    return jsonList.map((json)=>UserModel.fromJson(json)).toList();
  }

}