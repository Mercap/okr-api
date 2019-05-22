Class {
	#name : #ObjectiveRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'objectiveManagementSystem'
	],
	#category : #'OKR-Model-API'
}

{ #category : #'instance creation' }
ObjectiveRESTfulController class >> within: aPeriodManagementSystem [ 
	
	^ self new initializeWithin: aPeriodManagementSystem
]

{ #category : #API }
ObjectiveRESTfulController >> createObjectiveBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :anObjective | 
			self objectiveManagementSystem startManagingObjective: anObjective.
			anObjective
			]
		decodedUsing: self specification objectiveMappingKey
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
ObjectiveRESTfulController >> deleteObjectiveBasedOn: anHttpRequest within: aContext [

	| uuid |

	uuid := UUID fromString: ( anHttpRequest uri segments at: 2 ).
	self objectiveManagementSystem
		objectiveIdentifiedBy: uuid
		ifFound: [ :anObjective | self objectiveManagementSystem stopManagingObjective: anObjective ]
		ifNone: [ ^ ObjectNotFound signal ].

	^ ZnResponse noContent
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> entityTagOf: anObjective encodedAs: mediaType [

	^ ZnETag with: ( MD5 hashMessage: anObjective printString ) hex
]

{ #category : #API }
ObjectiveRESTfulController >> getObjectiveBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ | uuid |

			uuid := UUID fromString: ( anHttpRequest at: #identifier ).
			self objectiveManagementSystem
				objectiveIdentifiedBy: uuid
				ifFound: #yourself
				ifNone: [ ObjectNotFound signal ]
			]
		encodedUsing: self specification objectiveMappingKey
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
ObjectiveRESTfulController >> getObjectivesBasedOn: aTeaRequest within: aContext [

	^ self
		get: [ self objectiveManagementSystem objectives ]
		asCollectionEncodedUsing: self specification objectivesMappingKey
		basedOn: aTeaRequest
		within: aContext
]

{ #category : #initialize }
ObjectiveRESTfulController >> initializeWithin: anObjectiveManagementSystem [ 
	
	objectiveManagementSystem := anObjectiveManagementSystem.
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> locationOf: anObjective [

	| baseUrl |

	baseUrl := ( baseUrlOptional withContentDo: #yourself ifUnused: [ '' ] ) asZnUrl.

	^ baseUrl / self specification endpoint / anObjective uuid printString asZnUrl
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> objectiveManagementSystem [
	
	^ objectiveManagementSystem 
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> provideHypermediaPolicy [

	^ HypermediaDrivenRESTfulControllerPolicy for: self
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
ObjectiveRESTfulController >> specification [

	^ ObjectiveRESTfulControllerSpecification new
]

{ #category : #API }
ObjectiveRESTfulController >> updateObjectiveBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :anUpdatedObjective | 
			self objectiveManagementSystem
				objectiveIdentifiedBy: ( UUID fromString: ( anHttpRequest uri segments at: 2 ) )
				ifFound: [ :oldObjective | oldObjective synchronizeWith: anUpdatedObjective ]
				ifNone: [ ObjectNotFound signal ]
			]
		decodedUsing: self specification objectiveMappingKey
		basedOn: anHttpRequest
		within: aContext
]
