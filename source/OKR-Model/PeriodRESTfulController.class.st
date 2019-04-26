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

{ #category : #'private - accessing' }
PeriodRESTfulController >> entityTagOf: aPeriod encodedAs: mediaType [

	^ ZnETag with: ( SHA1 new hashMessage: aPeriod printString ) hex
]

{ #category : #accessing }
PeriodRESTfulController >> getPeriodsBasedOn: aTeaRequest within: aContext [

	^ self
		get: [ self periodManagementSystem periods ]
		asCollectionEncodedUsing: self specification periodsMappingKey
		basedOn: aTeaRequest
		within: aContext
]

{ #category : #initialize }
PeriodRESTfulController >> initializeWithin: aPeriodManagementSystem [ 
	
	periodManagementSystem := aPeriodManagementSystem.
]

{ #category : #accessing }
PeriodRESTfulController >> periodManagementSystem [
	
	^ periodManagementSystem 
]

{ #category : #'private - accessing' }
PeriodRESTfulController >> provideHypermediaPolicy [
	
	^ NonHypermediaDrivenRESTfulControllerPolicy new
]

{ #category : #'private - accessing' }
PeriodRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #specification }
PeriodRESTfulController >> specification [

	^PeriodRESTfulControllerSpecification new
]
