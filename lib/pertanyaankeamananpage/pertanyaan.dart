import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/svg.dart';

class Pertanyaan extends StatefulWidget {
  const Pertanyaan({Key? key}) : super(key: key);

  @override
  State<Pertanyaan> createState() => _PertanyaanState();
}

class _PertanyaanState extends State<Pertanyaan> {
  String? _pertanyaan;
  List listp = [
    'Siapa nama Ibumu?',
    'Siapa nama Gurumu waktu SD?',
    'Siapa nama hewan peliharaanmu?',
    'Apa tim olahraga favoritmu?'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Pertanyaan Keamanan',
            style: TextStyle(
              color: Color.fromRGBO(53, 80, 112, 1),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Pilih Pertanyaan',
                      ),
                    ),
                  ],
                ),
                icon: SvgPicture.asset(
                  'assets/svg/arrow_down.svg'),
                buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                items: listp
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                value: _pertanyaan,
                onChanged: (value) {
                  setState(() {
                    _pertanyaan = value as String;
                  });
                },
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffA8A8A8)),
                ),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xffA8A8A8)),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Jawab"),
            ),
            const SizedBox(
              height: 100,
            ),
            buildButton()
          ],
        ),
      ),
    );
  }

  buildButton() {
    return RawMaterialButton(
      onPressed: () {
        //Navigator.push(context,PinBaruscreen.route());
      },
      fillColor: const Color.fromRGBO(53, 80, 112, 1),
      constraints: const BoxConstraints(minHeight: 49, minWidth: 128),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      child: const Text('Simpan'),
    );
  }
}