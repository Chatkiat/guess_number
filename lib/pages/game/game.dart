import 'dart:math';

class Game {
  final int _answer;
  int _totalGuesses = 0;
  List<int> _num = [];
  Game() : _answer = Random().nextInt(100) + 1 {
    print('The answer is: $_answer');
  }
  int get totalGuesses{
     return _totalGuesses;
  }

  List get numlist {
    return _num;
  }



  int doGuess(int num) {
    _totalGuesses++;
    _num.add(num);

    if (num > _answer) {
      return 1;
    } else if (num < _answer) {
      return -1;
    } else {
      return 0;
    }
  }
}