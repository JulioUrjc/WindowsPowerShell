<#PSScriptInfo

    .VERSION 1.0
    
    .GUID 48e4f6c2-ec4a-4360-97aa-811b257c4a85

    .AUTHOR Julio Martin

    .DESCRIPTION 
 		Se escucha por voz el texto introducido
 		
		System.Speech.Synthesis::VoiceGender

	Female  Indicates a female voice.
	Male    Indicates a male voice.
	Neutral	Indicates a gender-neutral voice.
	NotSet	Indicates no voice gender specification.

		System.Speech.Synthesis::VoiceAge

	Adult	Indicates an adult voice (age 30).
	Child	Indicates a child voice (age 10).
	NotSet	Indicates that no voice age is specified.
	Senior	Indicates a senior voice (age 65).
	Teen	Indicates a teenage voice (age 15).

#>
	[cmdletbinding()]
    param
    (
        [parameter(ValueFromPipeline=$true)][string[]] $prueba,
		$VoiceGender = "Male",
		$VoiceAge = "Adult",
		$voiceAlternate,
		$culture = "Es-es",
		$synth
	)

    Begin {
        Add-Type -AssemblyName System.speech
        $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
    }

    Process {
		$synth.SelectVoiceByHints($VoiceGender,$VoiceAge,$voiceAlternate,$culture)
		$synth.Speak( $prueba )
    }

    End {
       $synth.Dispose()
    }