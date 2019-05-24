"
An OKRRRESTfulAPIServerRunnerTest is a test class for testing the behavior of OKRRRESTfulAPIServerRunner
"
Class {
	#name : #OKRRRESTfulAPIServerRunnerTest,
	#superclass : #TestCase,
	#category : #'OKR-Tests-API'
}

{ #category : #tests }
OKRRRESTfulAPIServerRunnerTest >> testControllers [

	| controllers endpoints |

	controllers := OKRCommandLineHandler new controllers.
	endpoints := controllers collect: [ :controller | controller specification endpoint ].

	#('/periods') do: [ :endpoint | self assert: endpoints includes: endpoint ]
]

{ #category : #tests }
OKRRRESTfulAPIServerRunnerTest >> testRootSystem [

	| rootSystem |

	rootSystem := OKRCommandLineHandler new rootSystem.
	self
		assert: ( rootSystem systemsImplementing: #PeriodManagementSystem ) notEmpty;
		assert: ( rootSystem systemsImplementing: #KeyResultManagementSystem ) notEmpty
]
