class CommendModel {

  int? id;
  String? name;
  String? email;


  CommendModel({ this.id,  this.name, this.email});

  factory CommendModel.valueFromJson(Map<String, dynamic> json) {
    return CommendModel(

      id: json["id"] as int,
      name: json["name"] as String,
      email: json["email"] as String,

    );
  }
  factory CommendModel.valueFromDatabase(Map<String, dynamic> data) {
    return CommendModel(

      id: data["id"] as int?,
      name: data["name"] as String?,
      email: data["email"] as String?,

    );
  }

  Map<String, dynamic> toMap() {
    return {

      'id': id,
      'name': name,
      'email': email,

    };
  }
}