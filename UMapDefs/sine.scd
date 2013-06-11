
UMapDef( \sine, { |freq = 2, phase = 0, range = #[0.0,1.0]|
	var sig;
	sig = SinOsc.kr(freq, phase).range(*range);
	UMapOut.kr(sig);
})
	.setSpec( \phase, [-pi,pi,\lin,0,0] )
	.setSpec( \freq, FreqSpec(0.01,100, default: 2) )
	.category_( 'lfo' )