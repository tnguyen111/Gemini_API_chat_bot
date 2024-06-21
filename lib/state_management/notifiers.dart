import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageNotifier extends Notifier<int> {

  @override
  int build() {
    return 0;
  }

  int messageAwait() {
    state = 0;
    return state;
  }

  int messageSending() {
    state = 1;
    return state;
  }

  int messageSent(){
    state = 2;
    return state;
  }

  int messageReset(){
    state = 3;
    return state;
  }

}
