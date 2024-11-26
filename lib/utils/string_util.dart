//import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart'; // 导入intl包

class StringUtil {
  /*当前时间字符串*/
  static String currentTimeString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  static String dateToString(DateTime date) {
    String formattedDate = DateFormat('yyyy/MM/dd').format(date);
    return formattedDate;
  }

  /*时间字符串转换为日期*/
  static DateTime stringToDate(String timeString) {
    print('timeString=${timeString}');
    if (timeString.contains('/')) {
      timeString = timeString.replaceAll('/', '-');
    }
    DateTime dateTime = DateTime.parse(timeString);
    return dateTime;
  }

  static String stringToEnglishDate(String timeString) {
    var formatter = DateFormat('MMMd,y');
    String formadDate = formatter.format(stringToDate(timeString));
    return formadDate;
  }


}

/*十进制转换为二进制字符串*/
String decimalToBinary8(int decimal) {
  // 将十进制转换为二进制字符串，并在前面补零至8位
  return decimal.toRadixString(2).padLeft(8, '0');
}
/*二进制字符串转换成十进制*/
int binaryStringToDecimal(String binaryString) {
  // 将二进制字符串转换为十进制数
  return int.parse(binaryString, radix: 2);
}

