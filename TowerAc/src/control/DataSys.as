package control 
{
	/**
	 * ...
	 * @author ...
	 */
	public class DataSys 
	{
		 
		public  var serverSystem:Object;//S端返回的配置信息
		public function DataSys(){}
		 
		private static var  _instance:DataSys;  
		 
 
		public static function get Instance():DataSys 
		{
			if(_instance==null)
			{ 
			  _instance=new DataSys();
			} 
			return _instance; 
		} 
		
		public function DataSys() 
		{
			Init();
		}
		
		///初始化
		public function Init():void{
			
			 
		}
		///完美搭建
		public var perfect:Number = 0;
		///分数
		public var score:Number = 0;
		//复活币
		public var lifegold:Number = 90; 
		
		public function SetScore(value:int):Boolean{
			score = value;
			GameControl.Instance.uiview.UpdateScore(score);
		}
		public function UseLifeGold():Boolean{
			if (lifegold > 0)
			{
				lifegold -= 1;
				GameControl.Instance.uiview.UpdateLifeGold(lifegold);
				return true;
			}
			return false;
		}
		public function AddLifeGold(value:int):void{
			 
				lifegold += value;
				GameControl.Instance.uiview.UpdateLifeGold(lifegold); 
		}
		
		public function PlayGlobalMusic():void{
			 
				SoundManager.playMusic("res/sound/background.mp3", 0, null);
		}
		 
	}

}