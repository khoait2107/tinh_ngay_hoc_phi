import 'package:flutter/material.dart';
import 'capnhat_hocphi.dart'; // import giao diện bạn đã tạo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cập nhật học phí',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, // ✅ rất quan trọng cho Flutter 3.0.5
      ),
      home: const CapNhatHocPhiPage(), // trang chính
    );
  }
}
