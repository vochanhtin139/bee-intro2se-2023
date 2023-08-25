import 'package:flutter/material.dart';

class infoScreen extends StatefulWidget {
const infoScreen({super.key});

@override
State<StatefulWidget> createState() => _infoScreenState();
}

class _infoScreenState extends State<infoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          'Thông tin thêm',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Image.asset(
                    'assets/logoBEE.png',
                    width: 220,
                    height: 220,
                  ),
                ),
                Text(
                  'BEE - Be English Expert',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ứng dụng từ điển tiếng Anh',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Thông tin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Là phần mềm dùng để hỗ trợ người dùng trong việc tra cứu từ điển tiếng Anh trên thiết bị smartphone',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tính năng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tra cứu từ điển Anh - Việt và Việt - Anh\nTìm kiếm các động từ bất quy tắc\nHỗ trợ tra cứu từ điển nâng cao Oxford Learner\'s Dictionary\nHỗ trợ tra cứu từ điển nâng cao Cambridge Dictionary',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Thông tin đội ngũ phát triển',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                 child: Text(
                  'Đội ngũ phát triển dự án BEE - Be English Expert thuộc lớp 21CLC10 khoa Công nghệ thông tin chương trình Chất lượng cao thuộc trường Đại học Khoa học tự nhiên - ĐHQG TP.HCM',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                 child: Text(
                  '21127063 - Nguyễn Văn Đăng Huỳnh\n21127155 - Phan Như Quỳnh\n21127182 - Võ Chánh Tín\n21127395 - Nguyễn Lê Tấn Phúc ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}