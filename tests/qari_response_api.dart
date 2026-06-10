import 'package:dio/dio.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

final Dio dio = Dio();

const String qariUri = "https://server11.mp3quran.net/hazza/";

void main(List<String> args) async {
  final response = await dio.get(qariUri);

  final dom.Document document = parser.parse(response.data);

  final List<dom.Element> elements = document.querySelectorAll('a');

  final List<String> readerNames = elements.map((e) => e.text.trim()).toList();

  final int length = readerNames.length;

  print("عدد العناصر المكتشفة: $length");
}
