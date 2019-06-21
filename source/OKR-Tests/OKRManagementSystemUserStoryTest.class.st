Class {
	#name : #OKRManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'OKR-Tests-UserStory'
}

{ #category : #accessing }
OKRManagementSystemUserStoryTest >> okrManagementSystem [

	^ rootSystem >> #OKRManagementSystem
]

{ #category : #'private - running' }
OKRManagementSystemUserStoryTest >> setUpRequirements [

	self registerSubsystem: OKRManagementSystem new
]

{ #category : #'private - running' }
OKRManagementSystemUserStoryTest >> testEmptySystem [

	self assert: self okrManagementSystem objectives isEmpty
]

{ #category : #' testing - objectives' }
OKRManagementSystemUserStoryTest >> testKeyResultsForObjectiveNotManagedShouldRaiseError [

	| objective keyResult |

	objective := Objective describedBy: 'An Objective' withKeyResults: #().
	
	self should: [self okrManagementSystem keyResultsfor: objective ] raise: ObjectNotFound
	
]

{ #category : #' testing - objectives' }
OKRManagementSystemUserStoryTest >> testObjectiveIdentifiedBy [

	| q1 q2 found |

	q1 := Objective describedBy: 'An Objective' withKeyResults: #().
	q2 := Objective describedBy: 'Another Objective' withKeyResults: #().
	self okrManagementSystem
		startManagingObjective: q1;
		startManagingObjective: q2.

	found := false.
	self okrManagementSystem
		objectiveIdentifiedBy: q1 uuid
		ifFound: [ :objective | 
			self assert: objective equals: q1.
			found := true
			]
		ifNone: [ self fail ].
	self assert: found.

	found := false.
	self okrManagementSystem
		objectiveIdentifiedBy: q2 uuid
		ifFound: [ :objective | 
			self assert: objective equals: q2.
			found := true
			]
		ifNone: [ self fail ].
	self assert: found
]

{ #category : #' testing - objectives' }
OKRManagementSystemUserStoryTest >> testStartManagingObjective [

	| objective |

	objective := Objective describedBy: 'An Objective' withKeyResults: #().

	self okrManagementSystem startManagingObjective: objective.

	self
		withTheOnlyOneIn: self okrManagementSystem objectives
		do: [ :foundObjective | self assert: objective equals: foundObjective ]
]

{ #category : #' testing - objectives' }
OKRManagementSystemUserStoryTest >> testStartManagingObjectiveRaiseErrorForSameObjective [

	| objective |

	objective := Objective describedBy: 'An Objective' withKeyResults: #().

	self okrManagementSystem startManagingObjective: objective.

	self
		withTheOnlyOneIn: self okrManagementSystem objectives
		do: [ :foundObjective | self assert: objective equals: foundObjective ].

	self
		should: [ self okrManagementSystem startManagingObjective: objective ]
		raise: ConflictingObjectFound
]

{ #category : #'testing - key results' }
OKRManagementSystemUserStoryTest >> testStartManagingObjectiveWithKeyResult [

	| keyResult objective |

	keyResult := KeyResult describedBy: 'do something' weighted: 20 percent.
	objective := Objective describedBy: 'An Objective' withKeyResults: {keyResult}.

	self okrManagementSystem startManagingObjective: objective.

	self
		withTheOnlyOneIn: self okrManagementSystem objectives
		do: [ :foundObjective | self assert: objective equals: foundObjective ].

	self
		withTheOnlyOneIn: ( self okrManagementSystem keyResultsfor: objective )
		do: [ :foundKeyResult | self assert: keyResult equals: foundKeyResult ]
]

{ #category : #' testing - objectives' }
OKRManagementSystemUserStoryTest >> testStopManagingObjective [

	| objective |

	objective := Objective describedBy: 'An Objective' withKeyResults: #().

	self okrManagementSystem startManagingObjective: objective.

	self
		withTheOnlyOneIn: self okrManagementSystem objectives
		do: [ :foundObjective | self assert: objective equals: foundObjective ].

	self okrManagementSystem stopManagingObjective: objective.
	self assert: self okrManagementSystem objectives isEmpty
]

{ #category : #' testing - objectives' }
OKRManagementSystemUserStoryTest >> testStopManagingObjectiveRaiseErrorWhenNotPresent [

	| objective |

	objective := Objective describedBy: 'An Objective' withKeyResults: #().

	self should: [ self okrManagementSystem stopManagingObjective: objective ] raise: ObjectNotFound
]

{ #category : #' testing - objectives' }
OKRManagementSystemUserStoryTest >> testUpdateObjective [

	| objective keyResult |

	objective := Objective describedBy: 'An Objective' withKeyResults: #().
	self okrManagementSystem startManagingObjective: objective.
	self
		withTheOnlyOneIn: self okrManagementSystem objectives
		do: [ :foundObjective | self assert: objective equals: foundObjective ].
	self assert: ( self okrManagementSystem keyResultsfor: objective ) isEmpty.
	keyResult := KeyResult describedBy: 'do something' weighted: 20 percent.

	self okrManagementSystem
		updateObjective: objective
		with: ( Objective describedBy: 'An Objective' withKeyResults: {keyResult} ).

	self
		withTheOnlyOneIn: ( self okrManagementSystem keyResultsfor: objective )
		do: [ :foundKeyResult | self assert: keyResult equals: foundKeyResult ]
]
