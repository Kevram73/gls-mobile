import 'package:pusher_client/pusher_client.dart';

class PusherService {
  late PusherClient pusher;
  late Channel chatChannel;

  PusherService() {
    pusher = PusherClient(
      'b28dffd574565dc8344d',
      PusherOptions(
        cluster: 'mt1',
        encrypted: true,
      ),
      autoConnect: true,
    );
    }

  void connect(int conversationId) {
    pusher.connect();
    chatChannel = pusher.subscribe("chat.$conversationId");

    chatChannel.bind('message.sent', (event) {
      print(event?.data);
    });
  }

  void disconnect() {
    pusher.unsubscribe("chat");
    pusher.disconnect();
  }

}