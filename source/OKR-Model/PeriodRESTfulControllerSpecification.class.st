Class {
	#name : #PeriodRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'OKR-Model-API'
}

{ #category : #encoding }
PeriodRESTfulControllerSpecification >> addJsonPeriodVersion1dot0dot0DecoderMappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self periodVersion1dot0dot0MediaType
		to: self periodMappingKey
		using: [ :json :context | 
			| raw |

			raw := NeoJSONObject fromString: json.

			Period
				named: raw name
				from: ( Date fromString: raw startDate ) asGregorian
				to: ( Date fromString: raw endDate ) asGregorian
			]
]

{ #category : #encoding }
PeriodRESTfulControllerSpecification >> addJsonPeriodVersion1dot0dot0MappingIn: aBuilder [

	self
		addJsonPeriodsVersion1dot0dot0MappingIn: aBuilder
		withHypermediaFrom: [ :resource :context :mapping | mapping mapHypermediaControlsIn: context ]
		encoding: self periodMappingKey
]

{ #category : #encoding }
PeriodRESTfulControllerSpecification >> addJsonPeriodsVersion1dot0dot0MappingIn: aBuilder [

	self
		addJsonPeriodsVersion1dot0dot0MappingIn: aBuilder
		withHypermediaFrom:
			[ :resource :context :mapping | mapping mapAsHypermediaControls: [ :period | context hypermediaControlsFor: period ] ]
		encoding: self periodsMappingKey
]

{ #category : #encoding }
PeriodRESTfulControllerSpecification >> addJsonPeriodsVersion1dot0dot0MappingIn: aBuilder
	withHypermediaFrom: hypermediaControlsMapping
	encoding: aMappingKey [


	aBuilder
		addDefaultRuleToEncode: aMappingKey
		to: self periodVersion1dot0dot0MediaType
		using: [ :resource :context | 
			String
				streamContents: [ :stream | 
					( NeoJSONWriter on: stream )
						for: Period
							do: [ :mapping | 
							mapping mapAccessors: #(#name #startDate #endDate).
							hypermediaControlsMapping value: resource value: context value: mapping
							];
						for: FixedDate
							customDo: [ :mapping | 
							mapping
								encoder: [ :date | String streamContents: [ :s | date asSmalltalkDate asDateAndTime printYMDOn: s ] ]
							];
						nextPut: resource
					]
			]
]

{ #category : #routes }
PeriodRESTfulControllerSpecification >> createPeriodRoute [

	^ RouteSpecification
		handling: #POST
		at: self endpoint
		evaluating: [ :service :httpRequest :context | service createPeriodBasedOn: httpRequest within: context ]
]

{ #category : #routes }
PeriodRESTfulControllerSpecification >> deletePeriodRoute [

	^ RouteSpecification
		handling: #DELETE
		at: self periodTemplate
		evaluating: [ :service :httpRequest :context | service deletePeriodBasedOn: httpRequest within: context ]
]

{ #category : #accessing }
PeriodRESTfulControllerSpecification >> endpoint [

	^ '/periods'
]

{ #category : #routes }
PeriodRESTfulControllerSpecification >> getPeriodRoute [

	^ RouteSpecification
		handling: #GET
		at: self periodTemplate
		evaluating: [ :service :httpRequest :context | service getPeriodBasedOn: httpRequest within: context ]
]

{ #category : #routes }
PeriodRESTfulControllerSpecification >> getPeriodsRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :service :httpRequest :context | service getPeriodsBasedOn: httpRequest within: context ]
]

{ #category : #accessing }
PeriodRESTfulControllerSpecification >> periodMappingKey [

	^ 'period'
]

{ #category : #routes }
PeriodRESTfulControllerSpecification >> periodTemplate [

	^ '<1s>/%<<2s>:IsUUID>' expandMacrosWith: self endpoint with: #identifier
]

{ #category : #accessing }
PeriodRESTfulControllerSpecification >> periodVersion1dot0dot0MediaType [

	^ 'application/vnd.mercap.period+json;version=1.0.0' asMediaType
]

{ #category : #accessing }
PeriodRESTfulControllerSpecification >> periodsMappingKey [

	^ 'periods'
]

{ #category : #routes }
PeriodRESTfulControllerSpecification >> updatePeriodRoute [

	^ RouteSpecification
		handling: #PUT
		at: self periodTemplate
		evaluating: [ :service :httpRequest :context | service updatePeriodBasedOn: httpRequest within: context ]
]
