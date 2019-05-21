Class {
	#name : #KeyResultManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'keyResults'
	],
	#category : #'OKR-Model-Core'
}

{ #category : #installing }
KeyResultManagementSystem >> dependencies [
	
	^ #()
]

{ #category : #installing }
KeyResultManagementSystem >> implementedInterfaces [
	
	^ #(#KeyResultManagementSystem)
]

{ #category : #initialization }
KeyResultManagementSystem >> initialize [

	super initialize. 
		
	keyResults := OrderedCollection new. 

]

{ #category : #querying }
KeyResultManagementSystem >> keyResultIdentifiedBy: anUUID ifFound: aBlock ifNone: aNoneBlock [

	^ keyResults detect: [ :keyResult | keyResult uuid = anUUID ] ifFound: aBlock ifNone: aNoneBlock
]

{ #category : #querying }
KeyResultManagementSystem >> keyResults [
	
	^ keyResults
]

{ #category : #accessing }
KeyResultManagementSystem >> name [

	^ 'System to manage key results'
]

{ #category : #managing }
KeyResultManagementSystem >> startManagingKeyResult: aKeyResult [

	keyResults add: aKeyResult
]

{ #category : #querying }
KeyResultManagementSystem >> stopManagingKeyResult: aKeyResult [

	keyResults remove: aKeyResult
]
