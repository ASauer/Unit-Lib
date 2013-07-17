/*
\clip_scale

Creates an UMap for scaling a value to another range, with clipping and wrapping functionality.

value: the value upon which the scaling is applied (this can be another UMap as well)
fromRange: the used range of the input value
toRange: the range to map it to
invert: if true, the input range is inverted (i.e. low values become high and v.v.)
curve: a curvature value for the mapped range. If curve == 0, the range is linear.
clipMode: can be one of the following modes (Symbol):
	'clip' (default): clip values outside fromRange
	'fold': fold values outside fromRange
	'wrap': wrap around values outside fromRange
	'tanh': distort values to range with a tanh function
	'softclip': softclip values outside fromRange
	'distort': use a non-linear distortion curve to keep all values within range
	'wrap_sine': wrap values around fromRange, and then map them to a sine curve. This means that values at the borders of fromRange will return at the center of toRange.
	'none': no clipping applied (values can go outside toRange)

The value arg range is mapped to that of the parameter to which the UMap is connected.

--
this is an UMapDef definition file
part of the Unit lib default UMapDefs set
*/


UMapDef( \clip_scale, { |value = 0.0, fromRange = #[0.0, 1.0], toRange = #[0.0, 1.0], curve = 0.0, invert = 0, clipMode = 0|
	var sig;
	sig = value;
	sig = sig.linlin(*fromRange ++ [-1,1,\none]);
	sig = Select.kr( curve.inRange(-0.001,0.001), [
		sig.lincurve(-1,1,-1,1, curve, \none ),
		sig
	]);
	sig = if( invert, sig.neg, sig );
	sig = Select.kr( clipMode, [
		sig.clip2(1),
		sig.fold2(1),
		sig.wrap2(1),
		sig.tanh,
		sig.softclip,
		sig.distort,
		(sig.wrap2(1) * pi).sin,
		sig
	]);
	sig = sig.linlin(-1,1,*toRange ++ [ \none ]);
	UMapOut.kr(sig);
})
	.mappedArgs_([ \value, \fromRange, \toRange ])
	.setSpec( \clipMode, ListSpec( (..7), 0, [ 
		\clip, \fold, \wrap, \tanh, \softclip, \distort, \wrap_sine, \none 
		] ) 
	)
	.setSpec( \curve, [-16,16,\lin,0,0].asSpec )
	.setSpec( \invert, BoolSpec(false) )
	.category_( 'filter' )