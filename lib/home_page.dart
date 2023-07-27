import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import 'cats_facts_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> list = [];
  final translator = GoogleTranslator();
SharedPreferences? prefs;

void initPage() async {
  prefs = await SharedPreferences.getInstance();
}

  @override

  void initState() {
 super.initState();
    initPage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Cats Facts',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              list[index].toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () async {
                                    await translator
                                    .translate(
                                      list?[index]??'',
                                       to: 'ru',).then((value) {
                                        list?[index]= value.toString();
                                  },
                                  ); 
                                  setState(() {});},
                                  child: const Text('Ru'),
                                ),const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () async {
                                    await translator
                                  .translate(
                                    list?[index]??'', 
                                    to: 'en',)
                                    .then(
                                      (value) {
                                        list?[index]= value.toString();
                                  },
                                  ); 
                                  setState(() {});},
                                  child: const Text('En'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: getCatsFacts,
                  child: const Icon(Icons.add),
                ), 
                ElevatedButton(
                  onPressed: () {
                    list.removeLast();
                    setState(() {});
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  getCatsFacts() async {
    final dio = Dio();
    final response = await dio.get('https://catfact.ninja/fact');
    final result = CatsFactsModel.fromJson(response.data);
    list.add(result.fact ?? '');
    prefs?.setStringList('catsFacts', list);

    print(prefs?.getStringList('catsFacts'));
    setState(() {});
  }
}
