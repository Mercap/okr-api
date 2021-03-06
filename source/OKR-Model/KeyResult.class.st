Class {
	#name : #KeyResult,
	#superclass : #Object,
	#instVars : [
		'description',
		'weight'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #'Instance creation' }
KeyResult class >> describedBy: aDescription weighted: aPercentage [

	AssertionChecker
		enforce: [ aPercentage strictlyPositive and: [ aPercentage <= 100 percent ] ]
		because:
			( 'Key result weight must be a percentage between 0%% and 100%% (was <1p>)'
				expandMacrosWith: aPercentage ).

	^ self new initializeDescribedBy: aDescription weighted: aPercentage
]

{ #category : #comparing }
KeyResult >> = anotherKeyResult [

	^ description = anotherKeyResult description
		and: [ weight = anotherKeyResult weight ]
]

{ #category : #accessing }
KeyResult >> description [

	^ description
]

{ #category : #comparing }
KeyResult >> hash [

	^ description hash bitXor: weight hash
]

{ #category : #Initialization }
KeyResult >> initializeDescribedBy: aDescription weighted: aPercentage [

	description := aDescription.
	weight := aPercentage
]

{ #category : #accessing }
KeyResult >> weight [

	^ weight
]
