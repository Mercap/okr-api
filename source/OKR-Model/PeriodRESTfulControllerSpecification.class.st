Class {
	#name : #PeriodRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'OKR-Model-API'
}

{ #category : #adding }
PeriodRESTfulControllerSpecification >> addJsonEncoderMappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: self periodsMappingKey
		to: self periodsMediaType
		using: [ :periods :context | 
			String
				streamContents: [ :stream | 
					( NeoJSONWriter on: stream )
						for: Period do: [ :mapping | mapping mapInstVars ];
						for: FixedDate customDo: [ :mapping | mapping encoder: #printString ];
						nextPut: periods
					]
			]
]

{ #category : #accessing }
PeriodRESTfulControllerSpecification >> endpoint [

	^ '/periods'
]

{ #category : #routes }
PeriodRESTfulControllerSpecification >> getPeriodsRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :service :httpRequest :context | service getPeriodsBasedOn: httpRequest within: context ]
]

{ #category : #Accessing }
PeriodRESTfulControllerSpecification >> periodsMappingKey [
	^'periods'
]

{ #category : #adding }
PeriodRESTfulControllerSpecification >> periodsMediaType [

	^ 'application/vnd.mercap.periods+json' asMediaType 
]
