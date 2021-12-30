import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/book_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/view/screens/book/book.dart';
import 'package:groomzy/view/widgets/app_bar/app_bar.dart';
import 'package:groomzy/view/widgets/center_horizontal/center_horizontal.dart';

class BookScreen extends StatelessWidget {
  static final String routeName =
      '/${bookTitle.toLowerCase().replaceAll(' ', '')}';

  BookScreen({Key? key}) : super(key: key);
  final BookController bookController =  Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AndroidAppBar(
        title: bookTitle,
      ),
      body: SafeArea(
        child: AndroidCenterHorizontal(
          screenContent: Book(),
        ),
      ),
    );
  }
}
