class UserModel {
  String? image;
  String? pushTocken;
  String? lastActivity;
  String? about;
  String? name;
  String? createdAt;
  String? id;
  bool? isOnline;
  String? email;

  UserModel({
    this.image,
    this.pushTocken,
    this.lastActivity,
    this.about,
    this.name,
    this.createdAt,
    this.id,
    this.isOnline,
    this.email,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : image = json['image'] as String?,
        pushTocken = json['push_tocken'] as String?,
        lastActivity = json['last_activity'] as String?,
        about = json['about'] as String?,
        name = json['name'] as String?,
        createdAt = json['created_at'] as String?,
        id = json['id'] as String?,
        isOnline = json['is_online'] as bool?,
        email = json['email'] as String?;

  Map<String, dynamic> toJson() => {
        'image': image ?? '',
        'push_tocken': pushTocken ?? '',
        'last_activity': lastActivity ?? '',
        'about': about ?? '',
        'name': name ?? '',
        'created_at': createdAt ?? '',
        'id': id ?? '',
        'is_online': isOnline ?? '',
        'email': email ?? ''
      };
}
