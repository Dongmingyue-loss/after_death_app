import 'dart:convert';

class ChecklistItem {
  String text;
  bool isDone;

  ChecklistItem({required this.text, this.isDone = false});

  Map<String, dynamic> toJson() => {'text': text, 'isDone': isDone};

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      ChecklistItem(text: json['text'], isDone: json['isDone']);
}

class MemoCategory {
  String name;
  List<ChecklistItem> items;
  String notes;

  MemoCategory({required this.name, required this.items, this.notes = ''});

  Map<String, dynamic> toJson() => {
        'name': name,
        'items': items.map((i) => i.toJson()).toList(),
        'notes': notes,
      };

  factory MemoCategory.fromJson(Map<String, dynamic> json) => MemoCategory(
        name: json['name'],
        items: (json['items'] as List)
            .map((i) => ChecklistItem.fromJson(i))
            .toList(),
        notes: json['notes'] ?? '',
      );
}

class EmergencyCardData {
  String height;
  String weight;
  String bloodType;
  String allergies;
  String emergencyContact;
  String medicalNotes;

  EmergencyCardData({
    this.height = '',
    this.weight = '',
    this.bloodType = '',
    this.allergies = '',
    this.emergencyContact = '',
    this.medicalNotes = '',
  });

  Map<String, String> toMap() => {
        'height': height,
        'weight': weight,
        'bloodType': bloodType,
        'allergies': allergies,
        'emergencyContact': emergencyContact,
        'medicalNotes': medicalNotes,
      };

  factory EmergencyCardData.fromMap(Map<String, String> map) =>
      EmergencyCardData(
        height: map['height'] ?? '',
        weight: map['weight'] ?? '',
        bloodType: map['bloodType'] ?? '',
        allergies: map['allergies'] ?? '',
        emergencyContact: map['emergencyContact'] ?? '',
        medicalNotes: map['medicalNotes'] ?? '',
      );
}