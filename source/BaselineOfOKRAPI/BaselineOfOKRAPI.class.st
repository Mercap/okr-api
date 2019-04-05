Class {
	#name : #BaselineOfOKRAPI,
	#superclass : #BaselineOf,
	#category : #BaselineOfOKRAPI
}

{ #category : #baselines }
BaselineOfOKRAPI >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ self
				setUpDependencies: spec;
				baselineOKRAPI: spec.
			spec
				group: 'CI' with: 'Deployment'
			]
]

{ #category : #baselines }
BaselineOfOKRAPI >> baselineOKRAPI: spec [

	spec group: 'Deployment' with: 'Stargate'
]

{ #category : #initialization }
BaselineOfOKRAPI >> setUpDependencies: spec [

	spec
		baseline: 'Stargate'
			with: [ spec
				repository: 'github://ba-st/Stargate:v1/source';
				loads: #('Deployment') ];
		import: 'Stargate'.
]
