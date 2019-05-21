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
KeyResultManagementSystemUserStoryTest >> testStartManagingKeyResult [

	| keyResult |

	keyResult := KeyResult describedBy: 'do something' weighted: 20 percent.

	self keyResultManagementSystem startManagingKeyResult: keyResult.

	self
		withTheOnlyOneIn: self keyResultManagementSystem keyResults
		do: [ :foundKeyResult | self assert: keyResult equals: foundKeyResult ]
]
