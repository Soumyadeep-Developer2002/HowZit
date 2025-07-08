class Consumers {
  Consumers({
    required this.isOnline,
    required this.LastActive,
    required this.CreatedOn,
    required this.Email,
    required this.ID,
    required this.Image,
    required this.About,
    required this.Name,
    required this.PushNotification,
  });
  late bool isOnline;
  late String LastActive;
  late String CreatedOn;
  late String Email;
  late String ID;
  late String Image;
  late String About;
  late String Name;
  late String PushNotification;

  Consumers.fromJson(Map<String, dynamic> json) {
    isOnline = json['is_Online'] ?? '';
    LastActive = json['Last_active'];
    CreatedOn = json['Created_on'];
    Email = json['Email'];
    ID = json['ID'];
    Image = json['Image'];
    About = json['About'];
    Name = json['Name'];
    PushNotification = json['Push_Notification'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_Online'] = isOnline;
    data['Last_active'] = LastActive;
    data['Created_on'] = CreatedOn;
    data['Email'] = Email;
    data['ID'] = ID;
    data['Image'] = Image;
    data['About'] = About;
    data['Name'] = Name;
    data['Push_Notification'] = PushNotification;
    return data;
  }
}
