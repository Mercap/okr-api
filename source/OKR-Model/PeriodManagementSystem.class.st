Class {
	#name : #PeriodManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'periods'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #installing }
PeriodManagementSystem >> dependencies [
	
	^ #()
]

{ #category : #installing }
PeriodManagementSystem >> implementedInterfaces [
	
	^ #(#PeriodManagementSystem)
]

{ #category : #accessing }
PeriodManagementSystem >> initialize [

	super initialize. 
		
	periods := OrderedCollection new. 

]

{ #category : #accessing }
PeriodManagementSystem >> name [

	^ 'System to manage periods'
]

{ #category : #querying }
PeriodManagementSystem >> periodIdentifiedBy: anUUID ifFound: aBlock ifNone: aNoneBlock [

	^ periods detect: [ :period | period uuid = anUUID ] ifFound: aBlock ifNone: aNoneBlock
]

{ #category : #accessing }
PeriodManagementSystem >> periods [
	
	^ periods
]

{ #category : #managing }
PeriodManagementSystem >> startManagingPeriod: aPeriod [ 
	
	periods add: aPeriod
]
