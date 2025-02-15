import 'dart:async';
import 'package:multicast_dns/multicast_dns.dart';

class DeviceDiscoveryService {
  final MDnsClient _mdns = MDnsClient();
  StreamSubscription<PtrResourceRecord>? _subscription;
  final List<String> _discoveredDevices = [];

  // Start device discovery
  Future<void> startDiscovery(Function(List<String>) onUpdate) async {
    await _mdns.start();
    _subscription = _mdns
        .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer("_flydrop._tcp.local"))
        .listen((PtrResourceRecord ptr) {
      _discoveredDevices.add(ptr.domainName);
      onUpdate(_discoveredDevices);
    });
  }

  // Stop device discovery
  void stopDiscovery() {
    _subscription?.cancel();
    _mdns.stop();
  }
}