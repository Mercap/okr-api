Class {
	#name : #ObjectiveRESTfulControllerSpecification,
	#superclass : #ResourceRESTfulControllerSpecification,
	#category : #'OKR-Model-API'
}

{ #category : #encoding }
ObjectiveRESTfulControllerSpecification >> addJsonObjectiveVersion1dot0dot0DecoderMappingIn: aBuilder [

	aBuilder
		addDefaultRuleToDecode: self objectiveVersion1dot0dot0MediaType
		to: self objectiveMappingKey
		using: [ :json :context | 
			| raw |

			raw := NeoJSONObject fromString: json.

			Objective
				describedBy: raw description
				withKeyResults: ( self parseKeyResultsFrom: raw keyResults )
			]
]

{ #category : #encoding }
ObjectiveRESTfulControllerSpecification >> addJsonObjectiveVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: self objectiveMappingKey
		to: self objectiveVersion1dot0dot0MediaType
		using: [ :resource :context | 
			String
				streamContents: [ :stream | 
					( NeoJSONWriter on: stream )
						for: KeyResult do: [ :mapping | mapping mapAccessors: #(#description #weight) ];
						for: Objective
							do: [ :mapping | 
							mapping
								mapAccessors: #(#description #keyResults);
								mapHypermediaControlsIn: context
							];
						nextPut: resource
					]
			]
]

{ #category : #encoding }
ObjectiveRESTfulControllerSpecification >> addJsonObjectivesVersion1dot0dot0MappingIn: aBuilder [

	aBuilder
		addDefaultRuleToEncode: self objectivesMappingKey
		to: self objectiveVersion1dot0dot0MediaType
		using: [ :resource :context | 
			String
				streamContents: [ :stream | 
					( NeoJSONWriter on: stream )
						for: KeyResult do: [ :mapping | mapping mapAccessors: #(#description #weight) ];
						for: Objective
							do: [ :mapping | 
							mapping
								mapAccessors: #(#description #keyResults);
								mapAsHypermediaControls: [ :objective | context hypermediaControlsFor: objective ]
							];
						nextPut: resource
					]
			]
]

{ #category : #routes }
ObjectiveRESTfulControllerSpecification >> createObjectiveRoute [

	^ RouteSpecification
		handling: #POST
		at: self endpoint
		evaluating: [ :service :httpRequest :context | service createObjectiveBasedOn: httpRequest within: context ]
]

{ #category : #routes }
ObjectiveRESTfulControllerSpecification >> deleteObjectiveRoute [

	^ RouteSpecification
		handling: #DELETE
		at: self objectiveTemplate
		evaluating: [ :service :httpRequest :context | service deleteObjectiveBasedOn: httpRequest within: context ]
]

{ #category : #accessing }
ObjectiveRESTfulControllerSpecification >> endpoint [

	^ '/objectives'
]

{ #category : #routes }
ObjectiveRESTfulControllerSpecification >> getObjectiveRoute [

	^ RouteSpecification
		handling: #GET
		at: self objectiveTemplate
		evaluating: [ :service :httpRequest :context | service getObjectiveBasedOn: httpRequest within: context ]
]

{ #category : #routes }
ObjectiveRESTfulControllerSpecification >> getObjectivesRoute [

	^ RouteSpecification
		handling: #GET
		at: self endpoint
		evaluating: [ :service :httpRequest :context | service getObjectivesBasedOn: httpRequest within: context ]
]

{ #category : #accessing }
ObjectiveRESTfulControllerSpecification >> objectiveMappingKey [

	^ 'objective'
]

{ #category : #accessing }
ObjectiveRESTfulControllerSpecification >> objectiveTemplate [

	^ '<1s>/%<<2s>:IsUUID>' expandMacrosWith: self endpoint with: #identifier
]

{ #category : #accessing }
ObjectiveRESTfulControllerSpecification >> objectiveVersion1dot0dot0MediaType [

	^ 'application/vnd.mercap.objective+json;version=1.0.0' asMediaType
]

{ #category : #accessing }
ObjectiveRESTfulControllerSpecification >> objectivesMappingKey [

	^ 'objectives'
]

{ #category : #encoding }
ObjectiveRESTfulControllerSpecification >> parseKeyResultsFrom: aCollection [

	^ aCollection
		collect:
			[ :raw | KeyResult describedBy: raw description weighted: ( raw weight * 100 ) asInteger percent ]
]

{ #category : #routes }
ObjectiveRESTfulControllerSpecification >> updateObjectiveRoute [

	^ RouteSpecification
		handling: #PATCH
		at: self objectiveTemplate
		evaluating: [ :service :httpRequest :context | service updateObjectiveBasedOn: httpRequest within: context ]
]
