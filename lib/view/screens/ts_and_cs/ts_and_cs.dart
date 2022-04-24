import 'package:flutter/material.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TsAndCs extends StatelessWidget {
  const TsAndCs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map currentDevice = Utils().currentDevice(context);
    Size mediaQuerySize = MediaQuery.of(context).size;

    return currentDevice['isDesktop']
        ? SizedBox(
            height: mediaQuerySize.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AndroidDrawer(),
                const VerticalDivider(),
                Expanded(
                    child: SfPdfViewer.asset(
                        'assets/common/docs/ts_and_cs/groomzy_ts_and_cs.pdf'))
              ],
            ))
        : SfPdfViewer.asset(
            'assets/common/docs/ts_and_cs/groomzy_ts_and_cs.pdf');
  }
}
