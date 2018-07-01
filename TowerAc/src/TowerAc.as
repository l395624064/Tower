package 
{
	import control.DataSys;
	import control.GameControl;
	import control.KeyBoardManager;
	import control.SceneManager;

import laya.maths.Point;
import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.utils.Handler;
	import view.TestView;
	import laya.webgl.WebGL;
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.maths.Rectangle;
	import laya.resource.Texture;
	import laya.utils.Browser;
 	import laya.utils.Dictionary;
	import laya.display.Text;
	import laya.wx.mini.MiniAdpter;
	var SoundManager = Laya.SoundManager;
	
	public class TowerAc 
	{
		 
	 
		private var LayaRender:Object; 
		private var mouseConstraint:*;
		private var engine:*;
		public static var gameWorld:Sprite;  
		private const BGPath:String; 
		private var BG:Sprite;
		var width:int=0; 
		var height:int=0;
		public function TowerAc() { 
			 
			MiniAdpter.init(true);
			width=750;
			height = 1334;
			LayaRender = Browser.window.LayaRender; 
			BGPath= "BG.png"; 
			//初始化引擎
			Laya.init(width, height,WebGL);
			
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER; 
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Browser.window.sharedCanvas.width = Laya.stage.width; 
			Browser.window.sharedCanvas.height = Laya.stage.height;
			var res:Array = [
			{url:"res/atlas/myRes.atlas", type:Loader.ATLAS, size:100, priority:2},
			{url:"res/atlas/role1.atlas", type:Loader.ATLAS, size:100, priority:3},
			{url:"res/atlas/ui/main.atlas", type:Loader.ATLAS, size:100, priority:4},
			{url:"res/atlas/ui/side.atlas", type:Loader.ATLAS, size:100, priority:5},
			{url:BGPath, type:Loader.IMAGE, size:100, priority:6} 
			];
			GameControl.Instance.WXInit(res);
			Laya.loader.load(BGPath, Handler.create(this, setup));
		}
		 
		
		private function setup(_e:*=null):void
		{ 
			BG = new Sprite();  
			BG.loadImage(BGPath); 
			Laya.stage.addChild(BG);   
			BG.pos((width - BG.width) / 2, (height - BG.height) / 2);  
			control.SceneManager.Instance.Init(width, height); 
			GameControl.Instance.Init();
			 DataSys.Instance.PlayGlobalMusic();
		} 

        private function myTestA():void
        {

        }
		 
		 
	}

}