import 'package:flutter/material.dart';
import 'package:jeong_moji/elastic_page/paged_table_stateful_advanced.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('정주행의 모든 지식들에 오신 것을 환영합니다.'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('입장'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DataTableAdvancedStateful(),
              ),
            );
          },
        ),
      ),
    );
  }
}