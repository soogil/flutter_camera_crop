import 'package:camera/camera.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();

  factory CameraService() {
    return _instance;
  }

  CameraService._internal();

  init() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras.first, ResolutionPreset.medium);

    _initCamera = _cameraController.initialize();
    print('camera init');
  }

  List<CameraDescription> _cameras;
  CameraController _cameraController;
  Future _initCamera;

  Future get initCamera => _initCamera;
  CameraController get cameraController => _cameraController;
}
