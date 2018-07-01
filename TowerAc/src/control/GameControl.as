package control 
{
	import laya.d3.math.Vector3;
	import laya.wx.mini.MiniAdpter;
	public class GameControl 
	{
		private var wxtool:WX_main;/////////微信api
		public var uiview:Gameview;
		public function GameControl(){} 
		private static var  _instance:GameControl; 
		public static function get Instance():GameControl 
		{
			if(_instance==null)
			{ 
			  _instance=new GameControl();
			} 
			return _instance; 
		} 
		
		public function WXInit(_arr:Array):void{
			  
		 	wxtool = new WX_main();
			//必须要初始化rankview值,禁用sta矩阵
			var initObj: any = {
				"type": "initRank",
				"stageW": Laya.stage.width,
				"stageH": Laya.stage.height,
				"rankX": 150,
				"rankY": 260,
				"rankW": 550,
				"rankH": 695,
				"rankNumX": 7,
				"soldW": 550,
				"soldH": 100,
				"icoW": 80,
				"icoH": 80,
				"scoreX": 470,
				"icoX": 100,
				"nameX": 200,
				"fontsize": 60,
				"pix": 100
				};
		 	wxtool.init(2,initObj,_arr);//发送信息给子域 
		}
		public function Init():void{
			  
			Laya.timer.once(1000, this, onGame);//延迟一秒加载  test ui
		}
		private function onGame():void
		{
			uiview = new Gameview();
			uiview.init(controlGame.bind(this),wxtool);
			Laya.stage.addChild(uiview);
			
			controlGame("gameopen");//test
		}
		
			private var gameState:String;
		
		public function controlGame(str:String=""):void{
			gameState = str;
			if (gameState == "gameopen")
			{
				uiview.openbox("open_box");
				
			}else if (gameState == "gameing")
			{ 
				StartGame(); 
				
			}else if (gameState == "gameover")
			{
				uiview.openbox("gameover_box",0);
			}else if (gameState == "relive")
			{
				Relive();
			}
			
		}
		private function StartGame():void
		{ 
			control.KeyBoardManager.Instance.Init(); 
			control.SceneManager.Instance.StartGame();
			control.RouteSys.Instance.Init();
			control.RouteSys.Instance.Start(); 
			control.AniSys.Instance.Init();
			control.AniSys.Instance.FirstPos();
			 DataSys.Instance.PlayGlobalMusic();
		}
		
		private function Relive():void
		{ 
			KeyBoardManager.Instance.Init();  
			RouteSys.Instance.Init(); 
			RouteSys.Instance.Start();
			RouteSys.Instance.StartClimb();
			var spawn:Vector3 = control.SceneManager.Instance.Relive();
			RouteSys.Instance.SetRoute(spawn);
			AniSys.Instance.Clear();
			AniSys.Instance.Init(); 
			AniSys.Instance.Relive(spawn);
		}
	}

}