' ターゲットプラットフォームがHTML5の時のみ動作します。
#If TARGET<>"html5"
#Error "The saveload module is only available with the html5 target."
#End

Strict

Import "saveandload.js"

Extern

' 現在のゲーム状況をセーブします。
Function SaveGame:Void(jsondata:String)

' 指定のセーブデータをロードします。
Function LoadGame:String(jsondata:String)

Public

' 現在のゲーム状況からセーブデータを作成します。
' セーブデータを
Function CreateSaveJSON:String(variablesMap:StringMap<Int>)
	Local jsondata:String
	Local scriptFileName:String
	Local readLineNumber:Int
	
	Local variablesJson:String = "~qvariables~q:{~qtest~q:~qtest~q"
	
	For Local key:String = Eachin variablesMap.Keys()
		variablesJson += ",~q" + key  + "~q:" + variablesMap.Get(key)
	Next
	variablesJson += "}"
	
	jsondata = "{~qsavedata~q:{~quserid~q:~q%d~q,~qscriptfilename~q:~qstart.txt~q, ~qreadlinenumber~q:28, " + variablesJson + "}}"
	Return jsondata
End