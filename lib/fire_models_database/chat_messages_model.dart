class Messages {
  Messages({
    required this.Read,
    required this.Type,
    required this.Message,
    required this.SenderID,
    required this.ReciverID,
    required this.Sent,
  });
  late final String Read;
  late final String Message;
  late final String SenderID;
  late final String ReciverID;
  late final String Sent;
  late final Types Type;

  Messages.fromJson(Map<String, dynamic> json) {
    Read = json['Read'].toString();
    Type =
        json['Type'].toString() == Types.Image.name ? Types.Image : Types.Text;
    Message = json['Message'].toString();
    SenderID = json['Sender_ID'].toString();
    ReciverID = json['Reciver_ID'].toString();
    Sent = json['Sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Read'] = Read;
    data['Type'] = Type.name;
    data['Message'] = Message;
    data['Sender_ID'] = SenderID;
    data['Reciver_ID'] = ReciverID;
    data['Sent'] = Sent;
    return data;
  }
}

enum Types { Text, Image }
