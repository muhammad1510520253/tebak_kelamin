import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _namaController = TextEditingController();
  final String faseLoading = "faseLoading";
  final String faseDone = "faseDone";
  String fase = "";

  String? nama;
  String? jenisKelamin;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Tebak Jenis Kelamin",
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _search(context),
              fase == ""
                  ? Container()
                  : fase == faseLoading
                      ? Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const CircularProgressIndicator())
                      : _jenisKelamin()
            ],
          ),
        ),
      ),
    );
  }

  Widget _search(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      color: const Color(0xFFEEEEEE),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5)),
                ),
                child: TextFormField(
                    controller: _namaController,
                    focusNode: FocusNode(canRequestFocus: false),
                    onSaved: (val) {},
                    cursorColor: Theme.of(context).colorScheme.primary,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan nama',
                      hintStyle:
                          TextStyle(fontSize: 16.0, color: Color(0xFFcccccc)),
                      errorStyle: TextStyle(height: 0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                    style:
                        const TextStyle(color: Colors.black, fontSize: 16.0)),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_namaController.text != "") {
                  tebakJenisKelamin();
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  setFase("");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Nama belum diisi"),
                  ));
                }
              },
              child: Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(3),
                            topRight: Radius.circular(3))),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _jenisKelamin() {
    if (jenisKelamin != null) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              jenisKelamin == "male" ? "Laki-laki" : "Perempuan",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Icon(
              jenisKelamin == "male" ? Icons.male : Icons.female,
              color: jenisKelamin == "male" ? Colors.blue : Colors.pink,
              size: 100,
            ),
          ],
        ),
      );
    }

    return Container();
  }

  tebakJenisKelamin() async {
    setFase(faseLoading);
    var url =
        Uri.parse('https://api.genderize.io/?name=${_namaController.text}');
    var response = await http.get(url);
    var body = json.decode(response.body);
    setState(() {
      jenisKelamin = '${body['gender']}';
      setFase(faseDone);
    });
  }

  setFase(String fase) {
    setState(() {
      this.fase = fase;
    });
  }
}
