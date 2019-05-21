"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestOKRModel,
	#superclass : #PackageManifest,
	#category : #'OKR-Model-Manifest'
}

{ #category : #'class initialization' }
ManifestOKRModel class >> initialize [

	<ignoreForCoverage>
	Kepler
		registerInterfaceAt: #PeriodManagementSystem
			named: 'System to manage periods'
			declaring: #(#periodIdentifiedBy:ifFound:ifNone: #periods #startManagingPeriod: #stopManagingPeriod:);
		registerInterfaceAt: #KeyResultManagementSystem
			named: 'System to manage key results'
			declaring:
			#(#keyResultIdentifiedBy:ifFound:ifNone: #keyResults #startManagingKeyResult: #stopManagingKeyResult:);
		registerInterfaceAt: #ObjectiveManagementSystem
			named: 'System to manage objectives'
			declaring:
			#(#objectiveIdentifiedBy:ifFound:ifNone: #objectives #startManagingObjectives: #stopManagingObjectives:)
]
