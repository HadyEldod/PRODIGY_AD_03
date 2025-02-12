import 'dart:async';

class StopwatchController {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  final StreamController<String> _timeController = StreamController.broadcast();

  Stream<String> get timeStream => _timeController.stream;

  void start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        _timeController.add(_formattedTime());
      });
    }
  }

  void pause() {
    _stopwatch.stop();
    _timer.cancel();
  }

  void reset() {
    _stopwatch.reset();
    pause();
    _timeController.add(_formattedTime());
  }

  String _formattedTime() {
    final milliseconds = _stopwatch.elapsedMilliseconds;
    final minutes = (milliseconds ~/ 60000).toString().padLeft(2, '0');
    final seconds = ((milliseconds ~/ 1000) % 60).toString().padLeft(2, '0');
    final millis = ((milliseconds ~/ 10) % 100).toString().padLeft(2, '0');
    return "$minutes:$seconds:$millis";
  }

  void dispose() {
    _timer.cancel();
    _timeController.close();
  }
}
