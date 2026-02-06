import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    final url = "http://10.0.2.2:8000/translations/quran_en";

    Future<String> makeCall() async {
      final response = await http.get(Uri.parse(url));
      return response.body;
    }

    return Scaffold(
      // appBar: const CustomAppBar(title: "تجريب", center: true, profile: false),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder(
            future: makeCall(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator.adaptive();
              }
                
              if (snapshot.hasError) {
                return const Text("حدث خطأ اثناء جلب البيانات");
              }
                
              return Text(snapshot.data.toString());
            },
          ),
        ),
      ),
    );
  }
}
