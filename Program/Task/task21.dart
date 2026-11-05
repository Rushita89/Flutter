import 'dart:io';

void main() {
  for (int i = 1; i <= 4; i++) {
    for (int j = 0; j < i; j++) {
      stdout.write(String.fromCharCode(65 + j));
    }
    print("");
  }
}