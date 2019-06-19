Class {
	#name : #KeyResultsRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'OKR-Model-API'
}

{ #category : #acccessing }
KeyResultsRESTfulControllerSpecification >> endpoint [

	^ '/key-results'
]

{ #category : #routes }
KeyResultsRESTfulControllerSpecification >> getKeyResultRoute [

	^ RouteSpecification
		handling: #GET
		at: self keyResultTemplate
		evaluating: [ :service :httpRequest :context | service getKeyResultBasedOn: httpRequest within: context ]
]

{ #category : #routes }
KeyResultsRESTfulControllerSpecification >> getKeyResultsRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :service :httpRequest :context | service getKeyResultsBasedOn: httpRequest within: context ]
]

{ #category : #acccessing }
KeyResultsRESTfulControllerSpecification >> keyResultTemplate [

	^ '<1s>/%<<2s>:IsUUID>' expandMacrosWith: self endpoint with: #identifier
]
