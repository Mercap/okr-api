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
		registerInterfaceAt: #OKRManagementSystem
			named: 'System to manage objectives and key results'
			declaring:
			#(#objectiveIdentifiedBy:ifFound:ifNone: #objectives #startManagingObjectives: #stopManagingObjectives: #updateObjective:with: #keyResultsfor:)
]
