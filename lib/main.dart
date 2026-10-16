import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ENUM: типы пар
enum LessonType { lecture, practice, lab }

// EXTENSION
extension LessonTypeX on LessonType {
  String get text {
    switch (this) {
      case LessonType.lecture:
        return 'Лекция';
      case LessonType.practice:
        return 'Практика';
      case LessonType.lab:
        return 'Лабораторная';
    }
  }
}

// КЛАСС: одна пара
class Lesson {
  final String subject;
  final String building;
  final LessonType type;
  int room;

  Lesson({
    required this.subject,
    required this.building,
    required this.type,
    this.room = 0,
  });

  void setRoom(int value) {
    room = value;
  }

  @override
  String toString() =>
      '$subject (${type.text}) — $building, ауд. $room';
}

// EXTENSION (список пар в текст)
extension LessonListText on List<Lesson> {
  String toText() {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.writeln('${i + 1}. ${this[i]}');
    }
    return buffer.toString().trimRight();
  }
}

// GENERIC
T? firstOrNull<T>(List<T> items) {
  return items.isEmpty ? null : items.first;
}

// GENERIC (самый частый элемент в списке)
T? mostFrequent<T>(List<T> items) {
  if (items.isEmpty) return null;

  final Map<T, int> counts = {};
  for (final item in items) {
    counts[item] = (counts[item] ?? 0) + 1;
  }

  T? best;
  int bestCount = 0;
  counts.forEach((item, count) {
    if (count > bestCount) {
      bestCount = count;
      best = item;
    }
  });

  return best;
}

// FUTURE (загрузка)
Future<String> loadStatus() async {
  await Future.delayed(const Duration(milliseconds: 600));
  return 'Расписание загружено';
}

// Генератор случайной пары
Lesson makeRandomLesson() {
  final random = Random();
  final subjects = ['Математика', 'Программирование', 'История', 'Физика',
    'Английский язык', 'Базы данных', 'ООП', 'Философия'];
  final buildings = ['Корпус 1', 'Корпус 2', 'Корпус 3', 'Корпус 4', 'Корпус 5',
    'Корпус 6', 'Корпус 7', 'Корпус 8', 'Корпус 9', 'Корпус 10', 'ДОТ'];
  final types = LessonType.values;

  return Lesson(
    subject: subjects[random.nextInt(subjects.length)],
    building: buildings[random.nextInt(buildings.length)],
    type: types[random.nextInt(types.length)],
    room: 101 + random.nextInt(825 - 101 + 1),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Халимов Альберт МОАИСбд-31'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color _color = Colors.orangeAccent;
  String _status = 'Загрузка...';

  final List<Lesson> lessons = <Lesson>[
    Lesson(
      subject: 'Математика',
      building: 'Корпус 1',
      type: LessonType.lecture,
      room: 301,
    ),
    Lesson(
      subject: 'Программирование',
      building: 'Корпус 2',
      type: LessonType.lab,
      room: 204,
    ),
    Lesson(
      subject: 'История',
      building: 'Корпус 3',
      type: LessonType.practice,
      room: 105,
    ),
  ];

  @override
  void initState() {
    super.initState();

    loadStatus().then((value) {
      if (!mounted) return;
      setState(() {
        _status = value;
      });
    });
  }

  // Плюсик :>
  void _incrementCounter() {
    setState(() {
      lessons.add(makeRandomLesson());
      _color = Color((Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Lesson? first = firstOrNull(lessons);

    // Самый частый предмет через generics
    final String? favorite = mostFrequent(
      lessons.map((lesson) => lesson.subject).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Расписание',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Text('Статус: $_status'),
              Text('Создано пар: ${lessons.length}'),
              Text('Самый частый предмет: ${favorite ?? "—"}'),
              if (first != null) Text('Первая пара: $first'),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(lessons.toText(), textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        backgroundColor: _color,
        tooltip: 'Создать пару',
        child: const Icon(Icons.add),
      ),
    );
  }
}