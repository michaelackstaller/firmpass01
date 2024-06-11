enum ElementType { lesson, sidetrip, social, worship, firmsunday }

enum FirmGroup { monday, tuesday, wednesday, thursday, friday, all, none }

class FirmElement {
  final String id;
  final String name;
  final DateTime? should_done;
  final DateTime? is_done;
  final ElementType type;
  final FirmGroup firmGroup;

  FirmElement({
    required this.id,
    required this.name,
    required this.should_done,
    required this.is_done,
    required this.type,
    required this.firmGroup,
  });

  factory FirmElement.fromJson(Map<String, dynamic> json) {
    return FirmElement(
      id: json['id'],
      name: json['name'],
      should_done: json['should_done'] != null
          ? DateTime.parse(json['should_done'])
          : null,
      is_done: json['is_done'] != null ? DateTime.parse(json['is_done']) : null,
      type: ElementType.values
          .firstWhere((e) => e.toString() == 'ElementType.${json['type']}'),
      firmGroup: FirmGroup.values
          .firstWhere((e) => e.toString() == 'FirmGroup.${json['firmGroup']}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'should_done': should_done?.toIso8601String(),
      'is_done': is_done?.toIso8601String(),
      'type': type.toString().split('.').last,
      'firmGroup': firmGroup.toString().split('.').last,
    };
  }
}
