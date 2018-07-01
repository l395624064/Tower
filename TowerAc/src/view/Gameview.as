package 
{
	import control.DataSys;
	import control.SceneManager;
	import ui.MainviewUI;
	import laya.events.Event;
	import laya.utils.Ease; 
    import laya.utils.Tween;
	import laya.utils.Handler;
	var SoundManager = Laya.SoundManager;
	/**
	 * ...
	 * @author ...
	 */
	public class Gameview extends MainviewUI 
	{
		private var _callback:Function; 
		private var wxtool:WX_main; 
		public static var userInfo:Object;//玩家存档
		
		public  var systemInfo:Object;//S端功能信息列表
		public  var phoneSetting:Object = {"shake":true, "music":true, "sound":true};//游戏用户设定
		public  var wxuserInfo:Object;//从微信云端获取的个人信息
		
		public function Gameview() 
		{
			
		}
		
		
		public function init(_func:Function,_wxTool:WX_main):void
		{
			this._callback = _func;
			this.wxtool = _wxTool; 
			  
			wxtool.getStorage(updateScore);//获取本地用户信息
			getsysTemInfo();//post服务器获取，获取功能权限信息
			wxtool.setUserInfo();//测试时获取自己信息
			wxtool.removeUserCloudStorage();
			getwxuserInfo();//从微信云端获取的个人信息
			   
		}
		
		private function getwxuserInfo():void
		{
			if (wxtool.playerMsg != null){
				wxuserInfo = wxtool.playerMsg;
				//trace("wxuserInfo-----------------:",wxuserInfo);
				Laya.timer.clear(this, getwxuserInfo);
				return;
			}
			Laya.timer.once(1000, this, getwxuserInfo);
		}
		
		
		private function getsysTemInfo():void
		{
			if (wxtool.serverSystem != null){
				systemInfo = wxtool.serverSystem.data.data;
				//trace("systemInfo:",systemInfo);			
				Laya.timer.clear(this, getsysTemInfo);
				return;
			}
			Laya.timer.once(1000, this, getsysTemInfo);
		}
		private function updateScore(_userinfo):void
		{
			Gameview.userInfo = new Object();
			if (_userinfo==null){
				Gameview.userInfo = {"score":0, "lifeGold":0};
			}
			else{
				Gameview.userInfo = _userinfo;
			}
			trace("1111111111Gameview.userInfo::",Gameview.userInfo);
		}
		/**
		 * 打开指定box view
		 * @param	_str
		 */
		public function openbox(_str:String):void
		{
			switch (_str) 
			{
				case "open_box":openview();
				break;
				case "gameover_box": 
					overview();
				break;
				case "seeAD_box":seeADview();
				break;
				case "selfRank_box":selfRankview();
				break;
				//case "setting_box":settingview();
			//	break;
				default:trace("——————box组件未找到");
			}
		}
		private function GiftView():void
		{
			gift_btn.on(Event.CLICK, this,GetGift);
		}
		
		private function openview():void
		{
			//trace("游戏开始页面");
			clearAllbox();//重置其他页面
			this.open_box.visible = true;
			//this.addChild(open_box);
			
			score_op_txt.text = "暂无历史分";//最高分
		//	life_op_txt.text = "分享得复活币";//复活币 
			//setting_op_btn.on(Event.MOUSE_DOWN, this,openbox,["setting_box"]);
			music_op_btn.on(Event.CLICK, this, onMusic );
			shake_op_btn.on(Event.CLICK, this, onShake );
			playgame_op_btn.on(Event.CLICK, this,PlayGame );
			rank_op_btn.on(Event.MOUSE_DOWN, this, rankView);
			share_op_btn.on(Event.MOUSE_DOWN, this, onShare);
			GiftView();
		}
		private function PlayGame(e:Event):void
		{
			 clearStartImage();  
		}
		private function GetGift(e:Event):void
		{   
			 wxtool.previewImage(DataSys.Instance.PlayGlobalMusic, [DataSys.Instance.serverSystem.data.data['box_qrcode']]);
			 
			 
		}
		private function rankView():void
		{
			//获取排行榜列表
			trace("————————————好友排行榜页");
			this.friendRank_box.visible = true;
			this.addChild(friendRank_box);
			 
			this.friend_rank_btn.on(Event.MOUSE_DOWN, this, friend_rank);
			this.world_rank_btn.on(Event.MOUSE_DOWN, this, world_rank);
			this.friendRank_closed.on(Event.MOUSE_DOWN, this, onclosed);
			this.ongroup_btn.on(Event.MOUSE_DOWN, this, onShare);
			/////////////////////////////////////////////////////////////////////////获取好友排名
			 InitRank();
		}
		private function InitRank():void{
			
			var initObj:Object =  {"type":"initRank",
		   	"stageW":Laya.stage.width,"stageH":Laya.stage.height,
			"rankX":0,"rankY":100,"rankW":610,"rankH":750,
			"rankNumX":15,"soldW":600,"soldH":100,
			"icoW":80,"icoH":80,
			"scoreX":470,
			"icoX":100,
			"nameX":200,
			"fontsize":40,"pix":30
			};
		 
			trace("初始化排行");
		 	wxtool.postMsgTo("", initObj);//向子域发送信息
		}
		private function onclosed(e):void
		{
			this.friendRank_box.visible = false;
		}
		
		private function friend_rank(e:Event):void
		{
			if (DataSys.Instance.score>Gameview.userInfo.score){
				wxtool.setStorage({"score":DataSys.Instance.score, "lifeGold":DataSys.Instance.lifegold});
			}
			else{
				wxtool.setStorage({"score":Gameview.userInfo.score, "lifeGold":DataSys.Instance.lifegold});
			}
			var initObj:Object = {"type":"friend",
		 	"stageW":Laya.stage.width,"stageH":Laya.stage.height,
			"rankX":280,"rankY":560,"rankW":610,"rankH":750,
			"rankNumX":15,
			"soldW":600,"soldH":100,
			"icoW":80,"icoH":80,
			"scoreX":470,
			"icoX":100,
			"nameX":200,
			"fontsize":40,"pix":30
			};
			trace("好友排行"); 
		 	wxtool.postMsgTo("", initObj);//向子域发送信息
		//	Laya.timer.once(3000, this, onCompletefriend_rank);
		}
		 private function onCompletefriend_rank(e:Event):void
		 { 
			wxtool.postMsgTo("friend_nextPage");//向子域发送信息
		 }
		 private function world_rank(e:Event):void
		{
			 
			var initObj:Object = {
				"type":"selfAndside",
				"username":wxuserInfo['nickName'],
				"stageW":Laya.stage.width,
				"stageH":Laya.stage.height,
				"rankX":0,
				"rankY":0,
				"rankW":650,
				"rankH":265,
				"icoX":[120,342,565],
				"icoY":[677,677,677],
				"nameX":[70,295,520],
				"nameY":[782,782,782],
				"scoreX":[70,295,520],
				"scoreY":[782,782,782],
				"numberX":[110,336,556],
				"numberY":[623,623,623],
				"fontsize":[30, 30, 30],
				"itemW":[100,80,176,176],
				"itemH":[40,80,40,40],
				"fontcolor":["#ffffff","#ffffff","#ffffff"]
			}; 
			wxtool.postMsgTo("self", initObj);//向子域发送信息
			trace("世界排行");
		}
		   
		
		private function selfRankview():void
		{
			trace("————————————————自己排名，最后一个结束页");
			clearAllbox();
			this.selfRank_box.visible = true;
			//this.addChild(selfRank_box);
			
			/////////////////////////////////////////////////////////////////////上传分数，并获取自己排名
			this.selfgold_txt.text = DataSys.Instance.lifegold;
			this.selfscore_txt.text = DataSys.Instance.score;
			if (DataSys.Instance.score>Gameview.userInfo.score){
				wxtool.setStorage({"score":DataSys.Instance.score, "lifeGold":DataSys.Instance.lifegold});
			}
			else{
				wxtool.setStorage({"score":Gameview.userInfo.score, "lifeGold":DataSys.Instance.lifegold});
			}
			
			this.resetGame_btn.on(Event.MOUSE_DOWN, this, ReStartGame);
			this.home_btn.on(Event.MOUSE_DOWN, this, Home);
				////排列顺序：排名txt,icoImg,nametxt,scoretxt
			var initObj:Object = {
				"type":"selfAndside",
				"username":wxuserInfo['nickName'],
				"stageW":Laya.stage.width,
				"stageH":Laya.stage.height,
				"rankX":0,
				"rankY":0,
				"rankW":650,
				"rankH":265,
				"icoX":[120,342,565],
				"icoY":[677,677,677],
				"nameX":[70,295,520],
				"nameY":[782,782,782],
				"scoreX":[70,295,520],
				"scoreY":[782,782,782],
				"numberX":[110,336,556],
				"numberY":[623,623,623],
				"fontsize":[30, 30, 30],
				"itemW":[100,80,176,176],
				"itemH":[40,80,40,40],
				"fontcolor":["#ffffff","#ffffff","#ffffff"]
			};
			wxtool.postMsgTo("", initObj);//向子域发送信息
		}
		
		private function overview():void
		{
			trace("——————————————游戏结束页面1.3");
			clearAllbox();
			
			this.gameover_box.visible = true;
		//	this.addChild(gameover_box);
			
			gameScore_txt.text = DataSys.Instance.score;
			lifegold_txt.text = DataSys.Instance.lifegold;
			
			this.newlife_btn.on(Event.MOUSE_DOWN, this, uselifegold);
			this.shareFriend_btn.on(Event.MOUSE_DOWN, this, onShare);
			this.overNext_btn.on(Event.MOUSE_DOWN, this, onADNext);////////////////post服务器,获取是否有视频接口
			 
		} 
		
		private function onADNext():void
		{
			if (!systemInfo.ad_relive){
				selfRankview();//AD功能未开放
				return;
			}
			
			trace("——————————————观看视频复活");
			clearAllbox();
			
			this.seeAD_box.visible = true;
			this.addChild(seeAD_box);
			
			ADscore_txt.text = DataSys.Instance.score as String;//最高分
			ADlifegold_txt.text = DataSys.Instance.lifegold as String;//复活币
			
			seeAD_btn.on(Event.MOUSE_DOWN, this, seeAD);
			lastNext_btn.on(Event.MOUSE_DOWN, this, selfRankview);
		}
		
		private function seeAD():void
		{
			trace("——————————————开始观看视频");
		}
		private function uselifegold():void
		{
			trace("——————————————花费复活币");
			 if (DataSys.Instance.UseLifeGold())
			 {
				 ReLive();//重新开始游戏
			 } 
			 wxtool.setStorage({"score":DataSys.Instance.score, "lifeGold":DataSys.Instance.lifegold});
		}
		
		 
		/* 
		
		private function settingview():void
		{
			trace("设置页面————");
			this.setting_box.visible = true;
			this.addChild(setting_box);
			
			this.close_setting_btn.on(Event.MOUSE_DOWN, this, onclosesetting);
			this.cdk_setting_btn.on(Event.MOUSE_DOWN, this, onCheckCDK);
			this.music_setting_btn.on(Event.MOUSE_DOWN, this, onMusic);
			this.sound_setting_btn.on(Event.MOUSE_DOWN, this, onSound);
			this.shake_setting_btn.on(Event.MOUSE_DOWN, this, onShake);
		}
		*/
		 
		
		private function onMusic(e):void
		{
			music_op_btn.gray = !music_op_btn.gray;
			trace("————————————————————音乐");
			phoneSetting.music = music_op_btn.gray;
			 if(music_op_btn.gray)
			 SoundManager.setSoundVolume(0, "res/sound/background.mp3");
			 else 
			 SoundManager.setSoundVolume(1, "res/sound/background.mp3");
		}
		
		private function onSound(e):void
		{
		//	sound_setting_btn.gray = !sound_setting_btn.gray;
			trace("————————————————————音效");
		//	phoneSetting.sound =sound_setting_btn.gray;
		}
		
		private function onShake(e):void
		{
			shake_op_btn.gray = !e.target.gray;
			trace("————————————————————震动");
		    phoneSetting.shake =shake_op_btn.gray;
		}
		
		
		
		private function onclosesetting():void
		{
			this.setting_box.visible = false;
		}
		
		private function onCheckCDK():void
		{
			trace("————————————CDK检查");
			//input_setting_btn.text = "";
			//input_setting_btn.prompt = "您输入的cdk不合法";
		}
		
		
		private function seeADview():void
		{
			trace("广告页面——————");
			clearAllbox();//重置其他页面
			this.seeAD_box.visible = true;
			this.addChild(seeAD_box);
		}
		
		
		public function clearStartImage():void
		{
			Tween.to(playgame_op_btn, {  y : -1000}, 2000, Ease.expoOut);
			Tween.to(container, {  x : -1000}, 2000, Ease.expoOut,Handler.create(this,StartGame));  
		}
		
		 public function  StartGame():void
		{
			if (_callback != null)
			{
				 clearAllbox();
				_callback("gameing");
			}
			DataSys.Instance.SetScore(0);
			playgame_op_btn.pos(34, 264);
			container.pos(0,0);
		}
		 public function  ReStartGame():void
		{
			SceneManager.Instance.Clear();
			DataSys.Instance.SetScore(0);
			if (_callback != null)
			{
				 clearAllbox();
				_callback("gameing");
			}
			wxtool.postMsgTo("close");//关闭子域的sharedCanvas
		}
		 
		 public function  ReLive():void
		{ 
			if (_callback != null)
			{
				 clearAllbox();
				_callback("relive");
			}
			wxtool.postMsgTo("close");//关闭子域的sharedCanvas
		}
		  public function  Home():void
		{
			SceneManager.Instance.Clear();
			DataSys.Instance.SetScore(0);
			 
			 openview();//打开首页
			 wxtool.postMsgTo("close");//关闭子域的sharedCanvas
		}
		
		 
		
		public function clearAllbox():void
		{
			this.open_box.visible = false;
			this.gameover_box.visible = false;
			this.seeAD_box.visible = false;
			this.selfRank_box.visible = false;
			this.friendRank_box.visible = false;
			 
		}
		
		public function UpdateScore(value:Number):void
		{
			this.score.text = value; 
			 
		}
		public function UpdateLifeGold(value:Number):void
		{ 
			life_op_txt.text= value;
			 
		}
		
		 private function onShare(_ifaddrank:Boolean=false):void
		{
			//主动拉起转发
			trace("————————————主动调用转发");
			//只转发不调用群排行
			wxtool.shareAppMessage("https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3612345154,1744882367&fm=27&gp=0.jpg",_ifaddrank,true);//由子域调用
		}
	}

}