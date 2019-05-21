Class {
	#name : #KeyResultManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'OKR-Tests-Core'
}

{ #category : #accessing }
KeyResultManagementSystemUserStoryTest >> keyResultManagementSystem [

	^ rootSystem >> #KeyResultManagementSystem
]

{ #category : #'private - running' }
KeyResultManagementSystemUserStoryTest >> setUpRequirements [

	self registerSubsystem: KeyResultManagementSystem new
]

{ #category : #'private - running' }
KeyResultManagementSystemUserStoryTest >> testEmptySystem [

	self assert: self keyResultManagementSystem keyResults isEmpty
]

{ #category : #'private - running' }
KeyResultManagementSystemUserStoryTest >> testKeyResultIdentifiedBy [

	| q1 q2 found |

	q1 := KeyResult describedBy: 'do something' weighted: 20 percent.
	q2 := KeyResult describedBy: 'do some otherthing' weighted: 30 percent.
	self keyResultManagementSystem
		startManagingKeyResult: q1;
		startManagingKeyResult: q2.

	found := false.
	self keyResultManagementSystem
		keyResultIdentifiedBy: q1 uuid
		ifFound: [ :keyResult | 
			self assert: keyResult equals: q1.
			found := true
			]
		ifNone: [ self fail ].
	self assert: found.

	found := false.
	self keyResultManagementSystem
		keyResultIdentifiedBy: q2 uuid
		ifFound: [ :keyResult | 
			self assert: keyResult equals: q2.
			found := true
			]
		ifNone: [ self fail ].
	self assert: found
]

{ #category : #'private - running' }
KeyResultManagementSystemUserStoryTest >> testStartManagingKeyResult [

	| keyResult |

	keyResult := KeyResult describedBy: 'do something' weighted: 20 percent.

	self keyResultManagementSystem startManagingKeyResult: keyResult.

	self
		withTheOnlyOneIn: self keyResultManagementSystem keyResults
		do: [ :foundKeyResult | self assert: keyResult equals: foundKeyResult ]
]

{ #category : #'private - running' }
KeyResultManagementSystemUserStoryTest >> testStopManagingKeyResult [

	| keyResult |

	keyResult := KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 20 percent.

	self keyResultManagementSystem startManagingKeyResult: keyResult.

	self
		withTheOnlyOneIn: self keyResultManagementSystem keyResults
		do: [ :foundKeyResult | self assert: keyResult equals: foundKeyResult ].

	self keyResultManagementSystem stopManagingKeyResult: keyResult.
	self assert: self keyResultManagementSystem keyResults isEmpty
]
