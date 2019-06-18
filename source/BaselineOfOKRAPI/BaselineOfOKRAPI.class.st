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
		package: 'OKR-Model'
			with: [ spec requires: #('Chalten' 'Kepler-Core' 'Stargate-Core' 'ApplicationStarter' 'Sagan') ];
		group: 'Deployment' with: 'OKR-Model'.
	spec
		package: 'OKR-Tests' with: [ spec requires: #('OKR-Model' 'Kepler-SUnit' 'Stargate-SUnit') ];
		group: 'Tests' with: 'OKR-Tests'
]

{ #category : #initialization }
BaselineOfOKRAPI >> setUpDependencies: spec [

	spec
		baseline: 'ApplicationStarter'
		with: [ spec repository: 'github://ba-st/ApplicationStarter:v1/source' ].
	spec
		baseline: 'Kepler' with: [ spec repository: 'github://ba-st/Kepler:v4/source' ];
		project: 'Kepler-Core' copyFrom: 'Kepler' with: [ spec loads: 'Core' ];
		project: 'Kepler-SUnit' copyFrom: 'Kepler' with: [ spec loads: 'Dependent-SUnit-Extensions' ].

	spec
		baseline: 'Stargate'
			with: [ spec repository: 'github://ba-st/Stargate:release-candidate/source' ];
		project: 'Stargate-Core' copyFrom: 'Stargate' with: [ spec loads: 'Deployment' ];
		project: 'Stargate-SUnit' copyFrom: 'Stargate' with: [ spec loads: 'Stargate-Model-Tests' ].

	spec
		baseline: 'Chalten'
		with: [ spec
				repository: 'github://ba-st/Chalten:v8/source';
				loads: #('Chalten-Gregorian-Calendar')
			].

	spec
		baseline: 'Sagan'
		with: [ spec
				repository: 'github://ba-st/Sagan:release-candidate/source';
				loads: #('Deployment')
			]
]
