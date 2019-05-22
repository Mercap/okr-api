Class {
	#name : #ObjectiveRESTfulControllerTest,
	#superclass : #ResourceRESTfulControllerTest,
	#instVars : [
		'objectiveManagementSystem'
	],
	#category : #'OKR-Tests-Controllers'
}

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> baseUrl [

	^ 'https://api.mercap.net' asZnUrl
]

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> createObjectiveBasedOn: anObjective [

	^ resourceController
		createObjectiveBasedOn: ( self requestToPOST: anObjective as: self defaultObjectiveMediaType )
		within: self newHttpRequestContext
]

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> defaultObjectiveMediaType [

	^ resourceController specification objectiveVersion1dot0dot0MediaType
]

{ #category : #'private - accessing' }
ObjectiveRESTfulControllerTest >> emptyObjectiveJson [

	^ NeoJSONObject new
		at: 'description' put: 'First one'; 
		at: 'keyResults' put: Array new; 
		asString
]

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> getAllObjectives [

	^ resourceController
		getObjectivesBasedOn: ( self requestToGet: self resourceUrl accepting: '*/*' )
		within: self newHttpRequestContext
]

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> getObjectiveIdentifiedAs: anIdentifier [

	^ resourceController
		getObjectiveBasedOn: ( self requestToGetResourceIdentifiedBy: anIdentifier accepting: self defaultObjectiveMediaType )
		within: self newHttpRequestContext
]

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> registerObjective: anObjective [

	objectiveManagementSystem startManagingObjective: anObjective
]

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> requestToDeleteObjective: anObjectiveLocation [

	^ TeaRequest fromZnRequest: ( ZnRequest delete: anObjectiveLocation )
]

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> requestToGet: aUrl accepting: anAcceptHeader [

	^ TeaRequest
		fromZnRequest:
			( ( ZnRequest get: aUrl )
				setAccept: anAcceptHeader;
				yourself )
]

{ #category : #'private - support' }
ObjectiveRESTfulControllerTest >> requestToUpdateObjective: aPeriodLocation with: anUpdatePeriod [
	
	^ TeaRequest
		fromZnRequest:
			((ZnRequest put: aPeriodLocation)
				entity: (ZnEntity with: anUpdatePeriod type: self defaultObjectiveMediaType );
				yourself)
        
]

{ #category : #running }
ObjectiveRESTfulControllerTest >> setUpResourceController [

	objectiveManagementSystem := ObjectiveManagementSystem new.

	resourceController := ObjectiveRESTfulController within: objectiveManagementSystem
]

{ #category : #tests }
ObjectiveRESTfulControllerTest >> testCreateEmptyObjective [

	| response |

	self assert: objectiveManagementSystem objectives isEmpty.
	response := self createObjectiveBasedOn: self emptyObjectiveJson.

	self
		assert: response isCreated;
		withTheOnlyOneIn: objectiveManagementSystem objectives
			do: [ :foundObjective | 
			self
				assert: response location equals: ( self urlOf: foundObjective );
				assert: foundObjective description equals: 'First one';
				assert: foundObjective keyResults isEmpty
			]
]

{ #category : #tests }
ObjectiveRESTfulControllerTest >> testDeleteObjective [

	| creationResponse updateResponse |

	self assert: objectiveManagementSystem objectives isEmpty.
	creationResponse := self createObjectiveBasedOn: self emptyObjectiveJson.
	self assert: objectiveManagementSystem objectives size equals: 1.
	
	updateResponse := resourceController
		deleteObjectiveBasedOn: ( self requestToDeleteObjective: creationResponse location )
		within: self newHttpRequestContext.

	self
		assert: updateResponse isSuccess;
		assert: objectiveManagementSystem objectives isEmpty
]

{ #category : #tests }
ObjectiveRESTfulControllerTest >> testGetAfterCreateObjective [

	self
		assert: objectiveManagementSystem objectives isEmpty;
		assert: ( self createObjectiveBasedOn: self emptyObjectiveJson ) isCreated.
	self
		withTheOnlyOneIn: objectiveManagementSystem objectives
		do: [ :objective | 
			| response |

			response := self getObjectiveIdentifiedAs: objective uuid asString.
			self
				withJsonFromContentsIn: response
				do: [ :json | 
					self
						assert: json description equals: 'First one';
						assert: json keyResults isEmpty;
						assertUrl: ( json links at: #self ) equals: ( self urlOf: objective )
					]
			]
]

{ #category : #tests }
ObjectiveRESTfulControllerTest >> testGetObjectivesWithOnlyOneManaged [

	| response objective |

	objective := Objective describedBy: 'First one' withKeyResults: #().
	self registerObjective: objective.

	response := self getAllObjectives.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType asMediaType
			equals: resourceController specification objectiveVersion1dot0dot0MediaType.

	self
		withJsonFromContentsIn: response
		do: [ :objectives | 
			self
				withTheOnlyOneIn: objectives
				do: [ :foundObjective | 
					self
						assert: foundObjective description equals: 'First one';
						assert: foundObjective keyResults isEmpty;
						assert: ( foundObjective links at: #self ) equals: ( self urlOf: objective )
					]
			]
]

{ #category : #tests }
ObjectiveRESTfulControllerTest >> testGetWhenEmptyObjectives [

	| response |

	response := self getAllObjectives.

	self
		assert: response isSuccess;
		assert: response status equals: 200;
		assert: response contentType asMediaType
			equals: resourceController specification objectiveVersion1dot0dot0MediaType.

	self withJsonFromContentsIn: response do: [ :objectives | self assert: objectives isEmpty ]
]

{ #category : #tests }
ObjectiveRESTfulControllerTest >> testUpdateObjective [

	| creationResponse updateResponse |

	self assert: objectiveManagementSystem objectives isEmpty.
	creationResponse := self createObjectiveBasedOn: self emptyObjectiveJson.
	updateResponse := resourceController
		updateObjectiveBasedOn:
			( self
				requestToUpdateObjective: creationResponse location
				with: '{"description":"Second one","keyResults":[]}' )
		within: self newHttpRequestContext.

	self
		assert: updateResponse isCreated;
		withTheOnlyOneIn: objectiveManagementSystem objectives
			do: [ :foundObjective | 
			self
				assert: creationResponse location equals: ( self urlOf: foundObjective );
				assert: foundObjective description equals: 'Second one';
				assert: foundObjective keyResults isEmpty
			]
]

{ #category : #'private - accessing' }
ObjectiveRESTfulControllerTest >> urlOf: anObjective [

	^ ( self resourceUrl / anObjective uuid asString ) asString
]