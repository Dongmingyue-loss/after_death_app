import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/data_models.dart';
import '../widgets/common_widgets.dart';

class EmergencyCardPage extends StatefulWidget {
  const EmergencyCardPage({super.key});

  @override
  State<EmergencyCardPage> createState() => _EmergencyCardPageState();
}

class _EmergencyCardPageState extends State<EmergencyCardPage> {
  late EmergencyCardData _data;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _bloodCtrl = TextEditingController();
  final _allergyCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _medicalNotesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = EmergencyCardData();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final height = prefs.getString('emergency_height') ?? '';
    final weight = prefs.getString('emergency_weight') ?? '';
    final blood = prefs.getString('emergency_blood') ?? '';
    final allergy = prefs.getString('emergency_allergy') ?? '';
    final contact = prefs.getString('emergency_contact') ?? '';
    final notes = prefs.getString('emergency_medicalNotes') ?? '';
    setState(() {
      _data = EmergencyCardData(
        height: height,
        weight: weight,
        bloodType: blood,
        allergies: allergy,
        emergencyContact: contact,
        medicalNotes: notes,
      );
      _updateControllers();
    });
  }

  void _updateControllers() {
    _heightCtrl.text = _data.height;
    _weightCtrl.text = _data.weight;
    _bloodCtrl.text = _data.bloodType;
    _allergyCtrl.text = _data.allergies;
    _contactCtrl.text = _data.emergencyContact;
    _medicalNotesCtrl.text = _data.medicalNotes;
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      final newData = EmergencyCardData(
        height: _heightCtrl.text.trim(),
        weight: _weightCtrl.text.trim(),
        bloodType: _bloodCtrl.text.trim(),
        allergies: _allergyCtrl.text.trim(),
        emergencyContact: _contactCtrl.text.trim(),
        medicalNotes: _medicalNotesCtrl.text.trim(),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('emergency_height', newData.height);
      await prefs.setString('emergency_weight', newData.weight);
      await prefs.setString('emergency_blood', newData.bloodType);
      await prefs.setString('emergency_allergy', newData.allergies);
      await prefs.setString('emergency_contact', newData.emergencyContact);
      await prefs.setString('emergency_medicalNotes', newData.medicalNotes);
      setState(() {
        _data = newData;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('急救卡已保存')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('急救卡'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveData,
            ),
        ],
      ),
      body: _isEditing ? _buildEditForm() : _buildDisplayCard(),
    );
  }

  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _heightCtrl,
              decoration: const InputDecoration(labelText: '身高 (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _weightCtrl,
              decoration: const InputDecoration(labelText: '体重 (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _bloodCtrl,
              decoration: const InputDecoration(labelText: '血型 (如 A, B, O, AB)'),
            ),
            TextFormField(
              controller: _allergyCtrl,
              decoration: const InputDecoration(labelText: '药品过敏 (如 青霉素)'),
            ),
            TextFormField(
              controller: _contactCtrl,
              decoration: const InputDecoration(labelText: '紧急联系人 (姓名+电话)'),
            ),
            TextFormField(
              controller: _medicalNotesCtrl,
              decoration: const InputDecoration(labelText: '其他医疗备注'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayCard() {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: Text(
              '急救信息卡',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(thickness: 2, height: 32),
          LargeEmergencyText(label: '身高', value: _data.height),
          LargeEmergencyText(label: '体重', value: _data.weight),
          LargeEmergencyText(label: '血型', value: _data.bloodType),
          LargeEmergencyText(label: '药物过敏', value: _data.allergies),
          LargeEmergencyText(label: '紧急联系人', value: _data.emergencyContact),
          LargeEmergencyText(label: '医疗备注', value: _data.medicalNotes),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: const Text(
              '⚠️ 紧急情况请直接展示本屏幕给急救人员',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}