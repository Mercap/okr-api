"
A KeyResultTest is a test class for testing the behavior of KeyResult
"
Class {
	#name : #KeyResultTest,
	#superclass : #TestCase,
	#category : #'OKR-Tests-Core'
}

{ #category : #tests }
KeyResultTest >> testComparing [

	| kr kr2 |

	kr := KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 20 percent.
	kr2 := KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 20 percent.
	self assert: kr equals: kr2
]

{ #category : #tests }
KeyResultTest >> testCreation [

	| kr |

	kr := KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 20 percent.
	self
		assert: kr description equals: 'Implementar modelo de Key Result';
		assert: kr weight equals: 20 percent
]

{ #category : #tests }
KeyResultTest >> testWeightMustBeAValidCompositionPercentage [

	self
		should: [ KeyResult describedBy: 'Implementar modelo de Key Result' weighted: -1 percent ]
			raise: AssertionFailed
			withMessageText: 'Key result weight must be a percentage between 0% and 100% (was -1%)';
		should: [ KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 0 percent ]
			raise: AssertionFailed
			withMessageText: 'Key result weight must be a percentage between 0% and 100% (was 0%)';
		should: [ KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 101 percent ]
			raise: AssertionFailed
			withMessageText: 'Key result weight must be a percentage between 0% and 100% (was 101%)'.

	self
		shouldnt: [ KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 1 percent ]
		raise: AssertionFailed.
	self
		shouldnt: [ KeyResult describedBy: 'Implementar modelo de Key Result' weighted: 100 percent ]
		raise: AssertionFailed
]
