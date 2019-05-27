"
An OKRRRESTfulAPIServerRunnerTest is a test class for testing the behavior of OKRRRESTfulAPIServerRunner
"
Class {
	#name : #OKRCommandLineHandlerTest,
	#superclass : #TestCase,
	#category : #'OKR-Tests-API'
}

{ #category : #accessing }
OKRCommandLineHandlerTest >> implementedEndpoints [

	^ ResourceRESTfulControllerSpecification allSubclasses
		select: [ :class | class package name beginsWith: ( self class package name copyUpTo: $- ) ]
		thenCollect: [ :spec | spec new endpoint ]
]

{ #category : #tests }
OKRCommandLineHandlerTest >> testAccessing [

	| handler |

	handler := OKRCommandLineHandler
		commandLine:
			( CommandLineArguments
				withArguments:
					{OKRCommandLineHandler commandName.
					'--api-server-url=/'.
					'--port=8888'} ).
	self
		assert: OKRCommandLineHandler commandName equals: 'start';
		assert: OKRCommandLineHandler description equals: 'Start OKR API';
		assert: handler logPrefix equals: 'okr';
		assert: ( handler configuration at: #port ) equals: 8888;
		assert: ( handler configuration at: #'api-server-url' ) equals: '/'
]

{ #category : #tests }
OKRCommandLineHandlerTest >> testControllers [

	| controllers endpoints |

	controllers := OKRCommandLineHandler new controllers.
	endpoints := controllers collect: [ :controller | controller specification endpoint ].
	self implementedEndpoints
		do: [ :endpoint | 
			self
				assert: ( endpoints includes: endpoint )
				description: ( '<1s> is implemented but not included on the installed controllers' expandMacrosWith: endpoint )
			]
]

{ #category : #tests }
OKRCommandLineHandlerTest >> testRootSystem [

	| rootSystem |

	rootSystem := OKRCommandLineHandler new rootSystem.
	self
		deny: ( rootSystem systemsImplementing: #PeriodManagementSystem ) isEmpty;
		deny: ( rootSystem systemsImplementing: #OKRManagementSystem ) isEmpty
]
