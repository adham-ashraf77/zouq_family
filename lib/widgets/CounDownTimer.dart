import 'package:flutter/material.dart';

class CounDownTimer extends StatefulWidget {
  final int remainingTime;

  CounDownTimer({this.remainingTime});
  @override
  _CounDownTimerState createState() => _CounDownTimerState();
}

class _CounDownTimerState extends State<CounDownTimer>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("remaining time is : ${widget.remainingTime}");

    controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds: widget.remainingTime == null
                ? 500
                : widget
                    .remainingTime) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Countdown(
          animation: StepTween(
            begin: widget.remainingTime == null ? 500 : widget.remainingTime,
            end: 0,
          ).animate(controller),
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print(
        'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');

    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
