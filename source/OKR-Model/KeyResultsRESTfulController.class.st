Class {
	#name : #KeyResultsRESTfulController,
	#superclass : #ResourceRESTfulController,
	#instVars : [
		'parentController'
	],
	#category : #'OKR-Model-API'
}

{ #category : #'instance creation' }
KeyResultsRESTfulController class >> within: aParentController [

	^ self new initializeWithin: aParentController
]

{ #category : #'private - accessing' }
KeyResultsRESTfulController >> entityTagOf: aKeyResult encodedAs: mediaType within: aContext [

	^ ZnETag with: ( MD5 hashMessage: mediaType printString , aKeyResult printString ) hex
]

{ #category : #initialization }
KeyResultsRESTfulController >> initializeWithin: aParentController [

	parentController := aParentController
]

{ #category : #'private - accessing' }
KeyResultsRESTfulController >> locationOf: aKeyResult within: aContext [

	| baseUrl objective |

	objective := aContext objectUnder: #objective.
	baseUrl := ( baseUrlOptional withContentDo: #yourself ifUnused: [ '' ] ) asZnUrl.
	^ baseUrl / ( parentController locationOf: objective within: aContext )
		/ self specification endpoint / aKeyResult uuid printString asZnUrl
]

{ #category : #'private - accessing' }
KeyResultsRESTfulController >> provideHypermediaPolicy [

	^ HypermediaDrivenRESTfulControllerPolicy for: self
]

{ #category : #'private - accessing' }
KeyResultsRESTfulController >> providePaginationPolicy [

	^ RESTfulControllerDoNotPaginateCollectionsPolicy for: self
]

{ #category : #'private - accessing' }
KeyResultsRESTfulController >> provideResourceCreationPolicy [

	^ RESTfulControllerRespondCreatedEntityPolicy for: self
]

{ #category : #specification }
KeyResultsRESTfulController >> specification [

	^ KeyResultsRESTfulControllerSpecification new
]
