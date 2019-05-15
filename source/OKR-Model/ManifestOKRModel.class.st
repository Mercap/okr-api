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
			declaring: #(#periods #startManagingPeriod:);
		registerInterfaceAt: #KeyResultManagementSystem
			named: 'System to manage key results'
			declaring: #(#keyResults #startManagingKeyResult:)
]