import 'package:flutter_test/flutter_test.dart';
import 'package:openbook/src/time_util.dart';

void main() {
  test('relativeTime returns 방금 for time difference smaller than a minute', () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 37, 25),
        DateTime(2022, 4, 4, 9, 37, 25),
      ),
      "방금",
    );
  });

  test(
      'relativeTime returns x분 for time difference between a minute and an hour',
      () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 00, 00),
        DateTime(2022, 4, 4, 9, 37, 25),
      ),
      "37분",
    );
  });

  test('relativeTime returns x시간 for time difference between an hour and a day',
      () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 00, 00),
        DateTime(2022, 4, 4, 13, 37, 25),
      ),
      "4시간",
    );
  });

  test('relativeTime returns 하루 for time difference between one and two days',
      () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 00, 00),
        DateTime(2022, 4, 5, 9, 00, 00),
      ),
      "하루",
    );
  });

  test('relativeTime returns 이틀 for time difference between two and three days',
      () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 00, 00),
        DateTime(2022, 4, 6, 9, 00, 00),
      ),
      "이틀",
    );
  });

  test(
      'relativeTime returns x일 for time difference between three days and a week',
      () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 00, 00),
        DateTime(2022, 4, 8, 8, 59, 00),
      ),
      "3일",
    );
  });

  test('relativeTime returns x주 for time difference between a week and a month',
      () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 00, 00),
        DateTime(2022, 4, 25, 8, 59, 00),
      ),
      "2주",
    );
  });

  test(
      'relativeTime returns x개월 for time difference between a month and a year',
      () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 00, 00),
        DateTime(2022, 5, 25, 8, 59, 00),
      ),
      "1개월",
    );
  });

  test('relativeTime returns x년 for time difference bigger than a year', () {
    expect(
      TimeUtil.relativeTime(
        DateTime(2022, 4, 4, 9, 00, 00),
        DateTime(2024, 12, 25, 8, 59, 00),
      ),
      "2년",
    );
  });
}
