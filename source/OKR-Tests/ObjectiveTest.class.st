"
An ObjectiveTest is a test class for testing the behavior of Objective
"
Class {
	#name : #ObjectiveTest,
	#superclass : #TestCase,
	#category : #'OKR-Tests-Core'
}

{ #category : #tests }
ObjectiveTest >> testCreation [

	| objective keyResults |

	keyResults := {( KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 30 percent ).
	( KeyResult describedBy: 'Implementar sistema de Key Result' weighted: 30 percent ).
	( KeyResult describedBy: 'Implementar API de Key Result' weighted: 40 percent )}.
	objective := Objective describedBy: 'Implementar Key Results' withKeyResults: keyResults.
	self
		assert: objective description equals: 'Implementar Key Results';
		assertCollection: objective keyResults equals: keyResults
]

{ #category : #tests }
ObjectiveTest >> testUUIDTrait [

	| objective |

	objective := Objective describedBy: 'Implementar Key Results' withKeyResults: #().

	self assert: ( objective uuid isA: UUID )
]
