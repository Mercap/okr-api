Class {
	#name : #ObjectiveRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'okrManagementSystem',
		'keyResultsController'
	],
	#category : #'OKR-Model-API'
}

{ #category : #'instance creation' }
ObjectiveRESTfulController class >> within: anObjectiveManagementSystem [

	^ self new initializeWithin: anObjectiveManagementSystem
]

{ #category : #API }
ObjectiveRESTfulController >> createObjectiveBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :anObjective | 
			self okrManagementSystem startManagingObjective: anObjective.
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
	self okrManagementSystem
		objectiveIdentifiedBy: uuid
		ifFound: [ :anObjective | self okrManagementSystem stopManagingObjective: anObjective ]
		ifNone: [ ^ ObjectNotFound signal ].

	^ ZnResponse noContent
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> entityTagOf: anObjective encodedAs: mediaType within: aContext [

	^ ZnETag with: ( MD5 hashMessage: anObjective printString )
	hex
]

{ #category : #API }
ObjectiveRESTfulController >> getObjectiveBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ | uuid |

			uuid := UUID fromString: ( anHttpRequest at: #identifier ).
			self okrManagementSystem
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
		get: [ self okrManagementSystem objectives ]
		asCollectionEncodedUsing: self specification objectivesMappingKey
		basedOn: aTeaRequest
		within: aContext
]

{ #category : #initialize }
ObjectiveRESTfulController >> initializeWithin: anOkrManagementSystem [

	okrManagementSystem := anOkrManagementSystem.
	keyResultsController := KeyResultsRESTfulController within: self
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> locationOf: anObjective within: aContext [

	| baseUrl |

	baseUrl := ( baseUrlOptional withContentDo: #yourself ifUnused: [ '' ] ) asZnUrl.

	^ baseUrl / self specification endpoint / anObjective uuid printString asZnUrl
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> okrManagementSystem [

	^ okrManagementSystem
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> provideHypermediaPolicy [

	^ HypermediaDrivenRESTfulControllerPolicy for: self
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #'private - accessing' }
ObjectiveRESTfulController >> provideResourceCreationPolicy [

	^ RESTfulControllerRespondCreatedEntityPolicy for: self
]

{ #category : #specification }
ObjectiveRESTfulController >> specification [

	^ ObjectiveRESTfulControllerSpecification new
]

{ #category : #API }
ObjectiveRESTfulController >> updateObjectiveBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :anUpdatedObjective | 
			self okrManagementSystem
				objectiveIdentifiedBy: ( UUID fromString: ( anHttpRequest uri segments at: 2 ) )
				ifFound: [ :oldObjective | oldObjective synchronizeWith: anUpdatedObjective ]
				ifNone: [ ObjectNotFound signal ]
			]
		decodedUsing: self specification objectiveMappingKey
		basedOn: anHttpRequest
		within: aContext
]
