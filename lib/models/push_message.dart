class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final String? imageUrl;
  final Map<String, dynamic>? data;

  PushMessage(
      {required this.messageId,
      required this.title,
      required this.body,
      required this.sentDate,
      this.imageUrl,
      this.data});

  @override
  String toString() {
    return '''
      PushMessage -
      messageId: $messageId
      title: $title
      body: $body
      sentDate: $sentDate
      data: $data
      imageUrl: $imageUrl
    ''';
  }
}
