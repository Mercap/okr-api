Class {
	#name : #PeriodRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'periodManagementSystem'
	],
	#category : #'OKR-Model-API'
}

{ #category : #'instance creation' }
PeriodRESTfulController class >> within: aPeriodManagementSystem [ 
	
	^ self new initializeWithin: aPeriodManagementSystem
]

{ #category : #API }
PeriodRESTfulController >> createPeriodBasedOn: anHttpRequest within: aContext [

	^ self
		withCreatedResourceDo: [ :aPeriod | 
			self periodManagementSystem startManagingPeriod: aPeriod.
			aPeriod
			]
		decodedUsing: self specification periodMappingKey
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #'private - accessing' }
PeriodRESTfulController >> entityTagOf: aPeriod encodedAs: mediaType [

	^ ZnETag with: ( MD5 hashMessage: aPeriod printString ) hex
]

{ #category : #API }
PeriodRESTfulController >> getPeriodBasedOn: anHttpRequest within: aContext [

	^ self
		get: [ | uuid |

			uuid := UUID fromString: ( anHttpRequest at: #identifier ).
			self periodManagementSystem
				periodIdentifiedBy: uuid
				ifFound: #yourself
				ifNone: [ ObjectNotFound signal ]
			]
		encodedUsing: self specification periodMappingKey
		basedOn: anHttpRequest
		within: aContext
]

{ #category : #API }
PeriodRESTfulController >> getPeriodsBasedOn: aTeaRequest within: aContext [

	^ self
		get: [ self periodManagementSystem periods ]
		asCollectionEncodedUsing: self specification periodMappingKey
		basedOn: aTeaRequest
		within: aContext
]

{ #category : #initialize }
PeriodRESTfulController >> initializeWithin: aPeriodManagementSystem [ 
	
	periodManagementSystem := aPeriodManagementSystem.
]

{ #category : #'private - accessing' }
PeriodRESTfulController >> locationOf: aPeriod [

	| baseUrl |

	baseUrl := ( baseUrlOptional withContentDo: [ :theBaseUrl | theBaseUrl ] ifUnused: [ '' ] ) asZnUrl.

	^ baseUrl / self specification endpoint / aPeriod uuid printString asZnUrl
]

{ #category : #'private - accessing' }
PeriodRESTfulController >> periodManagementSystem [
	
	^ periodManagementSystem 
]

{ #category : #'private - accessing' }
PeriodRESTfulController >> provideHypermediaPolicy [

	^ HypermediaDrivenRESTfulControllerPolicy for: self
]

{ #category : #'private - accessing' }
PeriodRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
PeriodRESTfulController >> specification [

	^ PeriodRESTfulControllerSpecification new
]
