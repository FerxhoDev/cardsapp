


import 'package:cardsapps/utils/capitalize.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test('capitalize', () {
    expect(
      capitalize(''),
      '',
    );
    expect(
      capitalize('TEXT'),
      'Text',
    );
    expect(
      capitalize('text'),
      'Text',
    );
    expect(
      capitalize('text text'),
      'Text text',
    );
    expect(
      capitalize('text text text'),
      'Text text text',
    );
  });
}