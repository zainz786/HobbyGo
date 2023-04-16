import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  test('Verify distance calculator', () {
    //distance between glasgow central and edinburgh waverly https://www.omnicalculator.com/other/latitude-longitude-distance

    double result = Geolocator.distanceBetween(55.85847787964206,
        -4.256816255204634, 55.95217315542521, -3.189959334033646);
    expect(result, isNot(67309));
  });
}
