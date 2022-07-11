import 'dart:io';
import 'dart:math';

void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    if (arguments[0].contains("->")) {
      parseChemicals(arguments[0]);
    } else {
      printBadFormat();
    }
  } else {
    printEmptyArguments();
  }
  exit(1);
}

void printBadFormat() {
  stderr.writeln("Bad argument for equilibrium constant");
  printFormat();
}

void printEmptyArguments() {
  stderr.writeln("Empty arguments for equilibrium constant");
  printFormat();
}

void printFormat() {
  print("Format: NRR + NRR -> NRR");
  print("N  = number of elements");
  print("R  = element");
  print("-> = yeilds arrow");
}

void parseChemicals(String s) {
  List<Element> elements = [];
  s = s.replaceAll(" ", "");
  String leftEquation = s.substring(0, s.indexOf("->"));
  String rightEquation = s.substring(s.indexOf("->") + 2);

  elements.addAll(addedElements(leftEquation, true));
  elements.addAll(addedElements(rightEquation, false));

  printAnswer(elements);
}

List<Element> addedElements(String equation, bool isReactant) {
  List<Element> result = [];
  List<String> eqArr = equation.split("+");

  for (int i = 0; i < eqArr.length; i++) {
    String num = "";
    int j = 0;
    while (isDigit(eqArr[i], j) && j < eqArr[i].length) {
      num += eqArr[i][j];
      j++;
    }
    result.add(Element((num != "") ? int.parse(num) : 1,
        subscriptAllNums(eqArr[i].substring(j)), isReactant));
  }

  return result;
}

void printAnswer(List<Element> elements) {
  String top = "    ";
  String bottom = "    ";
  String middle = "K = ";
  String equation = "->";
  for (int i = 0; i < elements.length; i++) {
    if (elements[i].isReactant) {
      equation = "${elements[i].amount}${elements[i].element} " +
          ((bottom.length > 4) ? "+ " : "") +
          equation;
      bottom +=
          "[${elements[i].element}]${(elements[i].amount != 1) ? superscriptAllNums(elements[i].amount.toString()) : ""}";
    } else {
      equation += ((top.length > 4) ? " +" : "") +
          " ${elements[i].amount}${elements[i].element}";
      top +=
          "[${elements[i].element}]${(elements[i].amount != 1) ? superscriptAllNums(elements[i].amount.toString()) : ""}";
    }
  }

  for (int i = 0; i < max(top.length, bottom.length) - 3; i++) {
    middle += "-";
  }

  print("**Equilibrium Constant Problem**\n");
  print("Equation: $equation\n");
  print("Answer: \n");
  print(top);
  print(middle);
  print(bottom);
}

class Element {
  final int amount;
  final String element;
  final bool isReactant;

  const Element(this.amount, this.element, this.isReactant);
}

bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

String replaceCharAt(String oldString, int index, String newChar) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + 1);
}

String subscriptAllNums(String str) {
  for (int i = 0; i < str.length; i++) {
    if (isDigit(str, i)) {
      str = replaceCharAt(str, i, subscriptNum(str[i]));
    }
  }

  return str;
}

String superscriptAllNums(String str) {
  for (int i = 0; i < str.length; i++) {
    if (isDigit(str, i)) {
      str = replaceCharAt(str, i, superscriptNum(str[i]));
    }
  }

  return str;
}

String subscriptNum(String s) {
  var sMap = {
    "0": '\u2080',
    "1": '\u2081',
    "2": '\u2082',
    "3": '\u2083',
    "4": '\u2084',
    "5": '\u2085',
    "6": '\u2086',
    "7": '\u2087',
    "8": '\u2088',
    "9": '\u2089',
  };

  return (isDigit(s, 0)) ? sMap[s[0]] ?? s : s;
}

String superscriptNum(String s) {
  var sMap = {
    "0": '\u2070',
    "1": '\u00B9',
    "2": '\u00B2',
    "3": '\u00B3',
    "4": '\u2074',
    "5": '\u2075',
    "6": '\u2076',
    "7": '\u2077',
    "8": '\u2078',
    "9": '\u2079',
  };

  return (isDigit(s, 0)) ? sMap[s[0]] ?? s : s;
}
