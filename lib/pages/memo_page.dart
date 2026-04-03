import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/data_models.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  List<MemoCategory> categories = [];
  int? selectedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('memo_categories');
    if (jsonStr != null) {
      final List<dynamic> list = json.decode(jsonStr);
      setState(() {
        categories = list.map((e) => MemoCategory.fromJson(e)).toList();
        if (categories.isNotEmpty) selectedCategoryIndex = 0;
      });
    } else {
      categories = [
        MemoCategory(name: '医疗意愿', items: [], notes: ''),
        MemoCategory(name: '财产分配', items: [], notes: ''),
        MemoCategory(name: '遗言', items: [], notes: ''),
        MemoCategory(name: '葬礼安排', items: [], notes: ''),
      ];
      selectedCategoryIndex = 0;
      await _saveData();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(categories.map((c) => c.toJson()).toList());
    await prefs.setString('memo_categories', jsonStr);
  }

  void _addTodoItem() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加待办事项'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('添加'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty && selectedCategoryIndex != null) {
      setState(() {
        categories[selectedCategoryIndex!].items
            .add(ChecklistItem(text: result.trim()));
      });
      await _saveData();
    }
  }

  void _toggleItemDone(int itemIndex) async {
    if (selectedCategoryIndex == null) return;
    setState(() {
      final item = categories[selectedCategoryIndex!].items[itemIndex];
      item.isDone = !item.isDone;
    });
    await _saveData();
  }

  void _deleteItem(int itemIndex) async {
    if (selectedCategoryIndex == null) return;
    setState(() {
      categories[selectedCategoryIndex!].items.removeAt(itemIndex);
    });
    await _saveData();
  }

  void _editNotes() async {
    if (selectedCategoryIndex == null) return;
    final currentNotes = categories[selectedCategoryIndex!].notes;
    final controller = TextEditingController(text: currentNotes);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('编辑备注'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(hintText: '自由备注...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        categories[selectedCategoryIndex!].notes = result;
      });
      await _saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty || selectedCategoryIndex == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final category = categories[selectedCategoryIndex!];

    return Scaffold(
      appBar: AppBar(
        title: const Text('后事备忘录'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (ctx, idx) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(categories[idx].name),
                  selected: selectedCategoryIndex == idx,
                  onSelected: (selected) {
                    if (selected) setState(() => selectedCategoryIndex = idx);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('待办清单', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed: _addTodoItem, icon: const Icon(Icons.add)),
            ],
          ),
          ...category.items.asMap().entries.map((entry) {
            int idx = entry.key;
            var item = entry.value;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: CheckboxListTile(
                title: Text(item.text,
                    style: TextStyle(
                        decoration: item.isDone ? TextDecoration.lineThrough : null)),
                value: item.isDone,
                onChanged: (_) => _toggleItemDone(idx),
                secondary: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteItem(idx),
                ),
              ),
            );
          }),
          if (category.items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('暂无待办事项，点击 + 添加'),
            ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('备注', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed: _editNotes, icon: const Icon(Icons.edit)),
            ],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                category.notes.isEmpty ? '点击编辑按钮添加备注...' : category.notes,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}