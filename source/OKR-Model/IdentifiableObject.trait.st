Trait {
	#name : #IdentifiableObject,
	#instVars : [
		'uuid'
	],
	#category : #'OKR-Model-API'
}

{ #category : #accessing }
IdentifiableObject >> uuid [

	uuid ifNil: [ uuid := UUID new ].
	^ uuid
]
