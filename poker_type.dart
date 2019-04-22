import 'dart:math' as math;
/// 计算牌类型工具类
/// 各个花色值
/// 黑桃 0-12   A,2,3,4,5,6,7,8,9,10,J,Q,K
/// 红桃 13-25  A,2,3,4,5,6,7,8,9,10,J,Q,K
/// 草花 26-38  A,2,3,4,5,6,7,8,9,10,J,Q,K
/// 方片 39-51  A,2,3,4,5,6,7,8,9,10,J,Q,K
/// 
final HighCard = 1; //高牌
final OnePair = 2; //一对
final TwoPairs = 3;
final Three = 4;
final Straight = 5;
final Flush = 6;
final FullHouse = 7;
final Four = 8;
final StraightFlush = 9;
final RoyalFlush = 10;

int getPokerType(List arr) {
  var pokerType = HighCard;
  var pokers = [];
  arr.forEach((item) {
    if (int.parse(item) >= 0) {
      pokers.add(int.parse(item));
    }
  });
  if (pokers.length == 2) {
    pokerType = _twoPokeGet(pokers);
  } else if (pokers.length == 5) {
    pokerType = _fivePokerGet(pokers);
  } else if (pokers.length > 5) {
    var pokerTypes = Set();
    var pokerZuHe = _zuHeSuanFa(pokers, 5);
    pokerZuHe.forEach((item) {
      var oneType = _fivePokerGet(item);
      pokerTypes.add(oneType);
    });
    pokerType = pokerTypes.cast<num>().reduce(math.max);
  }
  return pokerType;
}

/**
 * 获取牌型 -两张牌
 */
int _twoPokeGet(List<int> pokers) {
  var pokerType = HighCard;
  var firstCard = pokers.first;
  var lastCard = pokers.last;
  if (firstCard % 13 == lastCard % 13) {
    pokerType = OnePair;
  }
  return pokerType;
}

/** 
 * 获取牌型 -五张牌
 */
int _fivePokerGet(List<int> pokers) {
  var pokerType = HighCard;
  if (_resultRoyalFlush(pokers)) {
    pokerType = RoyalFlush;
  } else if (_resultStraightFlush(pokers)) {
    pokerType = StraightFlush;
  } else if (_resultFour(pokers)) {
    pokerType = Four;
  } else if (_resultFullHouse(pokers)) {
    pokerType = FullHouse;
  } else if (_resultFlush(pokers)) {
    pokerType = Flush;
  } else if (_resultStraight(pokers)) {
    pokerType = Straight;
  } else if (_resultThree(pokers)) {
    pokerType = Three;
  } else if (_resultTwoPairs(pokers)) {
    pokerType = TwoPairs;
  } else if (_resultOnePair(pokers)) {
    pokerType = OnePair;
  }
  return pokerType;
}

/**
 * 判断牌型 -对子
 */
bool _resultOnePair(List<int> pokers) {
  var result = false;
  var deformationCards = Set();
  pokers.forEach((item) {
    deformationCards.add(item % 13);
  });
  if (deformationCards.length == 2) {
    result = true;
  }
  return result;
}

/**
 * 判断牌型 -两对
 */
bool _resultTwoPairs(List<int> pokers) {
  var result = false;
  var deformationCards = Set();
  pokers.forEach((item) {
    deformationCards.add(item % 13);
  });
  if (deformationCards.length == 3) {
    var maxValue = deformationCards.cast<num>().reduce(math.max);
    var minValue = deformationCards.cast<num>().reduce(math.min);
    var otherValue = -1;
    for (var item in deformationCards) {
      if (item != maxValue && item != minValue) {
        otherValue = item;
        break;
      }
    }
    var totalMaxCount = 0;
    var totalMinCount = 0;
    var totalOtherCount = 0;
    pokers.forEach((item) {
      var itemValue = item % 13;
      if (itemValue == maxValue) {
        totalMaxCount++;
      } else if (itemValue == minValue) {
        totalMinCount++;
      } else if (itemValue == otherValue) {
        totalOtherCount++;
      }
    });
    if (totalMaxCount == 2 || totalMinCount == 2 || totalOtherCount == 2) {
      result = true;
    }
  }
  return result;
}

/**
 * 判断牌型 -三条
 */
bool _resultThree(List<int> pokers) {
  var result = false;
  var deformationCards = Set();
  pokers.forEach((item) {
    deformationCards.add(item % 13);
  });
  if (deformationCards.length == 3) {
    var maxValue = deformationCards.cast<num>().reduce(math.max);
    var minValue = deformationCards.cast<num>().reduce(math.min);
    var otherValue = -1;
    for (var item in deformationCards) {
      if (item != maxValue && item != minValue) {
        otherValue = item;
        break;
      }
    }
    var totalMaxCount = 0;
    var totalMinCount = 0;
    var totalOtherCount = 0;
    pokers.forEach((item) {
      var itemValue = item % 13;
      if (itemValue == maxValue) {
        totalMaxCount++;
      } else if (itemValue == minValue) {
        totalMinCount++;
      } else if (itemValue == otherValue) {
        totalOtherCount++;
      }
    });
    if (totalMaxCount == 3 || totalMinCount == 3 || totalOtherCount == 3) {
      result = true;
    }
  }
  return result;
}

/**
 * 判断牌型 -葫芦
 */
bool _resultFullHouse(List<int> pokers) {
  var result = false;
  var deformationCards = Set();
  pokers.forEach((item) {
    deformationCards.add(item % 13);
  });
  if (deformationCards.length == 2) {
    var maxValue = deformationCards.cast<num>().reduce(math.max);
    var minValue = deformationCards.cast<num>().reduce(math.min);
    var totalMaxCount = 0;
    var totalMinCount = 0;
    pokers.forEach((item) {
      var itemValue = item % 13;
      if (itemValue == maxValue) {
        totalMaxCount++;
      } else if (itemValue == minValue) {
        totalMinCount++;
      }
    });
    if (totalMaxCount == 3 || totalMinCount == 3) {
      result = true;
    }
  }
  return result;
}

/**
 * 判断牌型 -四条
 */
bool _resultFour(List<int> pokers) {
  bool result = false;
  var deformationCards = Set();
  pokers.forEach((item) {
    deformationCards.add(item % 13);
  });
  if (deformationCards.length == 2) {
    var maxValue = deformationCards.cast<num>().reduce(math.max);
    var minValue = deformationCards.cast<num>().reduce(math.min);
    var totalMaxCount = 0;
    var totalMinCount = 0;
    pokers.forEach((item) {
      var itemValue = item % 13;
      if (itemValue == maxValue) {
        totalMaxCount++;
      } else if (itemValue == minValue) {
        totalMinCount++;
      }
    });
    if (totalMaxCount == 4 || totalMinCount == 4) {
      result = true;
    }
  }
  return result;
}

/**
 * 牌型判断 -顺子
 */
bool _resultStraight(List<int> pokers) {
  bool result = false;
  var deformationCards = Set();
  pokers.forEach((item) {
    deformationCards.add(item % 13);
  });
  if (deformationCards.length == 5) {
    var maxValue = deformationCards.cast<num>().reduce(math.max);
    var minValue = deformationCards.cast<num>().reduce(math.min);
    if (maxValue - minValue == 4) {
      result = true;
    } else if (maxValue - minValue == 12) {
      var totalSum = deformationCards.cast<num>().reduce((a, b) => a + b);
      if (totalSum == 18) {
        result = true;
      }
    }
  }
  return result;
}

/**
 * 牌型判断 -同花
 */
bool _resultFlush(List<int> pokers) {
  bool result = false;
  var deformationCards = Set();
  pokers.forEach((item) {
    deformationCards.add(item);
  });
  if (deformationCards.length == 5) {
    var maxValue = deformationCards.cast<num>().reduce(math.max);
    var minValue = deformationCards.cast<num>().reduce(math.min);
    if (maxValue - minValue <= 12) {
      if ((maxValue >= 0 && maxValue <= 12) &&
          (minValue >= 0 && minValue <= 12)) {
        result = true;
      } else if ((maxValue >= 13 && maxValue <= 25) &&
          (minValue >= 13 && minValue <= 25)) {
        result = true;
      } else if ((maxValue >= 26 && maxValue <= 38) &&
          (minValue >= 26 && minValue <= 38)) {
        result = true;
      } else if ((maxValue >= 39 && maxValue <= 51) &&
          (minValue >= 39 && minValue <= 51)) {
        result = true;
      }
    }
  }
  return result;
}

/**
 * 牌型判断 -同花顺
 */
bool _resultStraightFlush(List<int> pokers) {
  bool result = false;
  if (_resultStraight(pokers) && _resultFlush(pokers)) {
    result = true;
  }
  return result;
}

/**
 * 牌型判断 -皇家同花顺
 */
bool _resultRoyalFlush(List<int> pokers) {
  bool result = false;
  var maxValue = pokers.reduce(math.max) % 13;
  var minValue = pokers.reduce(math.min) % 13;
  if (_resultStraightFlush(pokers) && maxValue == 12 && minValue == 8) {
    result = true;
  }
  return result;
}

/**
 * 排列组合
 */
List _zuHeSuanFa(List<dynamic> array, int m) {
  var mutableArray = List.from(array);
  var n = mutableArray.length;
  if (m > n) {
    return null;
  }
  var allChooseArr = [];
  var retArray = List.from(mutableArray);

  //(1,1,1,0,0)
  for (var i = 0; i < n; i++) {
    if (i < m) {
      mutableArray[i] = '1';
    } else {
      mutableArray[i] = '0';
    }
  }
  var firstArray = [];
  for (var i = 0; i < n; i++) {
    if (int.parse(mutableArray[i]) == 1) {
      firstArray.add(retArray[i]);
    }
  }
  allChooseArr.add(firstArray);

  int count = 0;
  for (var i = 0; i < n - 1; i++) {
    if (int.parse(mutableArray[i]) == 1 &&
        int.parse(mutableArray[i + 1]) == 0) {
      mutableArray[i] = '0';
      mutableArray[i + 1] = '1';

      for (var k = 0; k < i; k++) {
        if (int.parse(mutableArray[k]) == 1) {
          count++;
        }
      }
      if (count > 0) {
        for (var k = 0; k < i; k++) {
          if (k < count) {
            mutableArray[k] = '1';
          } else {
            mutableArray[k] = '0';
          }
        }
      }
      var middleArray = [];
      for (var k = 0; k < n; k++) {
        if (int.parse(mutableArray[k]) == 1) {
          middleArray.add(retArray[k]);
        }
      }
      allChooseArr.add(middleArray);
      i = -1;
      count = 0;
    }
  }
  return allChooseArr;
}
