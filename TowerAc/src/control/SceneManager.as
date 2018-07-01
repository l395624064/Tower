package control {
	import Vector;
	import Vector;
	import laya.d3.math.Vector3;
	import laya.net.Loader;
	import laya.net.ResourceVersion;
	import laya.ui.Image;
	import laya.utils.Handler;
	import model.Block;
	import model.CutBlock;
	import model.CutResult;
	import model.Layer;
	import model.Side;
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
	
	import laya.d3.math.Rand; 
    import laya.utils.Ease; 
    import laya.utils.Tween;
 var SoundManager = Laya.SoundManager;
	
	public class SceneManager  
	{
		private const FarPath:String = "BG/far.png";  
		private const MiddlePath:String = "BG/middle.png";  
		private const NearPath:String = "BG/near.png"; 
		 
		private const mainPath:String = "res/atlas/ui/main.atlas"; 
		private const sidePath:String = "res/atlas/ui/side.atlas"; 
		 
		
		public var txt:Text; 
		private var AniLayer:Image; 
		public var farLayer:Image; 
        public var middleLayer:Image;
		public var nearLayer:Image; 
		public var bottomLayer:Image; 
		public var BGLayer:Image;
		public var UILayer:Image;
		///远 中 近三张图片 
		public var far:Image = new Image();
		public var middle:Image = new Image();
		public var near:Image = new Image();
		public var bottom:Image = new Image();
		 
		public var width:int=0;
		public var height:int = 0;
		public var tower:Vector.<Layer>;
		public var m_to:Number = 0;
		public var speed:Number = 0;
		public var speedValue:Number = 4;
		
		public var bottomwidth:int=357;
		public var bottomheight:int = 385;
		public var L:Number = 0;
		public var R:Number = 0;
		public var FarHeight:Number = 1334;
		public var IsPut:Boolean;
		 
		private static var  _instance:SceneManager;  
		public function SceneManager() 
        {
             
        }
		public function Init(_width:int,_height:int):void
		{
			tower = new Vector.<Layer>();
			width = _width;
			height = _height; 
			BGLayer = new Image();
			AniLayer=new Image();
			farLayer = new Image(); 
			middleLayer=new Image();
			nearLayer = new Image(); 
			bottomLayer= new Image();
			UILayer = new Image();
			Laya.stage.addChild(UILayer);
			Laya.stage.addChild(BGLayer);
            Laya.stage.addChild(farLayer);
			Laya.stage.addChild(middleLayer);
			//Laya.stage.addChild(AniLayer); 
			Laya.stage.addChild(nearLayer); 
			Laya.stage.addChild(bottomLayer); 
			 BGLayer.pos(0, 0);
			farLayer.pos(0, 0);
			middleLayer.pos(0, 0);
			nearLayer.pos(0, 0);
			UILayer.pos(0, 0);
			bottomLayer.pos(0, 0);
			Laya.loader.load(FarPath, Handler.create(this, setupFar));
			Laya.loader.load(MiddlePath, Handler.create(this, setupMiddle));
			Laya.loader.load(NearPath, Handler.create(this, setupNear));
			 
		}
		public function StartGame():void
		{
			Laya.loader.load(mainPath, Handler.create(this, setupMain));
			Laya.loader.load(sidePath, Handler.create(this, setupSide));
			 
			 AddListener();
			createLogger();
			 
			IsPut = false;
		}
		public function AddListener():void
		{ 
			Laya.stage.on(Event.MOUSE_MOVE, this, GragUI_OnMouseMove); 
			Laya.stage.on(Event.MOUSE_UP, this, GragUI_OnMouseUp); 
			Laya.stage.on(Event.MOUSE_DOWN, this,  OnMouseDown);  
			Laya.timer.frameLoop(1, this, animateFrameRateBased);
			IsPut = false;
		}
		public function RemoveListener():void
		{ 
			Laya.stage.off(Event.MOUSE_MOVE, this, GragUI_OnMouseMove); 
			Laya.stage.off(Event.MOUSE_UP, this, GragUI_OnMouseUp); 
			Laya.stage.off(Event.MOUSE_DOWN, this,  OnMouseDown);  
			IsPut = true;
		}
		 
		public function GragUI_OnMouseMove(e:Event=null):void
    	{
			 
			appendText((e.stageX)+":"+(e.stageY));
		}
		public function GragUI_OnMouseUp(e:Event=null):void
    	{
		 
		} 
		public function OnMouseDown(e:Event=null):void
    	{
			 if (relive){
				 relive = false;
				 return; 
			 }
			  
			if (TowerSys.Instance.blocks.length == 0) 
			{
				  if (!AniSys.Instance.role.IsOver)
						{
							  
						} 
				return; 
			}
			var _block:Block = TowerSys.Instance.blocks.pop();
			 
			if (_block != null)
			{
				curBlock = _block;
				IsPut = true; 
				 
				Laya.timer.frameOnce(10, this, onComplete2); 
			} 
		} 
		public var curBlock:Block;
		public var cutV3:CutResult;
		 function onComplete2()
		{
			  var _block:Block = curBlock;
				var lastX:Number = 0; 
				var towerLen:Number = tower.length; 
				var layer:Layer = new Layer(towerLen);   
				 
				if (towerLen == 0)
				{
					lastX = (Laya.stage.width - bottomwidth) / 2;
					cutV3 = _block.GetSide(lastX, bottomwidth);
					  
					layer.GetLayer(cutV3.NextBlock.x, 949 - layer.Height, cutV3.NextBlock.y); 
					layer.GetSide();
					nearLayer.addChild(layer.img);  
					 
				    RouteSys.Instance.StartClimb();
					if (towerLen % 3 == 0&&layer.width>0)
					 {
						// RouteSys.Instance.SetRoute(new Vector3(layer.img.x+layer.width/2,layer.img.y+middleLayer.y-nearLayer.y+layer.Height,0));
						RouteSys.Instance.SetRoute(new Vector3(layer.img.x+layer.width/2,layer.img.y +layer.Height,0));
					 }
				}
				else { 
					var lastLayer:Layer = tower[towerLen - 1] as Layer;
					lastX = lastLayer.img.x;
					cutV3 = _block.GetSide(lastX, lastLayer.width);
					 
					layer.GetLayer(cutV3.NextBlock.x, lastLayer.img.y - layer.Height, cutV3.NextBlock.y);
					nearLayer.addChild(layer.img); 
					if (!lastLayer.hasSide)
					layer.GetSide();
					 
					 if ( layer.width==0)
					 {
						 var lastLayerX:Number = lastLayer.img.x + lastLayer.width / 2;
						 //var lastLayerY:Number = lastLayer.img.y + middleLayer.y - nearLayer.y;
						 var lastLayerY:Number = lastLayer.img.y ;
						 
						 RouteSys.Instance.SetRoute(new Vector3(lastLayerX,lastLayerY, 0));
						 if (!AniSys.Instance.role.IsOver)
						{
							var lastLayer:Layer = tower[tower.length - 1] as Layer;
							   
							RouteSys.Instance.SetRoute(new Vector3(lastLayerX,lastLayerY - 50, 0));
							RouteSys.Instance.SetRoute(new Vector3(lastLayerX,lastLayerY + 100, 0));
							RouteSys.Instance.SetRoute(new Vector3(lastLayerX, 1500, 0));
							AniSys.Instance.Over(true);
							RemoveListener();
						} 
					 }
					  if (towerLen % 3 == 0&&layer.width>0)
					 {
						 if (RouteSys.Instance.route > 0)
						{
							//RouteSys.Instance.SetRoute(new Vector3(RouteSys.Instance.route[RouteSys.Instance.route-1].x, layer.img.y+middleLayer.y-nearLayer.y+(tower[towerLen - 1] as Layer).Height, 0));
							RouteSys.Instance.SetRoute(new Vector3(RouteSys.Instance.route[RouteSys.Instance.route-1].x, layer.img.y+(tower[towerLen - 1] as Layer).Height, 0));
							
						} 
							//RouteSys.Instance.SetRoute(new Vector3(layer.img.x+layer.width/2,layer.img.y+middleLayer.y-nearLayer.y+(tower[towerLen - 1] as Layer).Height,0));
						 RouteSys.Instance.SetRoute(new Vector3(layer.img.x+layer.width/2,layer.img.y +(tower[towerLen - 1] as Layer).Height,0));
						 
					 }
					   
				} 
					  
				var cutBlock:CutBlock = new CutBlock();
				cutBlock.CutByWith(cutV3.DropBlock.x, cutV3.DropBlock.y,cutV3.DropBlock.z,cutV3.pathIndex); 
				bottomLayer.addChild(cutBlock);
				//cutBlock.y = curBlock.img.y+middleLayer.y-nearLayer.y+curBlock.Height / 2;
				cutBlock.y = curBlock.img.y+curBlock.Height / 2;
				cutBlock.VOffset(far.height);
				 
				TowerSys.Instance.CutBlocks.push(cutBlock);
				if(layer.width>0)
				tower.push(layer);
				
				 if (cutV3.DropBlock.y==0){
						//完美搭建一次 计数加1
					 
						DataSys.Instance.perfect += 1;
						if (DataSys.Instance.perfect == 5)
						{
							for (var l:int=0; l < 4; l++ )
							{
								SoundManager.playSound("res/sound/perfect.mp3", 1, null);
								GetLayer(cutV3);
								  
							} 
							DataSys.Instance.perfect = 0;
						}else 
						{
							SoundManager.playSound("res/sound/perfect.mp3", 1, null);
						}
					}else {
						DataSys.Instance.perfect = 0;
						if (layer.width > 0)
						SoundManager.playSound("res/sound/crash.mp3", 1, null);
					}
					 
					DataSys.Instance.SetScore(tower.length); 
					 
				if (layer.width > 0)
				{
					if (curBlock != null)
					{
						curBlock.ClearBlock(); 
					}
					_block = GenerateBlock();   
					if (_block != null)
				   {
					   
						if (Math.random() < 0.5) 
						{
							_block.img.x =L;
						} else  
						{
							_block.img.x = R;
						} 
						speed = m_to - _block.img.x >= 0?speedValue: -speedValue; 
				   }
					 
					TowerSys.Instance.lastBlock = null;
				}
			   else 
			   {
				   nearLayer.addChild(_block.img);
				   TowerSys.Instance.lastBlock = _block;
				   _block.VOffset(far.height);
			   } 
		}
		///完美搭建赠送
		public function GetLayer(cutV3:CutResult):void{
			var towerLen:Number = tower.length; 
				var layer:Layer = new Layer(towerLen);   
				var lastLayer:Layer = tower[towerLen - 1] as Layer;
				layer.GetLayer(cutV3.NextBlock.x, lastLayer.img.y - layer.Height, cutV3.NextBlock.y);
					nearLayer.addChild(layer.img); 
					if (!lastLayer.hasSide)
					layer.GetSide();
					tower.push(layer);
					if (towerLen % 3 == 0&&layer.width>0)
					{
						//RouteSys.Instance.SetRoute(new Vector3(layer.img.x+layer.width/2,layer.img.y+middleLayer.y-nearLayer.y+(tower[towerLen - 1] as Layer).Height,0));
					
					RouteSys.Instance.SetRoute(new Vector3(layer.img.x+layer.width/2,layer.img.y+(tower[towerLen - 1] as Layer).Height,0));
						
						
					}
		}
		public static function get Instance():SceneManager 
		{
			if(_instance==null)
			{
			  _instance=new SceneManager();
			} 
			return _instance; 
		}
		///加载场景 
		public function   setupFar(_e:*=null):void
		{ 
            
			far.skin=FarPath; 
			farLayer.addChild(far);   
			far.pos((width - far.width) / 2, (height - far.height) / 2);  
			L = (Laya.stage.width - far.width) / 2;
			R = (Laya.stage.width + far.width) / 2;
		 
			 
		}
		public function   setupMiddle(_e:*=null):void  
		{  
			middle.skin=MiddlePath; 
			middleLayer.addChild(middle);   
			middle.pos((width - middle.width) / 2, (height - middle.height) / 2);  
			 
		}
		
		public function   setupNear(_e:*=null):void  
		{ 
             
			near.skin=NearPath; 
			bottomLayer.addChild(near);   
			near.pos((width - near.width) / 2, (height - near.height) / 2);  
			TowerSys.Instance.GenerateBlock(bottomwidth);
		}	
		 
		public function   setupMain(_e:*=null):void  
		{
			 
			 	GenerateBlock();
		}	
		public function   setupSide(_e:*=null):void  
		{ 
             
			 
		}	 
		 
		 ///生成移动物体
		public function GenerateBlock():Block
		{
			var block:Block;
			var width:Number = 0;
			  if (tower.length == 0)
			 {
				 width = bottomwidth;
				 block = TowerSys.Instance.GenerateBlock(width,tower.length);
				 if (block != null)
				 {
					 block.img.y = 949-block.Height; 
					 nearLayer.addChild(block.img);
				 }
			 }else{
				 
				 width = tower[tower.length - 1].width;  
				 block = TowerSys.Instance.GenerateBlock(width,tower.length);
				 if (block != null)
				 {
					 var towerLen:Number = tower.length;
					 block.img.y = tower[towerLen-1].img.y -block.Height;
					 nearLayer.addChild(block.img);
				 } 
			}  
			 m_to == 0? far.width:0; 
			 return block;
		}
		 
		private function appendText(value:String):void
		{
			txt.text = value;
			txt.scrollY = txt.maxScrollY;
		}
		
		/**添加提示文本*/
		public function createLogger():void
		{
			txt = new Text(); 
			txt.overflow = Text.SCROLL;
		//	txt.text = "请把鼠标移到到矩形方块,左右键操作触发相应事件\n";
			txt.size(Laya.stage.width, Laya.stage.height);
			txt.pos(0, 0);
			txt.fontSize = 20;
			txt.wordWrap = true;
			txt.color = "#FFFFFF"; 
			 nearLayer.addChild(txt);
		}
		 
		public function animateFrameRateBased():void
		{
			var blocks:Array = TowerSys.Instance.blocks;
			  for (var b :Number = 0; b < blocks.length;b++ )
			  {
				  var block:Block = blocks[b];
				  block.img.x += speed; 
				  if (block.img.x >= R-block.width/2)
				  {
					  m_to = 0;
					  block.img.x = R - block.width / 2;
					  speed = m_to - block.img.x >= 0?speedValue: -speedValue; 
				  }else if (block.img.x <= L+block.width/2)
				  {
					  m_to = far.width;
					  block.img.x = L + block.width / 2;
					  speed = m_to - block.img.x >= 0?speedValue: -speedValue; 
				  }
				  
			  }
			   DownWard();
			   TowerSys.Instance.TowerDrop(far.height);
			  
		}
		 
		public function DownWard():void
		{
			var towerLen:Number = tower.length;
			if (towerLen > 0)
			{
				var towerY:Number = AniSys.Instance.role.GameAni.y;
				if (!AniSys.Instance.role.IsOver)
				{
					var lastLayer:Layer = tower[towerLen - 1] as Layer;
					//towerY = lastLayer.img.y; 
				} 
				var offset:Number = far.height / 3 - towerY;
				if (towerY < far.height / 3)
				{
					farLayer.y = offset * 1.2;
					middleLayer.y = offset * 1.1;
					nearLayer.y = offset;
					bottomLayer.y=offset;
					//Tween.to(farLayer, {  y : offset * 1.2}, 1000, Ease.expoOut);
					//Tween.to(middleLayer, {  y : offset * 1.1}, 1000, Ease.expoOut);
					//Tween.to(nearLayer, {  y : offset}, 1000, Ease.expoOut); 
				}
				TowerVisible();
			} 
			 
		}
		
		public function Clear():void
		{
			for (var i:int = 0; i < tower.length; i++ )
			{
				tower[i].img.parent.removeChild(tower[i].img);
			}
			tower = new Vector.<Layer>();
			TowerSys.Instance.ClearBlock(); 
			middleLayer.removeChildren(0, 100);
			 
			RouteSys.Instance.Init();
			AniSys.Instance.Clear();
			Laya.timer.clear(this,animateFrameRateBased);
			
		}
		public function Relive():Vector3
		{
			var towerLen:Number = tower.length;  
			var lastLayer:Layer = tower[towerLen - 1] as Layer;
			var spawnX:Number = (Laya.stage.width - bottomwidth / 2) / 2; 
			//var spawnY:Number = lastLayer.img.y+(middleLayer.y-nearLayer.y); 
			var spawnY:Number = lastLayer.img.y; 
			 lastLayer.Clear();
			 lastLayer.GetLayer(spawnX, spawnY, bottomwidth/2);
			 AddListener(); 
			 
			 GenerateBlock();   
			 relive = true;
			 return new Vector3(spawnX,spawnY,0);
		}
		public var relive:Boolean = false;
		
		public function TowerVisible():void{
			
			 
			for (var i:int = 0; i < tower.length; i++ )
			{
				var layer:Layer = (tower[i] as Layer); 
				if (layer.img.y+nearLayer.y> far.height||layer.img.y+nearLayer.y<0)  
				{
					layer.img.visible = false;
				}else 
				{
					layer.img.visible = true;
					 
				}
			}
		}
	}

}