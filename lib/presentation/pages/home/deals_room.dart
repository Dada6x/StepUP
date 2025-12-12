import 'dart:math';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:camera/camera.dart';

// If you have these in your project, keep them.
// If not, remove and replace AppTheme.cardDark with a Color.
import 'package:kyc_test/core/constants/themes/app_theme.dart';

const _cardColor = Color(0xFF042A2B);
const _accentGold = Color(0xFFF0EAE0);
const _accentGreen = Color(0xFF10B981);
const _accentRed = Color(0xFFEF4444);

Future<void> main() async {
  // ✅ REQUIRED for camera plugin
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const DealRoom(),
    );
  }
}

/// ===============================
/// DealRoom (HOME widget)
/// ===============================
class DealRoom extends StatefulWidget {
  const DealRoom({super.key});

  @override
  State<DealRoom> createState() => _DealRoomState();
}

class _DealRoomState extends State<DealRoom> with TickerProviderStateMixin {
  bool _isLoading = true;

  // ✅ Static store + static data (seeded once)
  static final DealRoomStore _store = DealRoomStore();
  static final DealRoomData _data = _store.seed();

  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);

    // fake load
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _openChatRoom(DealRoomModel room) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoom(room: room, data: _data, store: _store),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Deals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: _accentGold,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'People'),
            Tab(text: 'Rooms'),
          ],
        ),
      ),
      body: Skeletonizer(
        enabled: _isLoading,
        ignorePointers: true,
        effect: const ShimmerEffect(
          baseColor: Color(0xFF032A2A),
          highlightColor: Color(0xFF064E4E),
        ),
        containersColor: const Color(0xFF032A2A),
        child: TabBarView(
          controller: _tab,
          children: [
            _PeopleTab(
              people: _data.people,
              onSelect: (_) {
                if (_data.rooms.isNotEmpty) _openChatRoom(_data.rooms.first);
              },
              onAddInvestor: () {},
              onAddStartup: () {},
            ),
            _RoomsTab(
              rooms: _data.rooms,
              people: _data.people,
              onCreateRoom: () {},
              onOpenRoom: _openChatRoom,
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// ChatRoom Screen (your UI)
/// ===============================
class ChatRoom extends StatefulWidget {
  final DealRoomModel room;
  final DealRoomData data;
  final DealRoomStore store;

  const ChatRoom({
    super.key,
    required this.room,
    required this.data,
    required this.store,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver {
  final _textCtrl = TextEditingController();

  bool _videoExpanded = true;
  bool _micOn = true;
  bool _camOn = true;

  List<CameraDescription> _cameras = [];
  CameraController? _cameraCtrl;
  bool _cameraReady = false;
  bool _cameraDeniedOrFailed = false;

  bool _initializingCamera = false;
  String? _cameraErrorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCameraIfNeeded();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textCtrl.dispose();
    _disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // camera plugin needs correct lifecycle handling
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      _initCameraIfNeeded();
    }
  }

  Future<void> _initCameraIfNeeded() async {
    if (!_videoExpanded || !_camOn) return;
    await _initCamera();
  }

  Future<void> _initCamera() async {
    if (_initializingCamera) return;
    _initializingCamera = true;

    try {
      _cameraErrorText = null;

      // ✅ Dispose old controller first to avoid "camera already in use"
      await _disposeCamera();

      if (!mounted) return;
      setState(() {
        _cameraDeniedOrFailed = false;
        _cameraReady = false;
      });

      final cams = await availableCameras();
      if (!mounted) return;

      if (cams.isEmpty) {
        setState(() {
          _cameraDeniedOrFailed = true;
          _cameraReady = false;
          _cameraErrorText = 'No cameras found on device.';
        });
        return;
      }

      _cameras = cams;

      // ✅ Prefer front camera for "You"
      final selected = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cams.first,
      );

      final ctrl = CameraController(
        selected,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420, // helps on some Androids
      );

      _cameraCtrl = ctrl;

      await ctrl.initialize();

      if (!mounted) return;
      setState(() {
        _cameraReady = true;
        _cameraDeniedOrFailed = false;
      });
    } catch (e, st) {
      // ✅ Show real error in logs + UI
      debugPrint('CAMERA INIT ERROR: $e');
      debugPrint('$st');

      if (!mounted) return;
      setState(() {
        _cameraDeniedOrFailed = true;
        _cameraReady = false;
        _cameraErrorText = e.toString();
      });
    } finally {
      _initializingCamera = false;
    }
  }

  Future<void> _disposeCamera() async {
    final ctrl = _cameraCtrl;
    _cameraCtrl = null;

    if (ctrl != null) {
      try {
        await ctrl.dispose();
      } catch (_) {}
    }

    if (mounted) {
      setState(() => _cameraReady = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = widget.room;

    final roomMessages =
        widget.data.messages.where((m) => m.roomId == room.id).toList()
          ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

    return Scaffold(
      backgroundColor: AppTheme.cardDark, // or Colors.black
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              room.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (room.topic.isNotEmpty)
              Text(
                room.topic,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: _DarkCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.video_call, color: Colors.white70),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Video Call (view only)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: _videoExpanded ? 'Collapse' : 'Expand',
                        onPressed: () async {
                          setState(() => _videoExpanded = !_videoExpanded);
                          if (_videoExpanded && _camOn) {
                            await _initCamera();
                          } else {
                            await _disposeCamera();
                          }
                        },
                        icon: AnimatedRotation(
                          duration: const Duration(milliseconds: 180),
                          turns: _videoExpanded ? 0.0 : 0.5,
                          child: const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: _videoExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Column(
                      children: [
                        _VideoCallGridWithOneRealCamera(
                          room: room,
                          people: widget.data.people,
                          camOn: _camOn,
                          camReady: _cameraReady,
                          camFailed: _cameraDeniedOrFailed,
                          camErrorText: _cameraErrorText,
                          camCtrl: _cameraCtrl,
                        ),
                        const SizedBox(height: 12),
                        _VideoControls(
                          micOn: _micOn,
                          camOn: _camOn,
                          onToggleMic: () => setState(() => _micOn = !_micOn),
                          onToggleCam: () async {
                            setState(() => _camOn = !_camOn);
                            if (_camOn && _videoExpanded) {
                              await _initCamera();
                            } else {
                              await _disposeCamera();
                            }
                          },
                          onEnd: () async {
                            setState(() {
                              _videoExpanded = false;
                              _micOn = false;
                              _camOn = false;
                            });
                            await _disposeCamera();
                          },
                        ),
                      ],
                    ),
                    secondChild: const SizedBox(height: 8),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _DarkCard(
                child: roomMessages.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet — start the deal chat.',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: roomMessages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final m = roomMessages[i];
                          final sender = widget.data.people.firstWhere(
                            (p) => p.id == m.senderId,
                            orElse: () => PersonModel.unknown(m.senderId),
                          );
                          return _MessageBubble(message: m, sender: sender);
                        },
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: _Composer(
              controller: _textCtrl,
              onSend: () {
                final text = _textCtrl.text.trim();
                if (text.isEmpty) return;

                final me = widget.data.people.firstWhere(
                  (p) => p.type == PersonType.startup,
                  orElse: () => widget.data.people.first,
                );

                setState(() {
                  widget.store.sendMessage(widget.data, room.id, me, text);
                });
                _textCtrl.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// Tabs
/// ===============================
class _PeopleTab extends StatelessWidget {
  final List<PersonModel> people;
  final VoidCallback onAddInvestor;
  final VoidCallback onAddStartup;
  final ValueChanged<PersonModel> onSelect;

  const _PeopleTab({
    required this.people,
    required this.onAddInvestor,
    required this.onAddStartup,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final investors = people
        .where((p) => p.type == PersonType.investor)
        .toList();
    final startups = people.where((p) => p.type == PersonType.startup).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderRow(title: 'People', action: ''),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _PrimaryButton(
                        label: 'Add Investor',
                        icon: Icons.person_add_alt_1,
                        onTap: onAddInvestor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PrimaryButton(
                        label: 'Add Startup',
                        icon: Icons.apartment,
                        onTap: onAddStartup,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: 'Investors (${investors.length})'),
                const SizedBox(height: 10),
                ...investors.map(
                  (p) => _PersonTile(person: p, onTap: () => onSelect(p)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: 'Startups (${startups.length})'),
                const SizedBox(height: 10),
                ...startups.map(
                  (p) => _PersonTile(person: p, onTap: () => onSelect(p)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomsTab extends StatelessWidget {
  final List<DealRoomModel> rooms;
  final List<PersonModel> people;
  final VoidCallback onCreateRoom;
  final ValueChanged<DealRoomModel> onOpenRoom;

  const _RoomsTab({
    required this.rooms,
    required this.people,
    required this.onCreateRoom,
    required this.onOpenRoom,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeaderRow(title: 'Deal Rooms', action: ''),
                const SizedBox(height: 12),
                _PrimaryButton(
                  label: 'Create a Deal Room',
                  icon: Icons.meeting_room,
                  onTap: onCreateRoom,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DarkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle(title: 'Rooms (${rooms.length})'),
                const SizedBox(height: 10),
                ...rooms.map((r) {
                  final names = r.participantIds
                      .map(
                        (id) =>
                            people
                                .where((p) => p.id == id)
                                .map((p) => p.name)
                                .firstOrNull ??
                            '—',
                      )
                      .take(3)
                      .join(', ');
                  return _RoomTile(
                    room: r,
                    subtitle: names.isEmpty ? 'No participants' : names,
                    onTap: () => onOpenRoom(r),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// Video Call grid bits
/// ===============================
class _VideoCallGridWithOneRealCamera extends StatelessWidget {
  final DealRoomModel room;
  final List<PersonModel> people;

  final bool camOn;
  final bool camReady;
  final bool camFailed;
  final String? camErrorText;
  final CameraController? camCtrl;

  const _VideoCallGridWithOneRealCamera({
    required this.room,
    required this.people,
    required this.camOn,
    required this.camReady,
    required this.camFailed,
    required this.camErrorText,
    required this.camCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final participants = people
        .where((p) => room.participantIds.contains(p.id))
        .toList();
    final tiles = participants.take(4).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(10),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(tiles.length, (i) {
            if (i == 0) {
              return _RealCameraTile(
                title: '(You)',
                camOn: camOn,
                camReady: camReady,
                camFailed: camFailed,
                camErrorText: camErrorText,
                camCtrl: camCtrl,
              );
            }
            return _MockVideoTile(person: tiles[i]);
          }),
        ),
      ),
    );
  }
}

class _RealCameraTile extends StatelessWidget {
  final String title;
  final bool camOn;
  final bool camReady;
  final bool camFailed;
  final String? camErrorText;
  final CameraController? camCtrl;

  const _RealCameraTile({
    required this.title,
    required this.camOn,
    required this.camReady,
    required this.camFailed,
    required this.camErrorText,
    required this.camCtrl,
  });

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (camOn) {
      body = Center(
        child: Text(
          'Camera is off',
          style: TextStyle(color: Colors.grey[300], fontSize: 12),
        ),
      );
    } else if (camFailed) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            camErrorText?.isNotEmpty == true
                ? 'Camera failed:\n$camErrorText'
                : 'Camera permission / init failed',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[300], fontSize: 11),
          ),
        ),
      );
    } else if (!camReady || camCtrl == null) {
      body = Center(
        child: Text(
          'Starting camera…',
          style: TextStyle(color: Colors.grey[300], fontSize: 12),
        ),
      );
    } else {
      body = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: camCtrl!.value.previewSize?.height ?? 300,
            height: camCtrl!.value.previewSize?.width ?? 200,
            child: CameraPreview(camCtrl!),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentGold.withOpacity(0.35)),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: body),
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockVideoTile extends StatelessWidget {
  final PersonModel person;
  const _MockVideoTile({required this.person});

  @override
  Widget build(BuildContext context) {
    final accent = person.type == PersonType.investor
        ? _accentGreen
        : _accentGold;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.videocam,
              color: Colors.white.withOpacity(0.10),
              size: 44,
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                person.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.30),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(
                Icons.mic,
                size: 14,
                color: Colors.white.withOpacity(0.80),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoControls extends StatelessWidget {
  final bool micOn;
  final bool camOn;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleCam;
  final VoidCallback onEnd;

  const _VideoControls({
    required this.micOn,
    required this.camOn,
    required this.onToggleMic,
    required this.onToggleCam,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ControlButton(
            icon: micOn ? Icons.mic : Icons.mic_off,
            label: micOn ? 'Mic' : 'Muted',
            onTap: onToggleMic,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ControlButton(
            icon: camOn ? Icons.videocam : Icons.videocam_off,
            label: camOn ? 'Cam' : 'Off',
            onTap: onToggleCam,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _accentRed,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: onEnd,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call_end),
                SizedBox(width: 8),
                Text('End', style: TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.06),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// ===============================
/// Shared UI bits
/// ===============================
class _DarkCard extends StatelessWidget {
  final Widget child;
  const _DarkCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String title;
  final String action;
  const _HeaderRow({required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Text(action, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: _accentGold,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  final PersonModel person;
  final VoidCallback onTap;

  const _PersonTile({required this.person, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final chipColor = person.type == PersonType.investor
        ? _accentGreen
        : _accentGold;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.08),
              child: Icon(
                person.type == PersonType.investor
                    ? Icons.person
                    : Icons.apartment,
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                person.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: chipColor.withOpacity(0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                person.type.label,
                style: TextStyle(
                  color: chipColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _RoomTile extends StatelessWidget {
  final DealRoomModel room;
  final String subtitle;
  final VoidCallback onTap;

  const _RoomTile({
    required this.room,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.meeting_room, color: Colors.white70),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _Composer({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type a message…',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none,
              ),
              minLines: 1,
              maxLines: 4,
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _accentGold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: onSend,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final PersonModel sender;

  const _MessageBubble({required this.message, required this.sender});

  @override
  Widget build(BuildContext context) {
    final isInvestor = sender.type == PersonType.investor;
    final border = isInvestor ? _accentGreen : _accentGold;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                sender.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                sender.type.label,
                style: TextStyle(
                  color: border,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                _fmt(message.sentAt),
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message.text,
            style: TextStyle(color: Colors.grey[200], fontSize: 13),
          ),
        ],
      ),
    );
  }

  static String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

/// ===============================
/// Models + Store
/// ===============================
class DealRoomData {
  final List<PersonModel> people;
  final List<DealRoomModel> rooms;
  final List<MessageModel> messages;

  DealRoomData({
    required this.people,
    required this.rooms,
    required this.messages,
  });
}

class DealRoomStore {
  final _rng = Random();
  String id() => '${DateTime.now().microsecondsSinceEpoch}${_rng.nextInt(999)}';

  DealRoomData seed() {
    final s1 = PersonModel(
      id: id(),
      type: PersonType.startup,
      name: 'MAM Solarbau',
    );
    final i1 = PersonModel(
      id: id(),
      type: PersonType.investor,
      name: 'Green Capital',
    );
    final i2 = PersonModel(
      id: id(),
      type: PersonType.investor,
      name: 'Syrian Angels',
    );

    final room = DealRoomModel(
      id: id(),
      name: 'Seed – MAM Solarbau',
      topic: 'SAFE • diligence • runway',
      participantIds: [s1.id, i1.id, i2.id],
    );

    final messages = <MessageModel>[
      MessageModel(
        id: id(),
        roomId: room.id,
        senderId: i1.id,
        text: 'Hey! Can you share your last 4 months MRR trend + churn?',
        sentAt: DateTime.now().subtract(const Duration(minutes: 18)),
      ),
      MessageModel(
        id: id(),
        roomId: room.id,
        senderId: s1.id,
        text: 'Sure — I’ll attach metrics + SAFE draft in this room.',
        sentAt: DateTime.now().subtract(const Duration(minutes: 14)),
      ),
    ];

    return DealRoomData(
      people: [s1, i1, i2],
      rooms: [room],
      messages: messages,
    );
  }

  void sendMessage(
    DealRoomData data,
    String roomId,
    PersonModel sender,
    String text,
  ) {
    data.messages.add(
      MessageModel(
        id: id(),
        roomId: roomId,
        senderId: sender.id,
        text: text,
        sentAt: DateTime.now(),
      ),
    );
  }
}

class DealRoomModel {
  final String id;
  final String name;
  final String topic;
  final List<String> participantIds;

  const DealRoomModel({
    required this.id,
    required this.name,
    required this.topic,
    required this.participantIds,
  });
}

enum PersonType { investor, startup }

extension on PersonType {
  String get label => this == PersonType.investor ? 'Investor' : 'Startup';
}

class PersonModel {
  final String id;
  final PersonType type;
  final String name;

  const PersonModel({required this.id, required this.type, required this.name});

  factory PersonModel.unknown(String id) =>
      PersonModel(id: id, type: PersonType.investor, name: 'Unknown');
}

class MessageModel {
  final String id;
  final String roomId;
  final String senderId;
  final String text;
  final DateTime sentAt;

  const MessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });
}
