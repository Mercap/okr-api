Class {
	#name : #Objective,
	#superclass : #Object,
	#traits : 'IdentifiableObject',
	#classTraits : 'IdentifiableObject classTrait',
	#instVars : [
		'description',
		'keyResults'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #'Instance creation' }
Objective class >> describedBy: aDescription withKeyResults: aCollection [

	^ self new initializeDescribedBy: aDescription withKeyResults: aCollection
]

{ #category : #accessing }
Objective >> description [

	^ description
]

{ #category : #initialization }
Objective >> initializeDescribedBy: aDescription withKeyResults: aCollection [

	description := aDescription.
	keyResults := aCollection
]

{ #category : #accessing }
Objective >> keyResults [

	^ keyResults
]

{ #category : #synchronizing }
Objective >> synchronizeWith: anObjective [

	description := anObjective description.
	keyResults := anObjective keyResults
]
