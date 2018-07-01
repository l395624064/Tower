package Animation 
{
	import Mathf.ExQuaternion;
	import control.GameControl;
	import laya.display.Animation;
	import laya.display.Sprite;
	import laya.maths.Rectangle;
    import laya.utils.Handler;
    import laya.webgl.WebGL;
	import laya.d3.math.Vector3;
	import laya.d3.math.Quaternion; 
	var Event   = Laya.Event;
	var Rectangle = Laya.Rectangle;
	var SoundManager = Laya.SoundManager;
	
	import control.RouteSys;
	/**
	 * ...
	 * @author ...
	 */
	public class AtlasAni 
	{
		public var GameAni:Animation; 
		 
		private var name:String; 
		private var atlas_name:String; 
		private var atlas_url:String = "res/atlas/animation/role.atlas"; 
		private var atlas_url1:String="res/atlas/role1.atlas"; 
		private var stage:Sprite;
		
		public var pos:Vector3;
		public var forward:Vector3; 
		public var up:Vector3;
		public var velocity:Vector3;
		private var rot:Quaternion;
		public var speed:Number;
		public var stand:Boolean;
		public var curIndex:int;
		public var route:Vector.<Vector3>;
		public var scale:Number;
		public var gravity:Number;
		public var GravityV:Vector3;
		public var IsPlaying:Boolean;
		public var IsOver:Boolean;
		public var bounds:Rectangle;
		 
        public function AtlasAni(_stage:Sprite)
        {
			stand = true;
			route = RouteSys.Instance.route; 
			forward = Vector3.ZERO;
			pos = Vector3.ZERO;
			velocity = Vector3.ZERO;
			route = new Vector.<Vector3>();
			rot = new Quaternion(0, 0, 0, 1);
			up = new Vector3(0,1,0);
			speed = 2.5;
			scale = 0.6;
			stage = _stage;
           // atlas_name =_atlas_name;
			//atlas_url = _atlas_url;  
			gravity = 0;
			IsPlaying = false;
			IsOver = false;
			GravityV = new Vector3(0, gravity, 0);
			 
			 
			 onLoadedTimeLine();
			  curIndex=0;
           // roleAni.loadAtlas(_atlas_url + _atlas_name+".atlas", Handler.create(this, onLoaded));    
			//Laya.loader.load(atlas_url1, Handler.create(this,onLoadedTimeLine));
        }
         
		 private function onLoadedTimeLine():void
        {
			GameAni = new Animation();
			GameAniInitPos(); 
			GameAni.loadAnimation("GameAni.ani"); 
        }
		 
		public function Move():void
        {
			 if (GameAni == null) return;
			if (curIndex<RouteSys.Instance.route.length)
			 {
				   if (curIndex == 0)
					 {
						 if(!IsPlaying) 
						 IsPlaying = PlayAction("stand", true);
						 
					 }else if (curIndex == 1)
					 {
						  if (!IsPlaying)
						  { 
							  IsPlaying = PlayAction("run", true);
							  GameAni.visible = true;
						  }
						   
					 }else if (curIndex >= 2)
					 {
						  if (gravity == 0)
						  {
							  if(!IsPlaying) 
							  IsPlaying = PlayAction("climb", true); 
						  } 
						  if (IsOver)
						  {
							  if (curIndex == RouteSys.Instance.route.length -3)
							  { 
								   if (!IsPlaying)
								   {
									   IsPlaying = PlayAction("readyJump", false); 
								   } 
							  }else  if (curIndex== RouteSys.Instance.route.length-1)
							  { 
								  PlayAction("jumpdown", false);  
								 
							  }else if (curIndex<=RouteSys.Instance.route.length -4)
							  {
								   if(!IsPlaying) 
									IsPlaying = PlayAction("climb", true);
							  }
							   
						  }
						 
					 }
				 if (routePoint(curIndex))
				 {
					 IsPlaying = false;
					 if (curIndex > 1)
					 {  
						   if (gravity == 0)
						  {
							  if(route[curIndex].y!=route[curIndex-1].y)
							  PlayAction("stand", true); 
							   
						  }else 
						  {
							   if (IsOver)
							   {
								    if (curIndex==RouteSys.Instance.route.length -4)
									  {
										    PlayAction("stand", false); 
									  }
							  
									 if (curIndex== RouteSys.Instance.route.length-3)
									 {
										if (!IsPlaying)
										{
											IsPlaying =PlayAction("jumpup", false);  
											SoundManager.playSound("res/sound/flydown.mp3", 1, null);
										}
										 
								    } 
									if(curIndex == RouteSys.Instance.route.length-1)
									{
										 SoundManager.playSound("res/sound/fall2.mp3", 1, null); 
										GameControl.Instance.uiview.overview();
									}
							   } 
						  }
					 } 
					 curIndex++; 
				 }
			 }  
		}
		public function Start():void
        { 
			 curIndex = 0; 
			 IsOver = false;
		}
         public function Relive():void
        { 
			 curIndex = RouteSys.Instance.route.length - 1;
			 IsOver = false;
		}
		public function GameAniInitPos():void
		{
			 //创建动画实例
            route = RouteSys.Instance.route;  
			GameAni.scale(scale, scale); 
			stage.addChild(GameAni);  
			// 获取动画的边界信息
			bounds= GameAni.getGraphicBounds();
			GameAni.pivot(bounds.width / 2, bounds.height / 2);     
			GameAni.interval = 30; 
		}
		 public function SetPos(spawn:Vector3):void
		{
			GameAni.pos(spawn.x, spawn.y, true);  
			pos = new Vector3(spawn.x, spawn.y, 0);  
		}
		public function FirstPos():Vector3
		{
			return new Vector3(route[0].x- (136 * scale)/2, route[0].y- (153 * scale),0); 
		}
		 
		/*
		public function routePoint(curIndex:int):Boolean
		{
			 
			route=RouteSys.Instance.route;
			var point:Vector3 = route[curIndex];
			 Vector3.subtract(point, pos, forward);
			 Vector3.normalize(forward,forward);
			 Vector3.scale(forward,speed,velocity); 
			 Vector3.add(pos, velocity, pos);  
			 roleAni.pos(pos.x, pos.y- (230 * scale)/2);  
			  var dis:Number = Vector3.distance(point, pos);
			 if (dis < speed *10)
			 { 
				 return true;
			 }else{
				    
				// roleAni.rotation =  (Math.atan2(forward.y, forward.x) * 180) / Math.PI + 90;
				 return false;
			 }
			  
		}*/
		
		public function routePoint(curIndex:int):Boolean
		{
			  
			if (curIndex >= route.length) return false;
			var point:Vector3 = route[curIndex];
			 Vector3.subtract(point, pos, forward);
			 Vector3.normalize(forward,forward);
			 Vector3.scale(forward, speed, velocity);  
			 Vector3.add(velocity, GravityV, velocity); 
			 Vector3.add(pos, velocity, pos);   
			  var dis:Number = Vector3.distance(point, pos);
			 if (dis < speed *0.5)
			 { 
				 return true;
			 }else{ 
				 GameAni.pos(pos.x- (136 * scale)/2, pos.y- (153 * scale)); 
				 return false;
			 }
			  
		}
		public function Jump():void
		{
			speed = speed * 2;
			 gravity = 2;
			 GravityV = new Vector3(0,gravity,0);
		}
		public function GameOver():void
		{
			IsOver = true;
		}
		public function Rotate(angle:Number):void
        {
			//roleAni.rotation = ExQuaternion(roleAni.rotation,angle,t);
			GameAni.rotation = angle;
		}
		
		 public function PlayAction(aniName:String,loop:Boolean):Boolean
        {
			//创建动画模板dizziness
			if (GameAni != null)
			{
				GameAni.play(0,loop,aniName);
				return true;
			}else 
			{
				return false;
			} 
		}
		 
	}

}