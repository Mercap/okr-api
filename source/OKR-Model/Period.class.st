Class {
	#name : #Period,
	#superclass : #Object,
	#traits : 'IdentifiableObject',
	#classTraits : 'IdentifiableObject classTrait',
	#instVars : [
		'name',
		'startDate',
		'endDate'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #'Instance creation' }
Period class >> named: aName from: aStartDate to: anEndDate [

	^ self new initializeNamed: aName from: aStartDate to: anEndDate
]

{ #category : #accessing }
Period >> endDate [

	^ endDate
]

{ #category : #initialization }
Period >> initializeNamed: aName from: aStartDate to: anEndDate [

	name := aName.
	startDate := aStartDate.
	endDate := anEndDate
]

{ #category : #accessing }
Period >> name [

	^ name
]

{ #category : #accessing }
Period >> startDate [

	^ startDate
]

{ #category : #synchronizing }
Period >> synchronizeWith: aPeriod [

	name := aPeriod name.
	startDate := aPeriod startDate.
	endDate := aPeriod endDate
]
