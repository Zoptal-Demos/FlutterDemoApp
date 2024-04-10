
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Utils{
  static double setAverageRating(List<int> ratings) {
    var avgRating = 0;
    for (int i = 0; i < ratings.length; i++) {
      avgRating = avgRating + ratings[i];
    }
    return double.parse((avgRating / ratings.length).toStringAsFixed(1));
  }

  static bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
  static bool isPhoneNumber(String value) {
    // Use a regular expression to check if the input is a valid phone number
    final RegExp phoneRegex = RegExp(r'^\+?[0-9]{8,}$');

    return phoneRegex.hasMatch(value);
  }

  static  keyBoardHide(BuildContext context) {

    FocusScope.of(context).requestFocus(FocusNode());

  }

  static List<String> removeDuplicates<T>(List<T> list) {
    Set<String> uniqueSet = Set<String>.from(list.map((element) => element.toString().toLowerCase()));
    return uniqueSet.toList();
  }



  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }



  static String timeAgo(DateTime timestamp) {
    Duration difference = DateTime.now().difference(timestamp);

    if (difference.inDays >= 365) {
      // More than a year ago
      int years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays >= 30) {
      // More than a month ago
      int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays >= 7) {
      // More than a week ago
      int weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays >= 2) {
      // More than a day ago
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      // Yesterday
      return 'Yesterday';
    } else if (difference.inHours >= 2) {
      // More than an hour ago
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      // An hour ago
      return 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      // More than a minute ago
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      // A minute ago
      return 'A minute ago';
    } else {
      // Just now
      return 'Just now';
    }
  }

  // method to return epooch time to String time format
  static String convertTime(dynamic time){
    // Convert epoch time to DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);

    // Format the DateTime object according to the desired format
    String formattedDateTime = DateFormat('E, MMM dd').format(dateTime);
    return formattedDateTime;
  }

}