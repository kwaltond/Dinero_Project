/*
Alias: WORK
LiveAnswer: FALSE

*/



  Select q.measIndex,q.sourcetype,q.begindate,q.stationnumber, b.measurementindex, b.PHmeterwnum from qwsample q, calibration b 
	where b.PHmeterwnum = "99999"
