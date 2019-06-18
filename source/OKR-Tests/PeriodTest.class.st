Class {
	#name : #PeriodTest,
	#superclass : #TestCase,
	#category : #'OKR-Tests-Core'
}

{ #category : #Testing }
PeriodTest >> testPeriodCreation [

	| period |

	period := Period named: '2019Q1' from: January first , 2019 to: ( March , 2019 ) lastDate.
	self assert: period name equals: '2019Q1'.
	self assert: period startDate equals: January first , 2019.
	self assert: period endDate equals: ( March , 2019 ) lastDate
]

{ #category : #Testing }
PeriodTest >> testPeriodSynchronization [

	| period anotherPeriod |

	period := Period named: '2019Q1' from: January first , 2019 to: ( March , 2019 ) lastDate.
	anotherPeriod := Period named: '2020Q1' from: January first , 2020 to: ( March , 2020 ) lastDate.
	
	period synchronizeWith: anotherPeriod. 
	
	self assert: period name equals: '2020Q1'.
	self assert: period startDate equals: January first , 2020.
	self assert: period endDate equals: ( March , 2020 ) lastDate
]

{ #category : #Testing }
PeriodTest >> testUUIDTrait [

	| period |

	period := Period named: '2019Q1' from: January first , 2019 to: ( March , 2019 ) lastDate.
	self assert: ( period uuid isA: UUID )
]
