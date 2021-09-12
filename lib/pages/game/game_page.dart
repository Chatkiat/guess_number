import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guess_number/pages/game/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Game _game;
  final _controller = TextEditingController();
  String? _guessNumber;
  String? _feedback;
  String txt = 'I\'m thinking of number ';
  String txt0 = 'between 1 and 100';
  String txt1 = 'Can you guess it?';
  bool newGame = false;

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.pressStart2p(fontSize: 16),
          ),
          content: Text(
            msg,
            style: GoogleFonts.pressStart2p(fontSize: 10),
          ),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _game = Game();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GUESS THE NUMBER', style: GoogleFonts.pressStart2p()),
      ),
      body: Container(
          // color: Colors.grey,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeader(),
                  _buildMainContent(),
                  _buildInputPanel(),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          'assets/images/cat.png',
          width: 200,
          height: 200,
        ),
        Text(
          'GUESS THE NUMBER',
          style: GoogleFonts.pressStart2p(fontSize: 22),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return _guessNumber == null
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(txt, style: GoogleFonts.pressStart2p(fontSize: 15.0)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(txt0, style: GoogleFonts.pressStart2p(fontSize: 15.0)),
              ),
              Text(txt1, style: GoogleFonts.pressStart2p(fontSize: 15.0)),
            ],
          )
        //? SizedBox.shrink()
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_guessNumber!,
                    style: GoogleFonts.pressStart2p(
                        fontSize: 40, color: Colors.black)),
              ),
              Text(_feedback!, style: GoogleFonts.pressStart2p(fontSize: 20)),
              if (newGame)
                TextButton(
                    onPressed: () {
                      setState(() {
                        _game = Game();
                        newGame = false;
                        _guessNumber= null;
                        _feedback = null;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          //borderRadius: BorderRadius.circular(.0),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2.0, 2.0),
                              color: Colors.lightBlueAccent,
                              spreadRadius: 3,
                              blurRadius: 5.0,
                            )
                          ],

                          border: Border.all(width: 1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'NEW GAME',
                            style: GoogleFonts.pressStart2p(
                                fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    )),
            ],
          );
  }

  Widget _buildInputPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(5.0, 5.0),
            color: Colors.black,
            spreadRadius: 3,
            blurRadius: 5.0,
          )
        ],
        border: Border.all(width: 4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontFamily: 'PressStart2p',
                color: Colors.yellow,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                isDense: true,
                // กำหนดลักษณะเส้น border ของ TextField ในสถานะปกติ
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                // กำหนดลักษณะเส้น border ของ TextField เมื่อได้รับโฟกัส
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: 'Enter the number here',
                hintStyle: TextStyle(
                  fontFamily: 'PressStart2p',
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16.0,
                ),
              ),
            )),
            TextButton(
              onPressed: () {
                setState(() {
                  _guessNumber = _controller.text;
                  int? guess = int.tryParse(_guessNumber!);
                  if (guess != null) {
                    var result = _game.doGuess(guess);
                    var total = _game.totalGuesses;
                    if (result == 0) {
                      //ทายถูก
                      newGame = true;
                      _feedback = 'CORRECT!';
                      _showMaterialDialog('GOOD JOB',
                          'The answer is $_guessNumber\n\nYou have made $total guesses.\n\n=> ${_game.numlist}, ');
                      _controller.clear();
                    } else if (result == 1) {
                      //ทายมากไป
                      _feedback = 'TOO HIGH!';
                      _controller.clear();
                    } else {
                      //ทายน้อยไป
                      _feedback = 'TOO LOW!';
                      _controller.clear();
                    }
                  } else {
                    _feedback = '';
                   _showMaterialDialog('Error', 'Please enter the number');
                    _controller.clear();
                    newGame = false;
                  }
                }
                );
              },
              child: Text(' GUESS',
                  style: GoogleFonts.pressStart2p(
                      fontSize: 12, color: Colors.black)),

            )
          ],
        ),
      ),
    );
  }
}
