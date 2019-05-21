Class {
	#name : #ObjectiveManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'objectives'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #installing }
ObjectiveManagementSystem >> dependencies [

	^ #()
]

{ #category : #installing }
ObjectiveManagementSystem >> implementedInterfaces [

	^ #(#ObjectiveManagementSystem)
]

{ #category : #initialization }
ObjectiveManagementSystem >> initialize [

	super initialize. 
		
	objectives := OrderedCollection new. 

]

{ #category : #accessing }
ObjectiveManagementSystem >> name [

	^ 'System to manage objectives'
]

{ #category : #querying }
ObjectiveManagementSystem >> objectiveIdentifiedBy: anUUID ifFound: aBlock ifNone: aNoneBlock [

	^ objectives detect: [ :objective | objective uuid = anUUID ] ifFound: aBlock ifNone: aNoneBlock
]

{ #category : #querying }
ObjectiveManagementSystem >> objectives [

	^ objectives
]

{ #category : #managing }
ObjectiveManagementSystem >> startManagingObjective: anObjective [

	objectives add: anObjective
]

{ #category : #'managing container' }
ObjectiveManagementSystem >> stopManagingObjective: anObjective [

	objectives remove: anObjective
]
