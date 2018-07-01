package control 
{
	import Animation.AtlasAni;
	import laya.d3.math.Vector3;
	import laya.utils.Tween;
	
		var Stage   = Laya.Stage;
	var Text    = Laya.Text;
	var Browser = Laya.Browser;
	var WebGL   = Laya.WebGL;
	/**
	 * ...
	 * @author ...
	 */
	public class AniSys 
	{
		public var role:AtlasAni; 
		public function AniSys(){}
		 
		private static var  _instance:AniSys;  
		 
 
		public static function get Instance():AniSys 
		{
			if(_instance==null)
			{ 
			  _instance=new AniSys();
			} 
			return _instance; 
		} 
		///初始化
		public function Init():void{
			 
			 role = new AtlasAni(SceneManager.Instance.near); 
			 Start();
			 Laya.timer.frameLoop(1, this, animateFrameRateBased);
		}
		 
		public function animateFrameRateBased():void
		{
			if(role!=null)
			 role.Move();
		}
		///重新开始
		public function Start():void{ 
			 role.Start();   
			 role.PlayAction("stand", true);  
			 
		}
		public function Relive(spawn:Vector3):void{
			 role.Relive();
			role.SetPos(spawn);  
			 
		}
		public function FirstPos():void{
			 
			 role.SetPos(role.FirstPos());  
		}
		///结束游戏
		public function Over(left:Boolean):void{
			 
			 if (left == true)
			 {
				//  role.Rotate();
			 }
			 role.Jump();
			 role.GameOver();
			 //role.Play("stand", 1, false);
			 
			// Tween.to(role.roleAni, {  y : role.roleAni.y-100}, 1000, Ease.expoOut);
		}
		
		public function Down():void{
			 
			  
			// role.Play("stand", 1, false);
			 
			// Tween.to(role.roleAni, {  y : 1500}, 20000, Ease.expoOut);
		}
		
		public function Clear():void{
			Laya.timer.clear(this,animateFrameRateBased);
		}
	}

}