class GotoAction {
  final String text;
  final int page;
  final String? iconUrl;

  GotoAction({
    required this.text,
    required this.page,
    this.iconUrl,
  });

  factory GotoAction.fromJson(Map<String, dynamic> json) {
    return GotoAction(
      text: json['text'] ?? '',
      page: json['page'] ?? 0,
      iconUrl: json['iconUrl'],
    );
  }
}
