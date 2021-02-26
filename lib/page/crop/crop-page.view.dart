import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/widget/Image-crop.widget.dart';


class CropPageView extends StatelessWidget {

  const CropPageView(this.path);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _getBody(context),
    );
  }

  _getAppBar() {
    return AppBar(
      title: Text(
        'cropPage'
      ),
    );
  }

  _getBody(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: ImageCropWidget(path)
    );
  }
}


// class CameraCropPageView extends StatelessWidget {
//
//   CameraCropPageView(this.params);
//
//   final dynamic params;
//
//   CameraCropPageViewModel _viewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     _viewModel ??= CameraCropPageViewModel(this.params);
//
//     return ScopedModel<CameraCropPageViewModel>(
//         model: _viewModel,
//         child: WillPopScope(
//             onWillPop: () async {
//               _viewModel.onBackButtonPressed(context);
//               return false;
//             },
//             child: Scaffold(
//               appBar: _getAppBar(context),
//               body: _getBody(),
//             )
//         )
//     );
//   }
//
//   _getAppBar(context) {
//     return AppBar(
//       backgroundColor: Colors.black,
//       centerTitle: true,
//       automaticallyImplyLeading: false,
//       title: Text(
//         'select area message',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             color: Colors.blue,
//             fontSize: 12.5
//         ),
//       ),
//       leading: IconButton(
//         icon: Center(child: Icon(Icons.arrow_back),),
//         onPressed: () => _viewModel.onBackButtonPressed(context),
//       )
//       // WiseButtonWidget(
//       //     child: Center(
//       //       child: SvgPicture.asset(
//       //         MDIcons.SVG_BACK,
//       //         color: MDColors.white,
//       //       ),
//       //     ),
//       //     onPressed: () {
//       //       _viewModel.onBackButtonPressed(context);
//       //     }
//       // ),
//     );
//   }
//
//   _getBody() {
//     return Container(
//         color: Colors.black,
//         child: SafeArea(
//             child: FutureBuilder(
//                 future: _viewModel.loadCropData,
//                 builder: (context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.none:
//                     case ConnectionState.waiting:
//                       return Container(
//                           height: 200,
//                           child: Center(child: CircularProgressIndicator())
//                       );
//                     default:
//                       return _getContentView(context);
//                   }
//                 }
//             )
//         )
//     );
//   }
//
//   Widget _getContentView(BuildContext context) {
//     return Flex(
//       direction: Axis.vertical,
//       children: <Widget>[
//         Flexible(
//           flex: 8,
//           child: _getCropView(context),
//         ),
//         Flexible(
//           flex: 2,
//           child: _getControlView(context),
//         )
//       ],
//     );
//   }
//
//   _getCropView(context) {
//     return Container(
// //      color: WiseColors.grey_deep_color,
//         alignment: Alignment.center,
//         key: _viewModel.cropViewKey,
//         child: _viewModel.imageCropWidget
//     );
//   }
//
//   _getControlView(BuildContext context) {
//     return FutureBuilder(
//         future: Future.delayed(Duration(milliseconds: 100)),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.none:
//             case ConnectionState.waiting:
//               return Container();
//             default:
//               WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
//               return _getButtons(context);
//           }
//         }
//     );
//   }
//
//   _getButtons(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           _getLowQualityMessage(),
//           _getCropSearchButton(context),
//         ],
//       ),
//     );
//   }
//
//   _getLowQualityMessage() {
//     return Flexible(
//       flex: 1,
//       child: ScopedModelDescendant<CameraCropPageViewModel>(
//           builder: (context, child, model) {
//             return Container(
//               child: Text(
//                   _viewModel.lowQualityMessage,
//                   style: TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.normal,
//                       // fontFamily: MDFonts.WISE_FONT_SPOQA,
//                       fontSize: 11
//                   )
//               ),
//             );
//           }
//       ),
//     );
//   }
//
//   _getCropSearchButton(BuildContext context) {
//     return Flexible(
//       flex: 2,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           Flexible(
//             flex: 1,
//             child: Container(),
//           ),
//           Flexible(
//               flex: 1,
//               child: Container(
//                 width: 70,
//                 height: 30,
//                 decoration: BoxDecoration(
//                     color: Colors.white24
//                 ),
//                 child: RaisedButton(
//                   onPressed: () => _viewModel.onBackButtonPressed(context),
//                   child: Text(
//                     '크롭서치'
//                   ),
//                 )
//               ),
//           ),
//           Flexible(
//             flex: 1,
//             child: Container(
//               child: Center(
//                   child: IconButton(
//                       icon: Icon(Icons.crop_rotate),
//                       onPressed: () => _viewModel.onRotateButtonPressed()
//                   )
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _afterLayout(Duration timeStamp) {
//     _viewModel.setLowQualityMessage();
//   }
// }