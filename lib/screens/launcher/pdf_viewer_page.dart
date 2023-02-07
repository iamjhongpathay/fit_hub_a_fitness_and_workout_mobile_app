import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;
  const PDFViewerPage({Key key,
  @required this.file
  }) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  PDFViewController controller;
  int pages = 0;
  int indexPage = 0;


  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        actions: pages >= 2
        ? [
        Center(child: Text(text,
        style: TextStyle(color: Colors.white),
        )),
        IconButton(
          icon: Icon(Icons.chevron_left, size: 32),
          onPressed: () {
            final page = indexPage == 0 ? pages : indexPage - 1;
            controller.setPage(page);
          },
        ),
        IconButton(
          icon: Icon(Icons.chevron_right, size: 32),
          onPressed: () {
            final page = indexPage == pages - 1 ? 0 : indexPage + 1;
            controller.setPage(page);
          },
        ),
        ]
            : null,
        title: Text(name,
            style: TextStyle( color: Colors.white,
            ),
        ),

      ),
      body: OfflineBuilder(
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity, Widget child){
          final bool connected =
              connectivity != ConnectivityResult.none;
          return Stack(
            fit: StackFit.expand,
            children: [
              child,
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  height: 25.0,
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: connected ? null : Color(0xFFEE4400),
                      child: connected ? null :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('No internet connection', style: TextStyle(color: Colors.white),),
                        ],
                      )
                  )
              )
            ],
          );
        },
        child: PDFView(
          filePath: widget.file.path,
          autoSpacing: false,
          // swipeHorizontal: true,
          // pageSnap: false,
          pageFling: false,

          onRender: (pages) => setState(() => this.pages = pages),
          onViewCreated: (controller) =>
              setState(() => this.controller = controller),
          onPageChanged: (indexPage, _) =>
              setState(() => this.indexPage = indexPage),
        ),
      )
    );
  }
}
