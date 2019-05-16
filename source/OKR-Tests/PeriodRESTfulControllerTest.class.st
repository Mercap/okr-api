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

{ #category : #'private - support' }
PeriodRESTfulControllerTest >> defaultPeriodMediaType [

	^ resourceController specification periodVersion1dot0dot0MediaType
]

{ #category : #'private - support' }
PeriodRESTfulControllerTest >> registerPeriod: aPeriod [

	periodManagementSystem startManagingPeriod: aPeriod
]

{ #category : #'private -  support' }
PeriodRESTfulControllerTest >> requestToCreatePeriodFrom: aJSON [

	^ self requestToPOST: aJSON as: self defaultPeriodMediaType
]

{ #category : #'private - accessing' }
PeriodRESTfulControllerTest >> requestToGet: aUrl accepting: anAcceptHeader [

	^ TeaRequest
		fromZnRequest:
			( ( ZnRequest get: aUrl )
				setAccept: anAcceptHeader;
				yourself )
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
PeriodRESTfulControllerTest >> testCreatePeriod [

	| response |

	self assert: periodManagementSystem periods isEmpty.
	response := resourceController
		createPeriodBasedOn:
			( self
				requestToCreatePeriodFrom: '{"name":"2018Q4","startDate":"2018-10-01","endDate":"2018-12-31"}' )
		within: self newHttpRequestContext.

	self
		assert: response isCreated;
		withTheOnlyOneIn: periodManagementSystem periods
			do: [ :foundPeriod | 
			self
				assert: response location equals: ( self urlOf: foundPeriod );
				assert: foundPeriod name equals: '2018Q4';
				assert: foundPeriod startDate equals: October first , 2018;
				assert: foundPeriod endDate equals: December lastDayOfMonth , 2018
			]
]

{ #category : #tests }
PeriodRESTfulControllerTest >> testGetPeriodsWithOnlyOneManaged [

	| response period |

	period := Period named: '2019Q1' from: March first , 2019 to: ( May , 2019 ) lastDate.
	self registerPeriod: period.

	response := resourceController
		getPeriodsBasedOn: ( self requestToGetPeriodsAccepting: '*/*' )
		within: self newHttpRequestContext.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType asMediaType
			equals: resourceController specification periodVersion1dot0dot0MediaType.

	self
		withJsonFromContentsIn: response
		do: [ :periods | 
			self
				withTheOnlyOneIn: periods
				do: [ :foundPeriod | 
					self
						assert: foundPeriod name equals: period name asString;
						assert: foundPeriod startDate equals: '2019-03-01';
						assert: foundPeriod endDate equals: '2019-05-31';
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
			equals: resourceController specification periodVersion1dot0dot0MediaType.

	self withJsonFromContentsIn: response do: [ :periods | self assert: periods isEmpty ]
]

{ #category : #'private - accessing' }
PeriodRESTfulControllerTest >> urlOf: aPeriod [

	^ ( self resourceUrl / aPeriod uuid asString ) asString
]
