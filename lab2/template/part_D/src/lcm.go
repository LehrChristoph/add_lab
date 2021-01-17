package goexamples

func LCM(a uint8, b uint8) uint16 {
	var sumA uint16
	sumA = a
	var sumB uint16
	sumB = b

	if sumA<sumB{
		sumA = sumA + a
	} else {
		sumB = sumB + b
	}

	for sumA != sumB {
		if sumA<sumB{
			sumA = sumA + a
		} else {
			sumB = sumB + b
		}
	}
	return sumA
}
