import 'goto_action.dart';

class PageModel {
  final String pageText;
  final String pageImageUrl;
  final String? voiceNarration;
  final List<dynamic> sounds;
  final List<GotoAction> gotoAction;
  final String textLocation;
  final int pageNum;
  final int nextPage;

  PageModel({
    required this.pageText,
    required this.pageImageUrl,
    this.voiceNarration,
    required this.sounds,
    required this.gotoAction,
    required this.textLocation,
    required this.pageNum,
    required this.nextPage,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      pageText: json['pageText'],
      pageImageUrl: json['pageImageUrl'] ?? json['pageImagUrl'] ?? '',
      voiceNarration: json['narrationUrl'],
      sounds: List<dynamic>.from(json['pageActions']?['sounds'] ?? []),
      gotoAction: (json['pageActions']['gotoAction'] as List<dynamic>? ?? [])
          .map((item) => GotoAction.fromJson(item))
          .toList(),
      textLocation: json['textLocation'] ?? 'bottom',
      pageNum: json['pageNum'] ?? 0,
      nextPage: json['nextPage'] ?? -1,
    );
  }
}
