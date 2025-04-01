class PageModel {
  final String pageText;
  final String pageImageUrl;
  final String? voiceNarration;
  final List<Choice> choices;
  final List<String> sounds;

  PageModel({
    required this.pageText,
    required this.pageImageUrl,
    this.voiceNarration,
    required this.choices,
    required this.sounds,
  });

  // Convert JSON to PageModel
  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      pageText: json['pageText'],
      pageImageUrl: json['pageImageUrl'],
      voiceNarration: json['voiceNarration'], // Can be null
      choices: (json['gotoAction'] as List)
          .map((choice) => Choice.fromJson(choice))
          .toList(),
      sounds: List<String>.from(json['sounds']),
    );
  }

  // Convert PageModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'pageText': pageText,
      'pageImageUrl': pageImageUrl,
      'voiceNarration': voiceNarration,
      'gotoAction': choices.map((choice) => choice.toJson()).toList(),
      'sounds': sounds,
    };
  }
}

class Choice {
  final String text;
  final int page;
  final String? iconUrl;

  Choice({
    required this.text,
    required this.page,
    this.iconUrl,
  });

  // Convert JSON to Choice
  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      text: json['text'],
      page: json['page'],
      iconUrl: json['iconUrl'],
    );
  }

  // Convert Choice to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'page': page,
      'iconUrl': iconUrl,
    };
  }
}
