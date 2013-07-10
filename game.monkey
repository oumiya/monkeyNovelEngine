Import reflection
Import mojo
Import mojo.input
Import canvastext
Import rescale
Import parser
Import saveandload
Import optionitem
Import layer.bglayer
Import layer.personlayer
Import layer.picturelayer
Import layer.messagelayer
Import layer.effectlayer
Import layer.selectlayer

Class GameEngine Extends App
	Field bglayer:BgLayer
	Field personlayer:PersonLayer
	Field picturelayer:PictureLayer
	Field messagelayer:MessageLayer
	Field effectlayer:EffectLayer
	Field selectlayer:SelectLayer
	Field status:Int
	Field ps:Parser
	Field T:String
	Field readCommand:Int
	Field variableMap:StringMap<Int>
	Field soundsMap:StringMap<Sound>
	Field musicMap:StringMap<String>
	Field sceneMap:StringMap<String>

	Method OnCreate()
		SetUpdateRate 60
		Self.bglayer = New BgLayer()
		Self.personlayer = New PersonLayer()
		Self.picturelayer = New PictureLayer()
		Self.messagelayer = New MessageLayer()
		Self.effectlayer = New EffectLayer()
		Self.selectlayer = New SelectLayer()
		Self.status = 0
		Self.ps = New Parser
		Self.T = LoadString("start.txt")
		Self.readCommand = 0
		Self.variableMap = New StringMap<Int>
		Self.soundsMap = New StringMap<Sound>
		Self.musicMap = New StringMap<String>
		Self.sceneMap = New StringMap<String>
	End
	
	Method OnUpdate()
		If status = 0
			' コマンド読取モード
			Local result:Int = 0
			' スクリプトを読み終わったら最初から読み直す
			If readCommand >= T.Length
				Self.ps = New Parser
				Self.T = LoadString("start.txt")
				Self.readCommand = 0
			Endif
			' スクリプトを1文字ずつ解析し、コマンドが完成した or エラーが発生 or 最後まで読み終わったら ループを抜ける
			While result = 0 And readCommand < T.Length
				result = ps.Parse(String.FromChar(T[readCommand]))
				readCommand = readCommand + 1
			Wend
			If result = 1
				' コマンド完成
				' Draw系のコマンドだったら、statusを1に変更。クリック待ちコマンドならstatusを2に変更。
				status = Proc(ps.command, ps.arg1, ps.arg2, ps.arg3, ps.arg4, ps.arg5)
			Elseif result = -1
				' エラー発生。コンソールにエラー原因を書いておく。
				Print readCommand + "文字目でエラー発生"
				Print ps.errorcode
				Print ps.errorMessage
				Print "コマンド:" + ps.command
				Print "引数1:" + ps.arg1
				Print "引数2:" + ps.arg2
				Print "引数3:" + ps.arg3
				Print "引数4:" + ps.arg4
				Print "引数5:" + ps.arg5
			Endif
		Elseif status = 1
			' 描画モード
		Elseif status = 2
			' クリック待機モード
			' クリックがあったらstatusを0にする
			If TouchHit(0) > 0
				status = 0
			Endif
		Elseif status = 3
			' 選択肢待機モード
			' クリックがあったら選択肢レイヤーに座標を渡して
			' どの選択肢が選択されたか取得
			If TouchHit(0) > 0
				Local selectScene:String = Self.selectlayer.TouchEvent(TouchX(), TouchY())
				If  selectScene <> ""
					Self.selectlayer.Clear()
					Self.ps = New Parser
					Self.T = LoadString(Self.sceneMap.Get(selectScene))
					Self.readCommand = 0
					status = 0
				Endif
			Endif
		Endif
	End
	
	Method OnRender()
'		Rescale()
'		Local cwidth:Float = Float(GetCanvasWidth())
'		Local cheight:Float = Float(GetCanvasHeight())
'		Local scaling:Float

		' 縦横比で、小さい方に合わせる
'		If cwidth > cheight
'			scaling = cheight / 600
'		Else
'			scaling = cwidth / 800
'		Endif
		
'		Scale scaling, scaling
		SetCanvasFont "12pt ~qＭＳ Ｐゴシック~q"
		Local drawmode:Int = 0
		drawmode += bglayer.Draw()
		drawmode += personlayer.Draw()
		drawmode += picturelayer.Draw()
		drawmode += messagelayer.Draw()
		drawmode += effectlayer.Draw()
		drawmode += selectlayer.Draw()
		If status < 2
			If drawmode > 0
				status = 1
			Else
				If messagelayer.isDraw = True And messagelayer.isDrawComplete = False
					' 描画が完了して、なおかつメッセージのisDrawがTrueだったらクリック待ちに遷移
					status = 2
					messagelayer.isDrawComplete = True
				Else
					status = 0
				Endif
			Endif
		Endif
		SetColor 255, 255, 255
		DrawCanvasText("status = " + status, 0, 0)
	End

	' 渡された引数のコマンドを処理して、statusを返す
	Method Proc:Int(command:String, arg1:String="", arg2:String="", arg3:String="", arg4:String="", arg5:String="")
		Local result:Int = 0
		' **** 定義系 ****
		If command = "definecharacter"
			Local key:String = arg1 + arg2
			Self.personlayer.Append(key, ps.arg3)
		Elseif command = "definepicture"
			Self.picturelayer.Append(ps.arg1, ps.arg2)
		Elseif command = "definebackground"
			Self.bglayer.Append(ps.arg1, ps.arg2)
		Elseif command = "definevariable"
			Self.variableMap.Set(arg1, 0)
		Elseif command = "definesound"
			Self.soundsMap.Set(arg1, LoadSound(arg2))
		Elseif command = "definemusic"
			Self.musicMap.Set(arg1, arg2)
		Elseif command = "definescene"
			Self.sceneMap.Set(arg1, arg2)
		' **** 制御系 ****		
		Elseif command = "character"
			Local key:String = arg1 + arg2
			Self.personlayer.Set(key, arg3)
			result = 1
		Elseif command = "picture"
			Self.picturelayer.Set(arg1)
			result = 1
		Elseif command = "background"
			Self.bglayer.Set(arg1)
			result = 1
		Elseif command = "fadeout"
			Self.effectlayer.SetEffect("fadeout", Int(ps.arg4), Int(ps.arg1), Int(ps.arg2), Int(ps.arg3))
			result = 1
		Elseif command = "fadein"
			Self.effectlayer.SetEffect("fadein", Int(ps.arg4), Int(ps.arg1), Int(ps.arg2), Int(ps.arg3))
			result = 1
		Elseif command = "clear"
			If arg1 = "background"
				Self.bglayer.Clear()
			Elseif arg1 = "character"
				Self.personlayer.Clear()
			Elseif arg1 = "picture"
				Self.picturelayer.Clear()
			Elseif arg1 = "message"
				Self.messagelayer.Clear()
			Elseif arg1 = "effect"
				Self.effectlayer.Clear()
			Else
				Self.bglayer.Clear()
				Self.personlayer.Clear()
				Self.picturelayer.Clear()
				Self.messagelayer.Clear()
				Self.effectlayer.Clear()
			Endif
			result = 1
		Elseif command = "print"
			Self.messagelayer.SetMessage(ps.arg1, ps.arg2)
			result = 1
		Elseif command = "playsound"
			PlaySound(Self.soundsMap.Get(arg1))
		Elseif command = "playmusic"
			PlayMusic(Self.musicMap.Get(arg1))
		Elseif command = "jump"
			Self.ps = New Parser
			Self.T = LoadString(Self.sceneMap.Get(arg1))
			Self.readCommand = 0
		Elseif command = "jumpif"
			If variableMap.Contains(arg2)
				Local value:Int = Int(arg3)
				If Self.variableMap.Get(arg2) > value
					Self.ps = New Parser
					Self.T = LoadString(Self.sceneMap.Get(arg1))
					Self.readCommand = 0					
				Endif
			Endif
		Elseif command = "title"
			Self.ps = New Parser
			Self.T = LoadString("start.txt")
			Self.readCommand = 0
		Elseif command = "add"
			If Self.variableMap.Contains(arg1)
				Local value:Int = Self.variableMap.Get(arg1)
				value += Int(arg2)
				Self.variableMap.Set(arg1, value)
			Endif
		Elseif command = "sub"
			If Self.variableMap.Contains(arg1)
				Local value:Int = Self.variableMap.Get(arg1)
				value -= Int(arg2)
				Self.variableMap.Set(arg1, value)
			Endif			
		Elseif command = "click"
			result = 2
		Elseif command = "option"
			Self.selectlayer.AppendOption(arg1, arg2)
			result = 0
		Elseif command = "select"
			result = 3
		Endif

		Return result
	End
End

'メインメソッド
Function Main()
	New GameEngine()
End