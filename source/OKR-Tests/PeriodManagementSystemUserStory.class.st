Class {
	#name : #PeriodManagementSystemUserStory,
	#superclass : #SystemBasedUserStoryTest,
	#category : #'OKR-Tests'
}

{ #category : #accessing }
PeriodManagementSystemUserStory >> periodManagementSystem [
	
	^ rootSystem >> #PeriodManagementSystem
]

{ #category : #'private - running' }
PeriodManagementSystemUserStory >> setUpRequirements [
	
	self registerSubsystem: PeriodManagementSystem new
]

{ #category : #'private - running' }
PeriodManagementSystemUserStory >> testEmptySystem [

	self assert: self periodManagementSystem periods isEmpty. 
]

{ #category : #'private - running' }
PeriodManagementSystemUserStory >> testStartManagingPeriod [

	| period | 
	
	period := Period named: '2019Q1' from: (March first, 2019) to: (May, 2019) lastDate.
	
	self periodManagementSystem startManagingPeriod: period.
	
	self withTheOnlyOneIn: self periodManagementSystem periods do: [ :foundPeriod | 
		self assert: period equals: foundPeriod
		 ] 
]
