enum ElementType { lesson, sidetrip, social, worship, firmsunday }

enum FirmGroup { monday, tuesday, wednesday, thursday, friday, all, none }

class FirmElement {
  final String id;
  final String name;
  final DateTime? should_done;
  final DateTime? is_done;
  final ElementType type;
  final FirmGroup firmGroup;

  FirmElement(
      {required this.id,
      required this.name,
      required this.should_done,
      required this.is_done,
      required this.type,
      required this.firmGroup});
}
