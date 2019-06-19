Class {
	#name : #PeriodManagementSystemUserStoryTest,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'OKR-Tests-UserStory'
}

{ #category : #accessing }
PeriodManagementSystemUserStoryTest >> periodManagementSystem [

	^ rootSystem >> #PeriodManagementSystem
]

{ #category : #'private - running' }
PeriodManagementSystemUserStoryTest >> setUpRequirements [
	
	self registerSubsystem: PeriodManagementSystem new
]

{ #category : #'private - running' }
PeriodManagementSystemUserStoryTest >> testEmptySystem [

	self assert: self periodManagementSystem periods isEmpty
]

{ #category : #'private - running' }
PeriodManagementSystemUserStoryTest >> testPeriodIdentifiedBy [

	| q1 q2 found |

	q1 := Period named: '2019Q1' from: March first , 2019 to: ( May , 2019 ) lastDate.
	q2 := Period named: '2019Q2' from: June first , 2019 to: ( August , 2019 ) lastDate.
	self periodManagementSystem
		startManagingPeriod: q1;
		startManagingPeriod: q2.

	found := false.
	self periodManagementSystem
		periodIdentifiedBy: q1 uuid
		ifFound: [ :period | 
			self assert: period equals: q1.
			found := true
			]
		ifNone: [ self fail ].
	self assert: found.

	found := false.
	self periodManagementSystem
		periodIdentifiedBy: q2 uuid
		ifFound: [ :period | 
			self assert: period equals: q2.
			found := true
			]
		ifNone: [ self fail ].
	self assert: found
]

{ #category : #'private - running' }
PeriodManagementSystemUserStoryTest >> testStartManagingPeriod [

	| period |

	period := Period named: '2019Q1' from: March first , 2019 to: ( May , 2019 ) lastDate.

	self periodManagementSystem startManagingPeriod: period.

	self
		withTheOnlyOneIn: self periodManagementSystem periods
		do: [ :foundPeriod | self assert: period equals: foundPeriod ]
]

{ #category : #'private - running' }
PeriodManagementSystemUserStoryTest >> testStartManagingPeriodRaiseErrorForSamePeriod [

	| period |

	period := Period named: '2019Q1' from: March first , 2019 to: ( May , 2019 ) lastDate.

	self periodManagementSystem startManagingPeriod: period.

	self
		withTheOnlyOneIn: self periodManagementSystem periods
		do: [ :foundPeriod | self assert: period equals: foundPeriod ].

	self
		should: [ self periodManagementSystem startManagingPeriod: period ]
		raise: ConflictingObjectFound
]

{ #category : #'private - running' }
PeriodManagementSystemUserStoryTest >> testStopManagingPeriod [

	| period |

	period := Period named: '2019Q1' from: March first , 2019 to: ( May , 2019 ) lastDate.

	self periodManagementSystem startManagingPeriod: period.

	self
		withTheOnlyOneIn: self periodManagementSystem periods
		do: [ :foundPeriod | self assert: period equals: foundPeriod ]. 
		
	self periodManagementSystem stopManagingPeriod: period. 
	self assert: self periodManagementSystem periods isEmpty
]

{ #category : #'private - running' }
PeriodManagementSystemUserStoryTest >> testStopManagingPeriodRaiseErrorWhenNotPresent [

	| period |

	period := Period named: '2019Q1' from: March first , 2019 to: ( May , 2019 ) lastDate.

	self should: [ self periodManagementSystem stopManagingPeriod: period ] raise: ObjectNotFound
]
