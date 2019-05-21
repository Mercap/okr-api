Class {
	#name : #ObjectiveManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'OKR-Tests-Core'
}

{ #category : #accessing }
ObjectiveManagementSystemUserStoryTest >> objectiveManagementSystem [
	
	^ rootSystem >> #ObjectiveManagementSystem
]

{ #category : #'private - running' }
ObjectiveManagementSystemUserStoryTest >> setUpRequirements [
	
	self registerSubsystem: ObjectiveManagementSystem new
]

{ #category : #'private - running' }
ObjectiveManagementSystemUserStoryTest >> testEmptySystem [

	self assert: self objectiveManagementSystem objectives isEmpty
]

{ #category : #'private - running' }
ObjectiveManagementSystemUserStoryTest >> testObjectiveIdentifiedBy [

	| q1 q2 found |

	q1 := Objective describedBy: 'An Objective' withKeyResults: #().
	q2 := Objective describedBy: 'Another Objective' withKeyResults: #().
	self objectiveManagementSystem
		startManagingObjective: q1;
		startManagingObjective: q2.

	found := false.
	self objectiveManagementSystem
		objectiveIdentifiedBy: q1 uuid
		ifFound: [ :objective | 
			self assert: objective equals: q1.
			found := true
			]
		ifNone: [ self fail ].
	self assert: found.

	found := false.
	self objectiveManagementSystem
		objectiveIdentifiedBy: q2 uuid
		ifFound: [ :objective | 
			self assert: objective equals: q2.
			found := true
			]
		ifNone: [ self fail ].
	self assert: found
]

{ #category : #'private - running' }
ObjectiveManagementSystemUserStoryTest >> testStartManagingObjective [

	| objective |

	objective := Objective describedBy: 'An Objective' withKeyResults: #().

	self objectiveManagementSystem startManagingObjective: objective.

	self
		withTheOnlyOneIn: self objectiveManagementSystem objectives
		do: [ :foundObjective | self assert: objective equals: foundObjective ]
]

{ #category : #'private - running' }
ObjectiveManagementSystemUserStoryTest >> testStopManagingObjective [

	| objective |

	objective := Objective describedBy: 'An Objective' withKeyResults: #().

	self objectiveManagementSystem startManagingObjective: objective.

	self
		withTheOnlyOneIn: self objectiveManagementSystem objectives
		do: [ :foundObjective | self assert: objective equals: foundObjective ]. 
		
	self objectiveManagementSystem stopManagingObjective: objective. 
	self assert: self objectiveManagementSystem objectives isEmpty
]
