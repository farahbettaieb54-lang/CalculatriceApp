
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculatrice',
      theme: ThemeData.dark(),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  String operation = '';
  double? firstNumber;
  String operator = '';
  bool newNumber = false;

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        operation = '';
        firstNumber = null;
        operator = '';
        newNumber = false;
        return;
      }

      if (value == '+' ||
          value == '-' ||
          value == '×' ||
          value == '÷' ||
          value == '%') {
        firstNumber = double.tryParse(display);
        operator = value;
        operation = '$display $value';
        newNumber = true;
        return;
      }

      if (value == '=') {
        if (firstNumber == null || operator.isEmpty) return;

        double secondNumber = double.tryParse(display) ?? 0;
        double result;

        switch (operator) {
          case '+':
            result = firstNumber! + secondNumber;
            break;
          case '-':
            result = firstNumber! - secondNumber;
            break;
          case '×':
            result = firstNumber! * secondNumber;
            break;
          case '÷':
            if (secondNumber == 0) {
              display = 'Erreur';
              operation = '';
              operator = '';
              firstNumber = null;
              newNumber = true;
              return;
            }
            result = firstNumber! / secondNumber;
            break;
          case '%':
            if (secondNumber == 0) {
              display = 'Erreur';
              operation = '';
              operator = '';
              firstNumber = null;
              newNumber = true;
              return;
            }
            result = firstNumber! % secondNumber;
            break;
          default:
            return;
        }

        operation = '$firstNumber $operator $secondNumber =';
        display = result.isFinite
            ? (result % 1 == 0
                ? result.toInt().toString()
                : result.toString())
            : 'Erreur';

        operator = '';
        firstNumber = null;
        newNumber = true;
        return;
      }

      if (value == '.') {
        if (newNumber) {
          display = '0.';
          newNumber = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
        return;
      }

      if (value == '±') {
        if (display != '0' && display != 'Erreur') {
          display = display.startsWith('-')
              ? display.substring(1)
              : '-$display';
        }
        return;
      }

      if (newNumber || display == '0' || display == 'Erreur') {
        display = value;
        newNumber = false;
      } else {
        display += value;
      }
    });
  }

  Widget buildButton(
    String text, {
    Color color = const Color(0xFF333333),
    Color textColor = Colors.white,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 72,
          child: ElevatedButton(
            onPressed: () => buttonPressed(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: textColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(List<Widget> buttons) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      operation,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 22,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        display,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: buildRow([
                        buildButton('C',
                            color: const Color(0xFF666666)),
                        buildButton('±',
                            color: const Color(0xFF666666)),
                        buildButton('%',
                            color: const Color(0xFF666666)),
                        buildButton('÷',
                            color: const Color(0xFFFF9500)),
                      ]),
                    ),
                    Expanded(
                      child: buildRow([
                        buildButton('7'),
                        buildButton('8'),
                        buildButton('9'),
                        buildButton('×',
                            color: const Color(0xFFFF9500)),
                      ]),
                    ),
                    Expanded(
                      child: buildRow([
                        buildButton('4'),
                        buildButton('5'),
                        buildButton('6'),
                        buildButton('-',
                            color: const Color(0xFFFF9500)),
                      ]),
                    ),
                    Expanded(
                      child: buildRow([
                        buildButton('1'),
                        buildButton('2'),
                        buildButton('3'),
                        buildButton('+',
                            color: const Color(0xFFFF9500)),
                      ]),
                    ),
                    Expanded(
                      child: buildRow([
                        buildButton('0', flex: 2),
                        buildButton('.'),
                        buildButton('=',
                            color: const Color(0xFFFF9500)),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
