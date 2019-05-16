Extension { #name : #Date }

{ #category : #'*OKR-Model' }
Date >> asGregorian [

	^ GregorianCalendar
		newDateFromYearNumber: self year
		monthNumber: self monthIndex
		dayNumber: self dayOfMonth
]
