Class {
	#name : #KeyResultsRESTfulControllerTest,
	#superclass : #ResourceRESTfulControllerTest,
	#instVars : [
		'okrManagementSystem'
	],
	#category : #'OKR-Tests-Controllers'
}

{ #category : #'private - support' }
KeyResultsRESTfulControllerTest >> baseUrl [

	^ 'https://api.mercap.net' asZnUrl
]

{ #category : #running }
KeyResultsRESTfulControllerTest >> setUpResourceController [

	okrManagementSystem := OKRManagementSystem new.

	resourceController := KeyResultsRESTfulController
		within: ( ObjectiveRESTfulController within: okrManagementSystem )
]
