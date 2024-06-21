import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_responsive_gemini_image_chat/ai/ai.dart';
import 'notifiers.dart';

final messageProvider = NotifierProvider<MessageNotifier, int>(() {
  return MessageNotifier();
});

int messageWatchState(WidgetRef ref){
  return ref.watch(messageProvider);
}

void messageSetState(WidgetRef ref, int state){
  if(state == 0){
    ref.read(messageProvider.notifier).messageAwait();
    return;
  }

  if(state == 1){
    ref.read(messageProvider.notifier).messageSending();
    return;
  }

  if(state == 2){
    ref.read(messageProvider.notifier).messageSent();
    messageSetState(ref, 0);
    return;
  }

  if(state == 3){
    clearHistory();
    ref.read(messageProvider.notifier).messageReset();
    messageSetState(ref, 0);
  }

  return;
}
