Class {
	#name : #OKRManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'repository'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #installing }
OKRManagementSystem >> dependencies [

	^ #()
]

{ #category : #installing }
OKRManagementSystem >> implementedInterfaces [

	^ #(#OKRManagementSystem)
]

{ #category : #initialization }
OKRManagementSystem >> initialize [

	super initialize.
	self setupInMemoryRepository
]

{ #category : #'objective management' }
OKRManagementSystem >> keyResultsfor: anObjective [

	^ repository
		withOneMatching: [ :objective | objective uuid = anObjective uuid ]
		do: [ :objective | objective keyResults ]
		else: [ ObjectNotFound signal ]
]

{ #category : #accessing }
OKRManagementSystem >> name [

	^ 'System to manage objectives and key results'
]

{ #category : #'objective management' }
OKRManagementSystem >> objectiveIdentifiedBy: anUUID ifFound: aBlock ifNone: aNoneBlock [

	^ repository withOneMatching: [ :objective | objective uuid = anUUID ] do: aBlock else: aNoneBlock
]

{ #category : #'objective management' }
OKRManagementSystem >> objectives [

	^ repository findAll
]

{ #category : #initialization }
OKRManagementSystem >> setupInMemoryRepository [

	repository := InMemoryRepository
		checkingConflictsAccordingTo: ( CriteriaBasedConflictCheckingStrategy forSingleAspectMatching: [ :objective | objective uuid ] )
]

{ #category : #'objective management' }
OKRManagementSystem >> startManagingObjective: anObjective [

	repository store: anObjective
]

{ #category : #'objective management' }
OKRManagementSystem >> stopManagingObjective: anObjective [

	repository purge: anObjective
]

{ #category : #'objective management' }
OKRManagementSystem >> updateObjective: anObjective with: aNewObjective [

	repository update: anObjective with: aNewObjective.
	
]
