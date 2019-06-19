Class {
	#name : #PeriodRESTfulControllerTest,
	#superclass : #ResourceRESTfulControllerTest,
	#instVars : [
		'periodManagementSystem'
	],
	#category : #'OKR-Tests-API'
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

{ #category : #'private - support' }
PeriodRESTfulControllerTest >> requestToCreatePeriodFrom: aJSON [

	^ self requestToPOST: aJSON as: self defaultPeriodMediaType
]

{ #category : #'private - support' }
PeriodRESTfulControllerTest >> requestToDeletePeriod: aPeriod [

	^ TeaRequest
		fromZnRequest: ( ZnRequest delete: ( self urlOf: aPeriod ) )
		pathParams:
			( Dictionary new
				at: #identifier put: aPeriod uuid;
				yourself )
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

{ #category : #'private - support' }
PeriodRESTfulControllerTest >> requestToUpdatePeriod: aPeriod with: anUpdatePeriod [

	^ TeaRequest
		fromZnRequest:
			( ( ZnRequest put: ( self urlOf: aPeriod ) )
				entity: ( ZnEntity with: anUpdatePeriod type: self defaultPeriodMediaType );
				yourself )
		pathParams:
			( Dictionary new
				at: #identifier put: aPeriod uuid;
				yourself )
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
PeriodRESTfulControllerTest >> testDeletePeriod [

	| creationResponse updateResponse |

	self assert: periodManagementSystem periods isEmpty.
	creationResponse := resourceController
		createPeriodBasedOn:
			( self
				requestToCreatePeriodFrom: '{"name":"2018Q4","startDate":"2018-10-01","endDate":"2018-12-31"}' )
		within: self newHttpRequestContext.
	self assert: periodManagementSystem periods size equals: 1.
	
	updateResponse := resourceController
		deletePeriodBasedOn: ( self requestToDeletePeriod: periodManagementSystem periods first)
		within: self newHttpRequestContext.

	self
		assert: updateResponse isSuccess;
		assert: periodManagementSystem periods isEmpty
]

{ #category : #tests }
PeriodRESTfulControllerTest >> testGetAfterCreatePeriod [

	self
		assert: periodManagementSystem periods isEmpty;
		assert:
			( resourceController
				createPeriodBasedOn:
					( self
						requestToCreatePeriodFrom: '{"name":"2018Q4","startDate":"2018-10-01","endDate":"2018-12-31"}' )
				within: self newHttpRequestContext ) isCreated.
	self
		withTheOnlyOneIn: periodManagementSystem periods
		do: [ :period | 
			| response |

			response := resourceController
				getPeriodBasedOn:
					( self requestToGetResourceIdentifiedBy: period uuid accepting: self defaultPeriodMediaType )
				within: self newHttpRequestContext.
			self
				withJsonFromContentsIn: response
				do: [ :json | 
					self
						assert: json name equals: '2018Q4';
						assert: json startDate equals: '2018-10-01';
						assert: json endDate equals: '2018-12-31';
						assertUrl: ( json links at: #self ) equals: ( self urlOf: period )
					]
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

{ #category : #tests }
PeriodRESTfulControllerTest >> testRoutes [

	resourceController specification routes
		with:
			{( #POST -> '/periods' ).
			( #DELETE -> '/periods/<identifier:IsUUID>' ).
			( #GET -> '/periods/<identifier:IsUUID>' ).
			( #GET -> '/periods' ).
			( #PATCH -> '/periods/<identifier:IsUUID>' )}
		do: [ :route :expectedRoute | 
			self
				assert: route httpMethod equals: expectedRoute key;
				assert: route urlTemplate equals: expectedRoute value
			]
]

{ #category : #tests }
PeriodRESTfulControllerTest >> testUpdatePeriod [

	| updateResponse |

	self assert: periodManagementSystem periods isEmpty.
	resourceController
		createPeriodBasedOn:
			( self
				requestToCreatePeriodFrom: '{"name":"2018Q4","startDate":"2018-10-01","endDate":"2018-12-31"}' )
		within: self newHttpRequestContext.

	updateResponse := resourceController
		updatePeriodBasedOn:
			( self
				requestToUpdatePeriod: periodManagementSystem periods first
				with: '{"name":"2019Q1","startDate":"2019-01-01", "endDate":"2019-01-15"}' )
		within: self newHttpRequestContext.

	self
		assert: updateResponse isCreated;
		withTheOnlyOneIn: periodManagementSystem periods
			do: [ :foundPeriod | 
			self
				assert: updateResponse location equals: ( self urlOf: foundPeriod );
				assert: foundPeriod name equals: '2019Q1';
				assert: foundPeriod startDate equals: January first , 2019;
				assert: foundPeriod endDate equals: January fifteenth , 2019
			]
]

{ #category : #'private - accessing' }
PeriodRESTfulControllerTest >> urlOf: aPeriod [

	^ ( self resourceUrl / aPeriod uuid asString ) asString
]
