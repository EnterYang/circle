class DateTimeUtil {
 static String getDate(String dateOriginal) {
    //现在的日期
    var today = DateTime.now();
    //今天的23:59:59
    var standardDate = DateTime(today.year, today.month, today.day, 23, 59, 59);
    //传入的日期与今天的23:59:59秒进行比较
    Duration diff = standardDate.difference(DateTime.parse(dateOriginal));
//    print('日期比较结果${diff.inDays}');
    if (diff < Duration(days: 1)) {
      //今天
      // 09:20
      return dateOriginal.substring(11, 16);
    } else if (diff >= Duration(days: 1) && diff < Duration(days: 2)) {
      //昨天
      //昨天09:20
      return "昨天 " + dateOriginal.substring(11, 16);
    } else {
      //昨天之前
      // 2019-01-23 09:20
      return dateOriginal.substring(0, 16);
    }
  }

 //将 unix 时间戳转换为特定时间文本，如年月日
 static String convertTime(int timestamp) {
   DateTime msgTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
   DateTime nowTime = DateTime.now();

   if(nowTime.year == msgTime.year) {//同一年
     if(nowTime.month == msgTime.month) {//同一月
       if(nowTime.day == msgTime.day) {//同一天 时:分
         return _getTime(msgTime);
       }else {
         if(nowTime.day - msgTime.day == 1) {//昨天
           return "昨天"+" "+_getTime(msgTime);
         }
//         else if(nowTime.day - msgTime.day == 2) {
//           return "前天"+" "+_getTime(msgTime);
//         }
         else if(nowTime.day - msgTime.day < 7) {
           return _getWeekday(msgTime.weekday)+" "+_getTime(msgTime);
         }
       }
     }
   }
   return msgTime.year.toString()+"年"+msgTime.month.toString()+"月"+msgTime.day.toString()+"日"+" "+_getTime(msgTime);
 }

 static String conversationListConvertTime(int timestamp) {
   DateTime msgTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
   DateTime nowTime = DateTime.now();

   if(nowTime.year == msgTime.year) {//同一年
     if(nowTime.month == msgTime.month) {//同一月
       if(nowTime.day == msgTime.day) {//同一天 时:分
         return _getTime(msgTime);
       }else {
         if(nowTime.day - msgTime.day == 1) {//昨天
           return "昨天";
         }else if(nowTime.day - msgTime.day < 7) {
           return _getWeekday(msgTime.weekday);
         }
       }
     }
   }
   return msgTime.year.toString()+"/"+msgTime.month.toString()+"/"+msgTime.day.toString();
 }

 ///是否需要显示时间，相差 5 分钟
 static bool needShowTime(int sentTime1,int sentTime2) {
   return (sentTime1-sentTime2).abs() > 5 * 60 * 1000;
 }

 static String _getWeekday(int weekday) {
   switch (weekday) {
     case 1:return "星期一";
     case 2:return "星期二";
     case 3:return "星期三";
     case 4:return "星期四";
     case 5:return "星期五";
     case 6:return "星期六";
     default:return "星期日";
   }
 }

 static String _getTime(DateTime msgTime) {
   return (msgTime.hour < 10 ? "0" : "") + msgTime.hour.toString()+":" + (msgTime.minute < 10 ? "0" : "") + msgTime.minute.toString();
 }
}