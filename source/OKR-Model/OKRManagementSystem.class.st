Class {
	#name : #OKRManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'objectivesByUUID'
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
	objectivesByUUID := Dictionary new. 


]

{ #category : #'objective management' }
OKRManagementSystem >> keyResultsfor: anObjective [

	^objectivesByUUID at: anObjective uuid ifPresent: [:objective | objective keyResults ]
]

{ #category : #accessing }
OKRManagementSystem >> name [

	^ 'System to manage objectives and key results'
]

{ #category : #'objective management' }
OKRManagementSystem >> objectiveIdentifiedBy: anUUID ifFound: aBlock ifNone: aNoneBlock [

	^ objectivesByUUID at: anUUID ifPresent: aBlock ifAbsent: aNoneBlock
]

{ #category : #'objective management' }
OKRManagementSystem >> objectives [

	^ objectivesByUUID values
]

{ #category : #'objective management' }
OKRManagementSystem >> startManagingObjective: anObjective [

	objectivesByUUID at: anObjective uuid put: anObjective
]

{ #category : #'objective management' }
OKRManagementSystem >> stopManagingObjective: anObjective [

	objectivesByUUID removeKey: anObjective uuid

]

{ #category : #'objective management' }
OKRManagementSystem >> updateObjective: anObjective with: aNewObjective [

	objectivesByUUID at: anObjective uuid put: (anObjective synchronizeWith: aNewObjective)
]
