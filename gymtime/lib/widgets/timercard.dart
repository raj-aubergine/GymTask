import 'dart:async';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/provider.dart';
import '../models/exercise.dart';

class TimerCard extends StatefulWidget {
  const TimerCard({
    required this.exercise,
    Key? key,
  }) : super(key: key);
  final Exercise exercise;

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  Duration duration = const Duration();
  Timer? timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reset();
  }

  void reset() {
    print('done');
    timer?.cancel();

    setState(() {
      Duration downduration = Duration(seconds: widget.exercise.time ?? 0);
      duration = downduration;
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    } else {
      setState(() {
        timer?.cancel();
      });
    }
  }

  void removeTime() async {
    var flagProvider = Provider.of<Flag>(context, listen: false);
    const removesecond = -1;
    final seconds = duration.inSeconds + removesecond;
    setState(() {
      duration = Duration(seconds: seconds);
    });

    if (seconds <= 0) {
      timer?.cancel();
      flagProvider.setFlag(true);
      final snackBar = SnackBar(
        content: const Text('Exercise Completed'),
        backgroundColor: (Colors.black),
        action: SnackBarAction(
          label: 'dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Duration downduration = Duration(seconds: widget.exercise.time ?? 0);
      duration = downduration;
      //setState(() {});
    } else {
      duration = Duration(seconds: seconds);
    }
  }

  void startCountDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => removeTime());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = timer == null ? false : timer!.isActive;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        color: Colors.grey[400],
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.exercise.name ?? '',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('${duration.inSeconds} ',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: Text('${widget.exercise.time} Sec',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BuildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildButtons(BuildContext context) {
    final isRunning = timer == null ? false : timer!.isActive;

    return Consumer<Flag>(builder: (context, provider, child) {
      return isRunning
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      stopTimer(resets: false);
                      provider.setFlag(true);
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'PAUSE',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    )))),
                ElevatedButton(
                    onPressed: () {
                      stopTimer(resets: true);
                      provider.setFlag(true);
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        'RESET',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ))))
              ],
            )
          : ElevatedButton(
              onPressed: () {
                if (provider.flag) {
                  startCountDown();
                  provider.setFlag(false);
                } else {
                  final snackBar = SnackBar(
                    duration: Duration(milliseconds: 500),
                    content: const Text('Oops another timer is runnig'),
                    backgroundColor: (Colors.black87),
                    action: SnackBarAction(
                      label: 'dismiss',
                      onPressed: () {},
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'START',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ))));
    });
  }
}
