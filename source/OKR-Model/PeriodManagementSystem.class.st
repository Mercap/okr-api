Class {
	#name : #PeriodManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'repository'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #installing }
PeriodManagementSystem >> dependencies [

	^ #()
]

{ #category : #installing }
PeriodManagementSystem >> implementedInterfaces [

	^ #(#PeriodManagementSystem)
]

{ #category : #initialization }
PeriodManagementSystem >> initialize [

	super initialize.
	self setupInMemoryRepository.

]

{ #category : #accessing }
PeriodManagementSystem >> name [

	^ 'System to manage periods'
]

{ #category : #querying }
PeriodManagementSystem >> periodIdentifiedBy: anUUID ifFound: aBlock ifNone: aNoneBlock [

	^ repository withOneMatching: [ :period | period uuid = anUUID ] do: aBlock else: aNoneBlock
]

{ #category : #querying }
PeriodManagementSystem >> periods [

	^ repository findAll
]

{ #category : #initialization }
PeriodManagementSystem >> setupInMemoryRepository [

	repository := InMemoryRepository
		checkingConflictsAccordingTo: ( CriteriaBasedConflictCheckingStrategy forSingleAspectMatching: [ :period | period uuid ] )
]

{ #category : #managing }
PeriodManagementSystem >> startManagingPeriod: aPeriod [

	repository store: aPeriod
]

{ #category : #managing }
PeriodManagementSystem >> stopManagingPeriod: aPeriod [

	repository purge: aPeriod
]
