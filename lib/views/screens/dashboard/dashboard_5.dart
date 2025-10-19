import 'dart:math';
import 'package:api_tech_moto/models/ecu_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/ecu_data_controller.dart';
import '../../../controllers/bluetooth_controller.dart';

class TemplateFiveScreen extends StatelessWidget {
  const TemplateFiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ecuController = Get.find<ECUDataController>();
    final btController = Get.find<BluetoothController>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            return Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/ui-5/Component 1.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.28, // 53% จากด้านบน
                  right: screenWidth * 0.21, // ดึงจากตรงกลางแนวนอนไปทางซ้าย 35
                  child: Obx(() {
                    final speed = ecuController.currentData.value?.speed ?? 0;
                    return _buildRotatingNeedleGauge(
                      value: speed,
                      maxValue: 270,
                      size: 85,
                      offsetAngle: -15,
                      rotationRange: 270,
                      needleImage: Image.asset(
                        'assets/ui-5/Component 2.png',
                        fit: BoxFit.contain,
                      ),
                      alignment: Alignment.bottomLeft,
                    );
                  }),
                ),
                Positioned(
                  top: screenHeight * 0.3 - 10, // 53% จากด้านบน
                  left:
                      screenWidth * 0.3 - 35, // ดึงจากตรงกลางแนวนอนไปทางซ้าย 35
                  child: Obx(() {
                    final rpm = ecuController.currentData.value?.rpm ?? 0;
                    return _buildRotatingNeedleGauge(
                      value: rpm,
                      maxValue: 15000,
                      size: 100,
                      offsetAngle: -65,
                      rotationRange: 320,
                      needleImage: Image.asset(
                        'assets/ui-5/Component 3.png',
                        fit: BoxFit.contain,
                      ),
                      alignment: Alignment.bottomLeft,
                    );
                  }),
                ),

                // Speed Number Display (Center of right gauge)
                Positioned(
                  top: screenHeight * 0.5,
                  right: screenWidth * 0.25 - 45,
                  child: Obx(() {
                    final speed = ecuController.currentData.value?.speed ?? 0;
                    return _buildCenterDisplay(
                      value: speed.toInt().toString(),
                      label: 'KM/H',
                    );
                  }),
                ),

                // Center Data Panel
                // Positioned(
                //   top: screenHeight * 0.25,
                //   left: screenWidth * 0.5 - 60,
                //   child: Obx(() {
                //     final data = ecuController.currentData.value;
                //     return _buildCenterDataPanel(data);
                //   }),
                // ),

                // IGN & INJ Data Panel (Left Side)
                Positioned(
                  bottom: screenHeight * 0.25 -5,
                  left: screenWidth * 0.55,
                  child: Obx(() {
                    final data = ecuController.currentData.value;
                    return _buildCenterDataPanel(data);
                  }),
                ),

                // AFR and TPS Display (Bottom Center)
                Positioned(
                  bottom: screenHeight * 0.1 + 10,
                  left: screenWidth * 0.45 + 20,
                  child: Obx(() {
                    final data = ecuController.currentData.value;
                    final afr = data?.afr ?? 0;
                    final tps = data?.tps ?? 0;
                    return _buildBottomDataPanel(afr, tps);
                  }),
                ),

                // Bluetooth Button (Bottom Right)
                Positioned(
                  bottom: screenHeight * 0.15,
                  right: screenWidth * 0.05,
                  child: Obx(() {
                    final isConnected =
                        btController.connectionStatus.value ==
                        BluetoothConnectionStatus.connected;
                    return Container(
                      decoration: BoxDecoration(
                        color: isConnected ? Colors.green : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.bluetooth,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          ecuController.startGeneratingData();
                        },
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Row _buildBottomDataPanel(double afr, double tps) {
    return Row(
      children: [
        _buildDataLabel('AFR', afr.toStringAsFixed(1)),
        SizedBox(width: 50),
        _buildDataLabel('TPS', tps.toInt().toString()),
      ],
    );
  }

  /// Center Display Widget
  Widget _buildCenterDisplay({required String value, required String label}) {
    return Container(
      width: 80,
      alignment: Alignment.center,
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Data Row Widget
  Widget _buildDataRow(String label, String value, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Text(
              unit,
              style: const TextStyle(
                color: Color(0xFF00FFFF),
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Data Label Widget (for AFR, TPS display)
  Widget _buildDataLabel(String label, String value) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Top Left Data Panel (IGN, INJ display)
  Widget _buildCenterDataPanel(ECUData? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDataLabel('IGN', data?.ignition.toStringAsFixed(0) ?? '0'),
        const SizedBox(height: 4),
        _buildDataLabel('IGN', data?.ignition.toStringAsFixed(0) ?? '0'),
        const SizedBox(height: 4),
        _buildDataLabel('INJ', data?.inject.toStringAsFixed(1) ?? '0'),
        const SizedBox(height: 4),
        _buildDataLabel('INJ', data?.inject.toStringAsFixed(0) ?? '0'),
      ],
    );
  }

  /// Compact Data Row for Top Left Panel
  Widget _buildCompactDataRow(String label, String unit, String value) {
    return Row(
      children: [
        SizedBox(
          width: 35,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 55,
          child: Text(
            unit,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Main RPM Gauge with rotating needle
  ///
  /// [value] ค่าปัจจุบัน (RPM)
  /// [maxValue] ค่าสูงสุด
  /// [size] ขนาดของ gauge
  /// [offsetAngle] มุม offset เฉพาะของ gauge นี้
  /// [rotationRange] ช่วงการหมุนเฉพาะของ gauge นี้
  Widget _buildRotatingNeedleGauge({
    required double value, // ค่าปัจจุบัน (RPM, Speed, etc.)
    required double maxValue, // ค่าสูงสุด
    required double size,
    required double offsetAngle, // ค่า offset เฉพาะของ gauge นี้
    required double rotationRange, // ช่วงการหมุนเฉพาะของ gauge นี้
    required Image needleImage,
    required Alignment alignment,
  }) {
    print(value);
    // คำนวณมุม
    final angle = _rpmToAngle(value, maxValue, offsetAngle, rotationRange);
    print(angle);
    return Stack(
      children: [
        // Rotating Needle with smooth animation
        Container(
          color: Colors.green.withValues(alpha: .3),
          height: size,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: angle),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * (pi / 180),
                alignment: alignment, // หมุนรอบจุดซ้ายล่าง
                child: child,
              );
            },
            child: needleImage,
          ),
        ),
      ],
    );
  }

  /// Convert RPM to angle in degrees
  double _rpmToAngle(
    double rpm,
    double maxRpm,
    double offsetAngle,
    double rotationRange,
  ) {
    // RPM 0 → เลข 1 บน gauge, RPM max → เลข 15 บน gauge
    final normalizedRpm = rpm.clamp(0, maxRpm);
    return (normalizedRpm / maxRpm) * rotationRange - 135 + offsetAngle;
  }
}
