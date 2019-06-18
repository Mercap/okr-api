Class {
	#name : #OKRCommandLineHandler,
	#superclass : #ApplicationStarterCommandLineHandler,
	#category : #'OKR-Model-API'
}

{ #category : #accessing }
OKRCommandLineHandler class >> commandName [

	^ 'start'
]

{ #category : #accessing }
OKRCommandLineHandler class >> description [

	^ 'Start OKR API'
]

{ #category : #activation }
OKRCommandLineHandler >> basicActivate [

	<ignoreForCoverage>
	self
		startServedOn: ( self configuration at: #'api-server-url' )
		listeningOn: ( self configuration at: #port )
]

{ #category : #'private - accessing' }
OKRCommandLineHandler >> configurationDefinition [

	^ OrderedCollection new
		add: ( MandatoryArgument named: #'api-server-url' );
		add: ( OptionalArgument named: #port defaultingTo: 8080 convertingWith: #asNumber );
		yourself
]

{ #category : #'private - accessing' }
OKRCommandLineHandler >> controllers [

	| rootSystem |

	rootSystem := self rootSystem.

	^ OrderedCollection new
		add: ( PeriodRESTfulController within: rootSystem >> #PeriodManagementSystem );
		add: ( ObjectiveRESTfulController within: rootSystem >> #OKRManagementSystem );
		add:
			( KeyResultsRESTfulController
				within: ( ObjectiveRESTfulController within: rootSystem >> #OKRManagementSystem ) );
		asArray
]

{ #category : #'private - accessing' }
OKRCommandLineHandler >> logPrefix [

	^ 'okr'
]

{ #category : #'private - accessing' }
OKRCommandLineHandler >> rootSystem [

	^ CompositeSystem new
		register: PeriodManagementSystem new;
		register: OKRManagementSystem new;
		yourself
]

{ #category : #controlling }
OKRCommandLineHandler >> startServedOn: anUrl listeningOn: aPort [

	<ignoreForCoverage>
	| server |

	server := HTTPBasedRESTfulAPI
		configuredBy:
			{( #port -> aPort ).
			( #serverUrl -> anUrl )}
		installing: self controllers.

	server
		install;
		start
]
