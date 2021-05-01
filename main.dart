import 'dart:convert';
import 'dart:io';

import 'package:dartssh/client.dart';
import 'package:dartssh/identity.dart';
import 'package:dartssh/ssh.dart';

void main(List<String> args) {
  final servers = List<Map>.from(jsonDecode(stdin.readLineSync()));
  final connections = servers.map<dynamic>((e) => [
        e,
        SSHClient(
          hostport: parseUri(e['host']),
          login: e['user'],
          print: print,
          debugPrint: null,
          tracePrint: null,
          getPassword: () => utf8.encode(e['pass']),
          startShell: true,
          termWidth: 80,
          termHeight: 25,
          success: null,
          disconnected: null,
          agentForwarding: false,
          termvar: 'xterm',
          loadIdentity: () => Identity(),
        )
      ]);
  for (final conn in connections) {
    conn[1].sendChannelData(utf8.encode(conn[0]['cmd'] + '\n'));
  }
}
