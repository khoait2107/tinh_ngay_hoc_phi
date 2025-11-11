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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false, // ⚠️ Giữ false nếu bạn muốn giao diện Material2 truyền thống
      ),
      home: const CapNhatHocPhiPage(),
    );
  }
}
