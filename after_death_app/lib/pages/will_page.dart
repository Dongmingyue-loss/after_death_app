import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WillPage extends StatefulWidget {
  const WillPage({super.key});

  @override
  State<WillPage> createState() => _WillPageState();
}

class _WillPageState extends State<WillPage> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadWill();
  }

  Future<void> _loadWill() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('will_text');
    if (saved != null) {
      _controller.text = saved;
    } else {
      _controller.text = '''
遗嘱

本人，[姓名]，身份证号[号码]，在此立下遗嘱：

一、财产分配
我的全部财产（包括但不限于房产、存款、车辆等）按以下方式分配：
1. [分配方案]

二、后事安排
请按照我在“后事备忘录”中的意愿处理。

三、其他
本遗嘱为最终版本，此前所有口头或书面遗嘱均作废。

立遗嘱人：[姓名]
日期：[年 月 日]
''';
    }
    setState(() {});
  }

  Future<void> _saveWill() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('will_text', _controller.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('遗嘱已保存')),
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('遗嘱模板'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveWill,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isEditing
            ? TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '编辑遗嘱内容...',
                ),
              )
            : SingleChildScrollView(
                child: SelectableText(
                  _controller.text,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
      ),
    );
  }
}