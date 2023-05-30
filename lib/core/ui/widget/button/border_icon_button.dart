// import 'package:flutter/material.dart';
// import 'package:lightify/core/ui/constants/app_constants.dart';
// import 'package:lightify/core/ui/extensions/core_extensions.dart';
// import 'package:lightify/core/ui/styles/colors/app_colors.dart';
// import 'package:lightify/core/ui/utils/screen_util.dart';

// class BorderIconButton extends StatelessWidget {
//   const BorderIconButton({
//     super.key,
//     this.btnHeight = 50,
//     this.iconSize = 20,
//     required this.icon,
//     required this.text,
//     this.textStyle,
//   });

//   final int btnHeight;
//   final IconData icon;
//   final String text;
//   final TextStyle? textStyle;
//   final int iconSize;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: double.maxFinite,
//       height: height(btnHeight),
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColors.gray200),
//         borderRadius: AppConstants.widget.smallBorderRadius,
//       ),
//       padding: EdgeInsets.symmetric(horizontal: width(14)),
//       child: Row(
//         children: [
//           Icon(icon, color: AppColors.gray200, size: height(iconSize)),
//           SizedBox(width: width(8)),
//           Text(text,
//               style: textStyle ??
//                   context.textTheme.displaySmall?.copyWith(
//                     color: AppColors.gray200,
//                   ))
//         ],
//       ),
//     );
//   }
// }
