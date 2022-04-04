class TimeUtil {
  // Represent DateTime object as a string, relative to now.
  static String relativeTime(DateTime dateTime, DateTime reference) {
    final diff = reference.difference(dateTime);
    if (diff.inDays >= 365) {
      return '${diff.inDays ~/ 365}년';
    } else if (diff.inDays >= 30) {
      return '${diff.inDays ~/ 30}개월';
    } else if (diff.inDays >= 7) {
      return '${diff.inDays ~/ 7}주';
    } else if (diff.inDays >= 3) {
      return '${diff.inDays}일';
    } else if (diff.inDays >= 2) {
      return '이틀';
    } else if (diff.inDays >= 1) {
      return '하루';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}시간';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}분';
    } else {
      return '방금';
    }
  }
}
