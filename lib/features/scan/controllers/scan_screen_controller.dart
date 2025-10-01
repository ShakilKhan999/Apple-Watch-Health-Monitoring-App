import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:surajashray/routes/app_routes.dart';

// Resolution option model
class ResolutionOption {
  final ResolutionPreset preset;
  final String displayName;
  final String resolution;

  ResolutionOption(this.preset, this.displayName, this.resolution);
}

class ScanScreenController extends GetxController {
  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Camera-related variables
  late List<CameraDescription> _cameras;
  CameraController? _cameraController;
  final RxBool _isCameraInitialized = false.obs;
  final RxInt _selectedCameraIndex = 0.obs;

  // Resolution control
  final Rx<ResolutionPreset> _currentResolution = ResolutionPreset.medium.obs;
  final RxString _resolutionDisplayName = 'Medium'.obs;

  // Available resolution options
  final List<ResolutionOption> _availableResolutions = [
    ResolutionOption(ResolutionPreset.low, 'Low (240p)', '320x240'),
    ResolutionOption(ResolutionPreset.medium, 'Medium (480p)', '720x480'),
    ResolutionOption(ResolutionPreset.high, 'High (720p)', '1280x720'),
    ResolutionOption(
      ResolutionPreset.veryHigh,
      'Very High (1080p)',
      '1920x1080',
    ),
    ResolutionOption(
      ResolutionPreset.ultraHigh,
      'Ultra High (4K)',
      '3840x2160',
    ),
    ResolutionOption(ResolutionPreset.max, 'Maximum', 'Device Max'),
  ];

  // Reactive variables
  final RxBool _isLoading = false.obs;
  final Rx<File?> _capturedImage = Rx<File?>(null);
  final RxBool _isRearCamera = true.obs; // true for rear, false for front

  // Getters
  bool get isLoading => _isLoading.value;
  File? get capturedImage => _capturedImage.value;
  bool get isRearCamera => _isRearCamera.value;
  bool get isCameraInitialized => _isCameraInitialized.value;
  CameraController? get cameraController => _cameraController;
  ResolutionPreset get currentResolution => _currentResolution.value;
  String get resolutionDisplayName => _resolutionDisplayName.value;
  List<ResolutionOption> get availableResolutions => _availableResolutions;

  @override
  void onInit() {
    super.onInit();
    debugPrint('ScanScreenController initialized');
    _initializeCamera();
  }

  @override
  void onClose() {
    _disposeCamera();
    super.onClose();
    debugPrint('ScanScreenController disposed');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('ScanScreenController ready');
  }

  // Camera lifecycle management
  void pauseCamera() {
    if (_cameraController?.value.isInitialized == true) {
      _cameraController?.pausePreview();
      debugPrint('Camera paused');
    }
  }

  void resumeCamera() {
    if (_cameraController?.value.isInitialized == true) {
      _cameraController?.resumePreview();
      debugPrint('Camera resumed');
    }
  }

  void _disposeCamera() async {
    if (_cameraController != null) {
      await _cameraController?.dispose();
      _cameraController = null;
      _isCameraInitialized.value = false;
      debugPrint('Camera disposed');
    }
  }

  // Initialize camera
  Future<void> _initializeCamera() async {
    try {
      _setLoading(true);

      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras.isNotEmpty) {
        // Find rear camera (default) or use first available
        int rearCameraIndex = _cameras.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        );

        if (rearCameraIndex == -1) rearCameraIndex = 0;
        _selectedCameraIndex.value = rearCameraIndex;

        await _setupCamera(_selectedCameraIndex.value);
      } else {
        debugPrint('No cameras available on this device');
        _isCameraInitialized.value = false;
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      _isCameraInitialized.value = false;
      // Show user-friendly error message
      Get.snackbar(
        'Camera Error',
        'Unable to access camera. Please check permissions and try again.',
        backgroundColor: Colors.orange.withValues(alpha: 0.1),
        colorText: Colors.orange,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _setLoading(false);
    }
  }

  // Setup camera with specific index
  Future<void> _setupCamera(int cameraIndex) async {
    if (_cameras.isEmpty) return;

    try {
      // Dispose previous controller if exists
      await _cameraController?.dispose();

      // Create new controller with optimized settings
      _cameraController = CameraController(
        _cameras[cameraIndex],
        _currentResolution.value,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg, // Better compatibility
      );

      await _cameraController!.initialize();
      _isCameraInitialized.value = true;

      // Update camera direction state
      _isRearCamera.value =
          _cameras[cameraIndex].lensDirection == CameraLensDirection.back;

      // Log current resolution
      debugPrint(
        'Camera initialized successfully with resolution: ${_currentResolution.value}',
      );
      debugPrint(
        'Actual preview size: ${_cameraController!.value.previewSize}',
      );
    } catch (e) {
      debugPrint('Error setting up camera: $e');
      _isCameraInitialized.value = false;
      // Dispose controller if setup failed
      await _cameraController?.dispose();
      _cameraController = null;

      // Try fallback initialization with lower resolution
      if (_currentResolution.value != ResolutionPreset.low) {
        debugPrint('Retrying with lower resolution...');
        _currentResolution.value = ResolutionPreset.low;
        await _setupCamera(cameraIndex);
      }
    }
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  // Navigation methods
  void onBackPressed() {
    Get.back();
    debugPrint('Back button pressed from scan screen');
  }

  // Camera functionality
  void onTakePhotoPressed() async {
    try {
      _setLoading(true);

      // If camera is initialized, use camera controller
      if (_isCameraInitialized.value && _cameraController != null) {
        // Take picture using camera controller
        final XFile image = await _cameraController!.takePicture();

        _capturedImage.value = File(image.path);
        debugPrint('Photo captured using camera controller: ${image.path}');

        // Navigate to meal form screen with the captured image
        _navigateToMealForm();
      } else {
        // Fallback to image picker camera
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: _isRearCamera.value
              ? CameraDevice.rear
              : CameraDevice.front,
          maxWidth: 1800,
          maxHeight: 1800,
          imageQuality: 85,
        );

        if (image != null) {
          _capturedImage.value = File(image.path);
          debugPrint('Photo captured using image picker: ${image.path}');

          // Navigate to meal form screen with the captured image
          _navigateToMealForm();
        }
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      Get.snackbar(
        'Camera Error',
        'Failed to capture photo. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      _setLoading(false);
    }
  }

  // Gallery functionality
  void onPickFromGalleryPressed() async {
    try {
      _setLoading(true);

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        _capturedImage.value = File(image.path);
        debugPrint('Image selected from gallery: ${image.path}');

        // Navigate to meal form screen with the selected image
        _navigateToMealForm();
      }
    } catch (e) {
      debugPrint('Error selecting image from gallery: $e');
      Get.snackbar(
        'Gallery Error',
        'Failed to select image. Please try again.',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      _setLoading(false);
    }
  }

  // Switch camera (front/rear)
  void onSwitchCameraPressed() async {
    if (_cameras.length <= 1) {
      Get.snackbar(
        'Camera Switch',
        'Only one camera available on this device',
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        colorText: Colors.white,
      );
      return;
    }

    try {
      _setLoading(true);

      // Find the other camera (front/rear)
      int newCameraIndex;
      if (_isRearCamera.value) {
        // Switch to front camera
        newCameraIndex = _cameras.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
        );
      } else {
        // Switch to rear camera
        newCameraIndex = _cameras.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
        );
      }

      if (newCameraIndex != -1) {
        _selectedCameraIndex.value = newCameraIndex;
        await _setupCamera(newCameraIndex);

        debugPrint(
          'Camera switched to: ${_isRearCamera.value ? 'rear' : 'front'}',
        );

        // Show feedback to user
        Get.snackbar(
          'Camera Switched',
          'Now using ${_isRearCamera.value ? 'rear' : 'front'} camera',
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.black.withValues(alpha: 0.7),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error switching camera: $e');
      Get.snackbar(
        'Camera Error',
        'Failed to switch camera',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      _setLoading(false);
    }
  }

  // Navigate to meal form with captured image
  void _navigateToMealForm() {
    if (_capturedImage.value != null) {
      Get.toNamed(
        AppRoute.getScanMealFormScreen(),
        arguments: {'imagePath': _capturedImage.value!.path},
      );
    }
  }

  // Clear captured image (for testing/reset)
  void clearCapturedImage() {
    _capturedImage.value = null;
    debugPrint('Captured image cleared');
  }

  // Resolution control methods
  Future<void> changeResolution(ResolutionPreset newResolution) async {
    if (_currentResolution.value == newResolution) return;

    try {
      _setLoading(true);

      // Update resolution
      _currentResolution.value = newResolution;

      // Update display name
      final option = _availableResolutions.firstWhere(
        (res) => res.preset == newResolution,
        orElse: () => ResolutionOption(newResolution, 'Custom', 'Unknown'),
      );
      _resolutionDisplayName.value = option.displayName;

      // Reinitialize camera with new resolution if camera is available
      if (_cameras.isNotEmpty && _isCameraInitialized.value) {
        await _setupCamera(_selectedCameraIndex.value);

        Get.snackbar(
          'Resolution Changed',
          'Camera resolution set to ${option.displayName}',
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      debugPrint('Error changing resolution: $e');
      Get.snackbar(
        'Resolution Error',
        'Failed to change camera resolution',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      _setLoading(false);
    }
  }

  // Quick resolution presets
  void setLowResolution() => changeResolution(ResolutionPreset.low);
  void setMediumResolution() => changeResolution(ResolutionPreset.medium);
  void setHighResolution() => changeResolution(ResolutionPreset.high);
  void setVeryHighResolution() => changeResolution(ResolutionPreset.veryHigh);
  void setUltraHighResolution() => changeResolution(ResolutionPreset.ultraHigh);
  void setMaxResolution() => changeResolution(ResolutionPreset.max);

  // Get current camera resolution info
  String getCurrentResolutionInfo() {
    if (_cameraController?.value.previewSize != null) {
      final size = _cameraController!.value.previewSize!;
      return '${size.width.toInt()}x${size.height.toInt()}';
    }
    return 'Unknown';
  }
}
