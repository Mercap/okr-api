Class {
	#name : #Period,
	#superclass : #Object,
	#instVars : [
		'name',
		'startDate',
		'endDate',
		'uuid'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #'Instance creation' }
Period class >> named: aName from: aStartDate to: anEndDate [

	^ self new
		initializeNamed: aName from: aStartDate to: anEndDate;
		yourself
]

{ #category : #accessing }
Period >> endDate [

	^ endDate
]

{ #category : #initialization }
Period >> initializeNamed: aName from: aStartDate to: anEndDate [
	
	uuid := UUID new.
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

{ #category : #accessing }
Period >> uuid [
	
	^ uuid
]
