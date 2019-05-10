Class {
	#name : #PeriodRESTfulControllerTest,
	#superclass : #ResourceRESTfulControllerTest,
	#instVars : [
		'periodManagementSystem'
	],
	#category : #'OKR-Tests-Controllers'
}

{ #category : #'private - support' }
PeriodRESTfulControllerTest >> baseUrl [

	^ 'https://api.mercap.net' asZnUrl 
]

{ #category : #'private - accessing' }
PeriodRESTfulControllerTest >> period2019Q1 [

	^ Period named: '2019Q1' from: March first , 2019 to: ( May , 2019 ) lastDate
]

{ #category : #'private - support' }
PeriodRESTfulControllerTest >> registerPeriod: aPeriod [ 
	
	periodManagementSystem startManagingPeriod: aPeriod
]

{ #category : #'private - accessing' }
PeriodRESTfulControllerTest >> requestToGet: aUrl accepting: anAcceptHeader [

	^ TeaRequest
		fromZnRequest:
			((ZnRequest get: aUrl)
				setAccept: anAcceptHeader;
				yourself)
]

{ #category : #'private - accessing' }
PeriodRESTfulControllerTest >> requestToGetPeriodsAccepting: anAcceptHeader [ 
	
	^ self requestToGet: self resourceUrl accepting: anAcceptHeader
]

{ #category : #running }
PeriodRESTfulControllerTest >> setUpResourceController [

	periodManagementSystem := PeriodManagementSystem new.
	
	resourceController := PeriodRESTfulController within: periodManagementSystem
]

{ #category : #tests }
PeriodRESTfulControllerTest >> testGetPeriodsWithOnlyOneManaged [

	| response period |

	period := self period2019Q1.
	self registerPeriod: period.

	response := resourceController
		getPeriodsBasedOn: ( self requestToGetPeriodsAccepting: '*/*' )
		within: self newHttpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType asMediaType
			equals: resourceController specification periodsVersion1dot0dot0MediaType.

	self
		withJsonFromContentsIn: response
		do: [ :periods | 
			self
				withTheOnlyOneIn: periods
				do: [ :foundPeriod | 
					self
						assert: foundPeriod name equals: period name asString;
						assert: foundPeriod startDate equals: period startDate asString;
						assert: foundPeriod endDate equals: period endDate asString;
						assert: ( foundPeriod links at: #self ) equals: ( self urlOf: period )
					]
			]
]

{ #category : #tests }
PeriodRESTfulControllerTest >> testGetWhenEmptyPeriods [

	| response |

	response := resourceController
		getPeriodsBasedOn: ( self requestToGetPeriodsAccepting: '*/*' )
		within: self newHttpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType asMediaType
			equals: resourceController specification periodsVersion1dot0dot0MediaType.

	self withJsonFromContentsIn: response do: [ :periods | self assert: periods isEmpty ]
]

{ #category : #'private - accessing' }
PeriodRESTfulControllerTest >> urlOf: aPeriod [ 
	
	^ (self resourceUrl / aPeriod uuid asString) asString
]
