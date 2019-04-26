Class {
	#name : #PeriodTest,
	#superclass : #TestCase,
	#category : #'OKR-Tests'
}

{ #category : #Testing }
PeriodTest >> testsPeriodCreation [

	| period |

	period := Period named: '2019Q1' from: January first , 2019 to: ( March , 2019 ) lastDate.
	self assert: period name equals: '2019Q1'.
	self assert: period startDate equals: January first , 2019.
	self assert: period endDate equals: ( March , 2019 ) lastDate
]
