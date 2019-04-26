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
				group: 'CI' with: 'Tests';
				group: 'Development' with: #('Tests')
			]
]

{ #category : #baselines }
BaselineOfOKRAPI >> baselineOKRAPI: spec [

	spec
		package: 'OKR-Model' with: [ spec requires: #('Chalten') ];
		group: 'Deployment' with: 'OKR-Model'.
	spec
		package: 'OKR-Tests' with: [ spec requires: #('OKR-Model') ];
		group: 'Tests' with: 'OKR-Tests'.
]

{ #category : #initialization }
BaselineOfOKRAPI >> setUpDependencies: spec [

	spec
		baseline: 'Stargate'
			with: [ spec
				repository: 'github://ba-st/Stargate:v1/source';
				loads: #('Deployment') ];
		import: 'Stargate'.
		
	spec
		baseline: 'Chalten'
			with: [ spec
				repository: 'github://ba-st/Chalten:v8/source';
				loads: #('Chalten-Gregorian-Calendar') ];
		import: 'Chalten'.
]
