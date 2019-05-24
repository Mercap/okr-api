"
An OKRRRESTfulAPIServerRunnerTest is a test class for testing the behavior of OKRRRESTfulAPIServerRunner
"
Class {
	#name : #OKRRRESTfulAPIServerRunnerTest,
	#superclass : #TestCase,
	#category : #'OKR-Tests-API'
}

{ #category : #accessing }
OKRRRESTfulAPIServerRunnerTest >> implementedEndpoints [

	^ ResourceRESTfulControllerSpecification allSubclasses
		select: [ :class | class package name beginsWith: ( self class package name copyUpTo: $- ) ]
		thenCollect: [ :spec | spec new endpoint ]
]

{ #category : #tests }
OKRRRESTfulAPIServerRunnerTest >> testControllers [

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
OKRRRESTfulAPIServerRunnerTest >> testRootSystem [

	| rootSystem |

	rootSystem := OKRCommandLineHandler new rootSystem.
	self
		deny: ( rootSystem systemsImplementing: #PeriodManagementSystem ) isEmpty;
		deny: ( rootSystem systemsImplementing: #OKRManagementSystem ) isEmpty
]
