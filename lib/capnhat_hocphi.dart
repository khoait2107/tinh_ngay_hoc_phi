import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CapNhatHocPhiPage extends StatefulWidget {
  const CapNhatHocPhiPage({super.key});

  @override
  State<CapNhatHocPhiPage> createState() => _CapNhatHocPhiPageState();
}

class _CapNhatHocPhiPageState extends State<CapNhatHocPhiPage> {
  String _caHoc = "246";
  DateTime? _ngayHetHP;
  List<String> _thuList = [];
  List<String> _selectedDays = [];

  int _soTuan = 0;
  int _soBuoiMoi = 0;
  int _soBuoiNhap = 0;

  String _ngayBDMoi = "";
  String _ngayKTMoi = "";
  final TextEditingController _ghichuCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateDays();
  }

  void _updateDays() {
    List<String> days = [];
    int soBuoiMacDinh = 0;

    if (_caHoc.contains("246")) {
      days = ["T2", "T4", "T6"];
      soBuoiMacDinh = 3;
    } else if (_caHoc.contains("357")) {
      days = ["T3", "T5", "T7"];
      soBuoiMacDinh = 3;
    } else if (_caHoc.contains("7CN")) {
      days = ["T7", "CN"];
      soBuoiMacDinh = 2;
    }

    setState(() {
      _thuList = days;
      _selectedDays = List.from(days); // chọn mặc định
      _soBuoiMoi = soBuoiMacDinh;      // ✅ đặt số buổi tương ứng
    });
  }


  void _chonNgayHetHP(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _ngayHetHP ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => _ngayHetHP = picked);
    }
  }

  void _tinhNgayHocPhi() {
    if (_ngayHetHP == null) {
      _showAlert("Vui lòng chọn ngày hết học phí!");
      return;
    }

    if (_soTuan == 0 && _soBuoiNhap == 0) {
      _showAlert("Vui lòng nhập Số tuần hoặc Số buổi học > 0!");
      return;
    }

    if (_soBuoiMoi == 0) {
      _showAlert("Vui lòng chọn Số buổi học trong tuần!");
      return;
    }

    if (_selectedDays.isEmpty) {
      _showAlert("Vui lòng chọn ít nhất 1 ngày học trong tuần!");
      return;
    }

    // ✅ Công thức chuẩn theo bạn:
    int tongSoBuoi = (_soTuan * _soBuoiMoi) + _soBuoiNhap;

    if (tongSoBuoi <= 0) {
      _showAlert("Tổng số buổi phải lớn hơn 0!");
      return;
    }

    DateTime startDate = _ngayHetHP!.add(const Duration(days: 1));

    Map<String, int> mapThu = {
      "T2": DateTime.monday,
      "T3": DateTime.tuesday,
      "T4": DateTime.wednesday,
      "T5": DateTime.thursday,
      "T6": DateTime.friday,
      "T7": DateTime.saturday,
      "CN": DateTime.sunday,
    };

    List<int> thuHopLe = _selectedDays.map((t) => mapThu[t]!).toList();

    int dem = 0;
    DateTime? ngayBDMoi;
    DateTime current = startDate;

    while (dem < tongSoBuoi) {
      if (thuHopLe.contains(current.weekday)) {
        dem++;
        ngayBDMoi ??= current;
      }
      current = current.add(const Duration(days: 1));
    }

    DateTime ngayKTMoi = current.subtract(const Duration(days: 1));

    final fmt = DateFormat('dd/MM/yyyy');
    setState(() {
      _ngayBDMoi = fmt.format(ngayBDMoi!);
      _ngayKTMoi = fmt.format(ngayKTMoi);
    });
  }





  void _showAlert(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thông báo"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Widget _buildOptionButton(String label, String value) {
    final active = _caHoc == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _caHoc = value;
            _updateDays();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: active ? Colors.blue[700] : Colors.white,
            border: Border.all(color: Colors.blue.shade700),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxDays() {
    return Wrap(
      spacing: 8,
      children: _thuList.map((day) {
        final active = _selectedDays.contains(day);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (active) {
                _selectedDays.remove(day);
              } else {
                _selectedDays.add(day);
              }
            });
          },


          child: Container(
            decoration: BoxDecoration(
              color: active ? Colors.blue[700] : Colors.white,
              border: Border.all(color: Colors.blue.shade700),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              day,
              style: TextStyle(
                color: active ? Colors.white : Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f4ff),
      appBar: AppBar(
        title: const Text("TÍNH HỌC PHÍ"),
        backgroundColor: Colors.blue[700],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- THÔNG TIN HIỆN TẠI ---
                Text("📘 THÔNG TIN HIỆN TẠI",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                        fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Ca học: ",
                        style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          _buildOptionButton("246", "246"),
                          _buildOptionButton("357", "357"),
                          _buildOptionButton("7CN", "7CN"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Số buổi học trong tuần:",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _soBuoiMoi = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _soBuoiMoi == 1 ? Colors.blue[700] : Colors.white,
                            border: Border.all(color: Colors.blue.shade700),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "1 buổi",
                              style: TextStyle(
                                color: _soBuoiMoi == 1
                                    ? Colors.white
                                    : Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _soBuoiMoi = 2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _soBuoiMoi == 2 ? Colors.blue[700] : Colors.white,
                            border: Border.all(color: Colors.blue.shade700),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "2 buổi",
                              style: TextStyle(
                                color: _soBuoiMoi == 2
                                    ? Colors.white
                                    : Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _soBuoiMoi = 3),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _soBuoiMoi == 3 ? Colors.blue[700] : Colors.white,
                            border: Border.all(color: Colors.blue.shade700),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "3 buổi",
                              style: TextStyle(
                                color: _soBuoiMoi == 3
                                    ? Colors.white
                                    : Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Text("Ngày hết học phí:",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _ngayHetHP == null
                            ? "Chưa chọn"
                            : DateFormat('dd/MM/yyyy').format(_ngayHetHP!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _chonNgayHetHP(context),
                      child: const Text("Chọn ngày"),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text("Chọn buổi học trong tuần:",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                _buildCheckboxDays(),

                const SizedBox(height: 20),
                // --- THÔNG TIN HỌC PHÍ MỚI ---
                Text("📘 THÔNG TIN HỌC PHÍ MỚI",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                        fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Số tuần:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          DropdownButton<int>(
                            isExpanded: true,
                            value: _soTuan,
                            items: [0, 4, 8, 16, 32, 48]
                                .map((v) => DropdownMenuItem<int>(
                              value: v,
                              child: Text(v.toString()),
                            ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _soTuan = v!;
                                if (v > 0) _soBuoiMoi = 0;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Center(
                          child: Text("hoặc",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Số buổi lẻ:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              setState(() {
                                _soBuoiNhap = int.tryParse(v) ?? 0; // ✅ DÙNG _soBuoiNhap
                                if (_soBuoiNhap > 0) _soTuan = 0;   // ✅ Reset số tuần khi nhập buổi lẻ
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              hintText: "0",
                            ),
                          ),
                        ],

                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    onPressed: _tinhNgayHocPhi,
                    child: const Text("TÍNH NGÀY"),
                  ),

                ),


                const SizedBox(height: 25),
                // --- KẾT QUẢ ---
                Text("📘 KẾT QUẢ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                        fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Ngày bắt đầu:"),
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xffe3f2fd),
                              borderRadius: BorderRadius.circular(12),
                              border:
                              Border.all(color: const Color(0xffbbdefb)),
                            ),
                            child: Text(
                              _ngayBDMoi,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xff0d47a1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Ngày kết thúc:"),
                          Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xffe3f2fd),
                              borderRadius: BorderRadius.circular(12),
                              border:
                              Border.all(color: const Color(0xffbbdefb)),
                            ),
                            child: Text(
                              _ngayKTMoi,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xff0d47a1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
