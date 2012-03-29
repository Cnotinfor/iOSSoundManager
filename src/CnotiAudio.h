//
//  CnotiAudio.h
//

#ifndef CNOTIAUDIO
#define CNOTIAUDIO

/**
 An enumeration of Mozart instruments
 */
enum EnumInstrument
{
	Instrument_PIANO=1,//--> NOT AVAILABLE IN THIS VERSION
	Instrument_FLUTE=2,
	Instrument_VIOLIN=3,//--> NOT AVAILABLE IN THIS VERSION
	Instrument_XYLOPHONE=4,//--> NOT AVAILABLE IN THIS VERSION
	Instrument_TRUMPET=5
};

/**
 An enumeration of the Mozart buddies rhythms
 */
enum EnumRhythm
{
	Rhythm_CHINESE_BOX=0,  // Caixa Chinesa
	Rhythm_BASS_DRUM=1,    // Bombo --> NOT AVAILABLE IN THIS VERSION
	Rhythm_CONGAS=2, //--> NOT AVAILABLE IN THIS VERSION
	Rhythm_TAMBOURINE=3,   // Pandeireta
	Rhythm_TRIANGLE=4,//--> NOT AVAILABLE IN THIS VERSION
	Rhythm_BEAT_BOX=5//--> NOT AVAILABLE IN THIS VERSION
};

/**
 An enumeration of musical notes
 */
enum EnumNote
{
	Note_PAUSE = -1,
	Note_DO = 0,
	Note_DOs,
	Note_RE,
	Note_REs,
	Note_MI,
	Note_FA,
	Note_FAs,
	Note_SOL,
	Note_SOLs,
	Note_LA,
	Note_LAs,
	Note_SI
};


/**
 An enumeration of the Mozart buddies rhythms variations
 */
enum EnumRhythmVariation
{
	RhythmVariation_NO_RHYTHM = -1,
	RhythmVariation_RHYTHM_01 = 0,
	RhythmVariation_RHYTHM_02,
	RhythmVariation_RHYTHM_03,
	RhythmVariation_RHYTHM_04,
	RhythmVariation_RHYTHM_05,
	RhythmVariation_RHYTHM_06,
	RhythmVariation_RHYTHM_07,
	RhythmVariation_RHYTHM_08,
	RhythmVariation_RHYTHM_09,
	RhythmVariation_RHYTHM_10
};

/**
 An enumeration of the duration of the notes and rhythms
 */
enum EnumDuration
{
	Duration_LONGA=512,
	Duration_BREVE=256,
	Duration_SEMIBREVE_DOTTED=192,
	Duration_SEMIBREVE=128,
	Duration_MINIM_DOTTED=96,
	Duration_MINIM=64,
	Duration_CROTCHET_DOTTED=48,
	Duration_CROTCHET=32,				// Semiminima
	Duration_QUAVER_HALF=24,
	Duration_QUAVER=16,					// Colcheia
	Duration_SEMIQUAVER=8,
	Duration_DEMISEMIQUAVER=4,			// Fuse
	Duration_HEMIDEMISEMIQUAVER=2,		// Semifusa
	Duration_SEMIHEMIDEMISEMIQUAVER=1,	// Quartifusa
	Duration_UNKNOWN_DURATION=0
};


/**
 An enumeration of the speed of the music (BPM)
 */
enum EnumTempo
{
	Tempo_Tempo60=60,
	Tempo_Tempo120=120,
	Tempo_Tempo160=160,
	Tempo_Tempo200=200
};

#endif