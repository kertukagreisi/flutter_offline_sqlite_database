import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:offline/service/sqlite_service.dart';

import 'model/Number.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline App"),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity,
            Widget child,) {
          final bool connected = connectivity != ConnectivityResult.none;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                height: 24.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: connected
                      ? const Color(0xFF00EE44)
                      : const Color(0xFFEE4400),
                  child: Center(
                    child: Text(connected ? 'ONLINE' : 'OFFLINE'),
                  ),
                ),
              ),
              Center(
                child: connected
                    ? Center(
                    child: Text(numbers.isEmpty
                        ? 'No numbers saved offline!'
                        : 'Last saved number when tha application was offline: \n'
                        '${numbers[numbers.length - 1].number}!'))
                    : Column(
                  children: [
                    Expanded(
                      child: numbers.isEmpty
                          ? const Center(
                        child: Text(
                          'Empty',
                        ),
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: numbers.length,
                        itemBuilder: (build, index) =>
                            ListTile(
                              title: Text(
                                  'Number ${numbers[index].number}'),
                              subtitle:
                              Text('ID: (${numbers[index].id})'),
                              leading: Text('${index + 1}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_forever),
                                onPressed: () async {
                                  await _deleteNumber(
                                      numbers[index].id);
                                },
                              ),
                            ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: const Text('Get all numbers'),
                            onPressed: () async {
                              await _getNumbers();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            child: const Text('Add'),
                            onPressed: () async {
                              await _insertNumber();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        builder: (BuildContext context) {
          return const SizedBox();
        },
      ),
    );
  }

  List<Number> numbers = [];

  _getNumbers() async {
    log('Get all numbers from database');
    List<Number>? allNumbers = await SqliteService.getNumbers();
    setState(() {
      numbers = allNumbers;
    });
  }

  _insertNumber() async {
    log('Insert a number in the database');
    int number;
    if (numbers.isEmpty) {
      number = 1;
    } else {
      number = numbers[numbers.length - 1].number + 1;
    }
    await SqliteService.insertNumber(number);
    _getNumbers();
  }

  _deleteNumber(String id) async {
    log('Delete a number from the database');
    await SqliteService.deleteNumber(id);
    _getNumbers();
  }

  _updateNumber(Number number) async {
    log('Update a number in the database');
    await SqliteService.updateNumber(number);
    _getNumbers();
  }
}
