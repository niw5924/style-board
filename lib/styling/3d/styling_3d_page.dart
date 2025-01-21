import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class Styling3DPage extends StatefulWidget {
  const Styling3DPage({super.key});

  @override
  _Styling3DPageState createState() => _Styling3DPageState();
}

class _Styling3DPageState extends State<Styling3DPage> {
  late UnityWidgetController _unityWidgetController;
  double _rotationSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Styling Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: UnityWidget(
              onUnityCreated: _onUnityCreated,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Adjust Rotation Speed',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _rotationSpeed,
                  min: 0.1,
                  max: 5.0,
                  divisions: 49,
                  label: _rotationSpeed.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _rotationSpeed = value;
                    });
                    _sendRotationSpeedToUnity(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Unity 위젯이 생성될 때 호출
  void _onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }

  /// Unity로 회전 속도 전달
  void _sendRotationSpeedToUnity(double speed) {
    _unityWidgetController.postMessage(
      'Cube', // Unity의 오브젝트 이름
      'SetRotationSpeed', // Unity에서 처리할 메서드 이름
      speed.toString(), // 회전 속도 값
    );
    print('Unity로 회전 속도 전송: $speed');
  }
}
