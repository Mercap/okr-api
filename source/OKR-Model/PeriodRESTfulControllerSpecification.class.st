Class {
	#name : #PeriodRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'OKR-Model-API'
}

{ #category : #encoding }
PeriodRESTfulControllerSpecification >> addJsonEncoderMappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: self periodsMappingKey
		to: self periodsVersion1dot0dot0MediaType
		using: [ :periods :context | 
			String
				streamContents: [ :stream | 
					( NeoJSONWriter on: stream )
						for: Period
							do: [ :mapping | 
							mapping
								mapAccessors: #(#name #startDate #endDate);
								mapAsHypermediaControls: [ :period | context hypermediaControlsFor: period ]
							];
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

{ #category : #accessing }
PeriodRESTfulControllerSpecification >> periodsMappingKey [

	^ 'periods'
]

{ #category : #accessing }
PeriodRESTfulControllerSpecification >> periodsVersion1dot0dot0MediaType [

	^ 'application/vnd.mercap.periods+json;version=1.0.0' asMediaType
]
