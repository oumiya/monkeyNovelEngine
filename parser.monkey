Import mojo

Class Parser
	' コマンド
	Field command:String
	' 引数1
	Field arg1:String
	' 引数2
	Field arg2:String
	' 引数3
	Field arg3:String
	' 引数4
	Field arg4:String
	' 引数5
	Field arg5:String
	' 引数temp
	Field arg:String

	' 現在読み込んでいる個所の状態(0=待機,1=コマンド読込モード,2=引数読込モード,
	Field status:Int
	Field argumentStatus:Int
	' エラーコード 
	Field errorcode:String
	' エラーメッセージ
	Field errorMessage:String
	' 1コマンド読込終わったフラグ
	Field isCommanded:Bool
	' コマンドリスト
	Field commandsList:String[24]
	
	'今文字列中かどうか
	Field isString:Bool
	'エスケープ中かどうか
	Field isEscape:Bool
	
	Method New()
		Self.commandsList = New String[24]
		Self.commandsList[0] = "definecharacter"
		Self.commandsList[1] = "definebackground"
		Self.commandsList[2] = "definepicture"
		Self.commandsList[3] = "definevariable"
		Self.commandsList[4] = "definesound"
		Self.commandsList[5] = "definemusic"
		Self.commandsList[6] = "definescene"
		Self.commandsList[7] = "print"
		Self.commandsList[8] = "character"
		Self.commandsList[9] = "background"
		Self.commandsList[10] = "picture"
		Self.commandsList[11] = "fadeout"
		Self.commandsList[12] = "fadein"
		Self.commandsList[13] = "clear"
		Self.commandsList[14] = "playsound"
		Self.commandsList[15] = "playmusic"
		Self.commandsList[16] = "select"
		Self.commandsList[17] = "jump"
		Self.commandsList[18] = "jumpif"
		Self.commandsList[19] = "title"
		Self.commandsList[20] = "click"
		Self.commandsList[21] = "add"
		Self.commandsList[22] = "sub"
		Self.commandsList[23] = "option"
		Self.command = ""
		Self.arg1 = ""
		Self.arg2 = ""
		Self.arg3 = ""
		Self.arg4 = ""
		Self.arg5 = ""
		Self.arg = ""
		Self.status = 0
		Self.argumentStatus = 0
		Self.errorcode = ""
		Self.errorMessage = ""
		Self.isCommanded = False
		Self.isString = False
		Self.isEscape = False
	End
	
	' 定義されているコマンドじゃない場合はfalseを返す
	Method CommandCheck:Bool(value:String)
		Local result:Bool = False
		For Local i:Int=0 To Self.commandsList.Length() - 1
			If Self.commandsList[i] = value
				result = True
				Exit
			Endif
		Next
		Return result
	End
	
	' 指定の番号の引数に値をセット
	Method SetArgument:Void(value:String, argnumber:Int)
		If argnumber = 0
			Self.arg1 = value
		Elseif argnumber = 1
			Self.arg2 = value
		Elseif argnumber = 2
			Self.arg3 = value
		Elseif argnumber = 3
			Self.arg4 = value
		Elseif argnumber = 4
			Self.arg5 = value
		Endif
	End


	' このメソッドに1文字ずつ渡してくださいね
	' 返り値は
	'   -1 エラー発生
	'    0 継続
	'    1 1コマンド読込完了
	Method Parse:Int(character:String)
		If Self.status = 0 ' 待機状態
			If character = "@"
				' コマンド開始と同時にコマンド初期化
				Self.command = ""
				Self.arg1 = ""
				Self.arg2 = ""
				Self.arg3 = ""
				Self.arg4 = ""
				Self.arg5 = ""
				Self.isCommanded = False
				Self.status = 1

			Else
				If character <> "~n" And character <> " "
					Self.errorcode = "syntax error unexpected"
					Self.errorMessage = "構文エラーです"
					Return -1				
				Endif

			Endif

		Elseif Self.status = 1 ' コマンド読込状態
			If character = ":"
				' コロンが来たらコマンドモード終了
				Self.status = 2
				Self.argumentStatus = 0
				Self.arg = ""
				Self.command = command.ToLower() ' 小文字化してスクリプトの大文字小文字を判別しない

				' コマンドチェック（定義されたコマンド以外ならエラー）
				If CommandCheck(Self.command) = False
					Self.errorcode = "syntax error undefined command"
					Self.errorMessage = "未定義のコマンドが指定されました"
					Return -1
				Endif

			Elseif character = ";"
				' セミコロンが来たら引数なしのコマンドなので、コマンドパース完了
				' コマンドチェック（定義されたコマンド以外ならエラー）
				If CommandCheck(Self.command) = False
					Self.errorcode = "syntax error undefined command"
					Self.errorMessage = "未定義のコマンドが指定されました"
					Return -1
				Endif

				' コマンドや引数をTrimして空白を除去
				SetArgument(Self.arg, Self.argumentStatus)
				Self.status = 0
				Self.command = Self.command.Trim()
				Self.arg1 = Self.arg1.Trim()
				Self.arg2 = Self.arg2.Trim()
				Self.arg3 = Self.arg3.Trim()
				Self.arg4 = Self.arg4.Trim()
				Self.arg5 = Self.arg5.Trim()
				Return 1

			Else
				' コロン以外の文字列はコマンドとして蓄積
				Self.command += character

			Endif
		Elseif Self.status = 2 ' 引数読込状態
			If Self.isString = False And character = "~q"
				Self.isString = True

			Elseif Self.isString = True And character = "~q" And Self.isEscape = False
				Self.isString = False

			Elseif Self.isString = True And character = "\" And Self.isEscape = False
				Self.isEscape = True

			Elseif Self.isString = True
				' それ以外の文字列は引数として蓄積
				Self.arg += character

			Else
				If character = ","
					' カンマが来たら次の引数に遷移
					SetArgument(Self.arg, Self.argumentStatus)
					Self.argumentStatus = Self.argumentStatus + 1
					Self.arg = ""
					' 引数状態が4を超えたら引数の設定のしすぎでエラー
					If Self.argumentStatus > 4
						Self.errorcode = "syntax error too many arguments"
						Self.errorMessage = "指定された引数が多すぎます"
						Return -1
					Endif
				Elseif character = ";"
					' セミコロンが来たら引数モード終了、というか1コマンドのパース完了
					' コマンドや引数をTrimして空白を除去
					SetArgument(Self.arg, Self.argumentStatus)
					Self.status = 0
					Self.command = Self.command.Trim()
					Self.arg1 = Self.arg1.Trim()
					Self.arg2 = Self.arg2.Trim()
					Self.arg3 = Self.arg3.Trim()
					Self.arg4 = Self.arg4.Trim()
					Self.arg5 = Self.arg5.Trim()
					Return 1
				Else
					' それ以外の文字列は引数として蓄積
					Self.arg += character
				Endif
			Endif
		Endif
		
		Return 0
	End
End