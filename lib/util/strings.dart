import 'dart:math';

String padZeroes({required int number, int length = 2}) {
  String numberString = number.toString();
  while (numberString.length < length) {
    numberString = '0$numberString';
  }
  return numberString;
}

// Adapted from https://stackoverflow.com/a/36566052/5844241
double similarity(String s1, String s2) {
  String longer = s1;
  String shorter = s2;
  if (s1.length < s2.length) {
    longer = s2;
    shorter = s1;
  }
  final longerLength = longer.length;
  if (longerLength == 0) {
    return 1.0;
  }
  return (longerLength - editDistance(longer, shorter)).toDouble() /
      longerLength.toDouble();
}

int editDistance(String s1, String s2) {
  s1 = s1.toLowerCase();
  s2 = s2.toLowerCase();

  final costs = <int>[];
  for (int i = 0; i <= s1.length; i++) {
    int lastValue = i;
    for (int j = 0; j <= s2.length; j++) {
      if (i == 0) {
        if (costs.length <= j) {
          costs.add(j);
        } else {
          costs[j] = j;
        }
      } else {
        if (j > 0) {
          int newValue = costs[j - 1];
          if (s1[i - 1] != s2[j - 1]) {
            newValue = min(min(newValue, lastValue), costs[j]) + 1;
          }
          costs[j - 1] = lastValue;
          lastValue = newValue;
        }
      }
    }
    if (i > 0) {
      costs[s2.length] = lastValue;
    }
  }
  return costs[s2.length];
}
