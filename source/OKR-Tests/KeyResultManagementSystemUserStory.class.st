Class {
	#name : #KeyResultManagementSystemUserStory,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'OKR-Tests-Core'
}

{ #category : #accessing }
KeyResultManagementSystemUserStory >> keyResultManagementSystem [

	^ rootSystem >> #KeyResultManagementSystem
]

{ #category : #'private - running' }
KeyResultManagementSystemUserStory >> setUpRequirements [

	self registerSubsystem: KeyResultManagementSystem new
]

{ #category : #'private - running' }
KeyResultManagementSystemUserStory >> testEmptySystem [

	self assert: self keyResultManagementSystem keyResults isEmpty
]

{ #category : #'private - running' }
KeyResultManagementSystemUserStory >> testStartManagingKeyResult [

	| keyResult |

	keyResult := KeyResult describedBy: 'do something' weighted: 20 percent.

	self keyResultManagementSystem startManagingKeyResult: keyResult.

	self
		withTheOnlyOneIn: self keyResultManagementSystem keyResults
		do: [ :foundKeyResult | self assert: keyResult equals: foundKeyResult ]
]
