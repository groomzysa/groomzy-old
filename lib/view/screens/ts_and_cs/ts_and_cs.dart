import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TsAndCs extends StatelessWidget {
  const TsAndCs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.asset(
        'assets/common/docs/ts_and_cs/groomzy_ts_and_cs.pdf');
  }
}
