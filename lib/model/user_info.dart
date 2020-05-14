


class UserInformation {
  String name;
  int id;
  String avatar;
  String theme;

  UserInformation({this.name, this.id, this.avatar, this.theme});

  factory UserInformation.fromJson(Map<String, dynamic> json) {
    print('from json $json   ${json['id'].runtimeType}');

    String name = json['name'] != null ? json['name'] : json['url_name'];

    int userId;
    if (json['id'].runtimeType == int) {
      userId = json['id'];
    } else {
      userId = int.parse(json['id']);
    }

    return UserInformation(name: name, id: userId, avatar: json['avatar_pic'], theme: json['theme_color']);
  }

}
