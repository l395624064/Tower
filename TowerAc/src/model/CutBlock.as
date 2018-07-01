package model 
{
	import Mathf.ExQuaternion;
	import control.SceneManager;
	import control.TowerSys;
	import laya.ui.Image;
	import laya.filters.ColorFilter;
	public class CutBlock extends Image
	{
		public var LR:Number =0;
		public var hoffset:Number =0;
		public var g:Number = 0.2;
		public var v:Number = 0;
		public var img:Image;
		public var _widths:Number;
		public var sidePath:String = "ui/main/blockside.png"; 
		public var unitPath:String = "ui/main/";
		public function CutBlock() 
		{
			img = new Image();
			this.addChild(img);
			img.pos(0,0);
		}
		public function CutByWith(x:Number,_width:Number,_LR:Number,pathIndex:int):Image
		{
			LR = _LR;
			 _widths = _width;
			 for (var i:int = 0; i < _width; i++)
			 { 
				var side:Image = new Image();
				if (pathIndex == 3)
				side.loadImage(unitPath + pathIndex + ".2" + "bg.png"); 
				else 
				side.loadImage(unitPath + pathIndex + "bg.png"); 
				
				if (pathIndex == 1||pathIndex == 2)
				side.scale(2, 0.25, true); 
				else 
				side.scale(1, 0.25, true); 
				side.pivotX = side.width / 2, side.pivotY = side.height / 2;
				side.pos(i,0);
				img.addChild(side); 
			 }
			 
			  this.x = x;
			  return img;
			  
		}
		
		 
		///被切时的高度
		public function VOffset(bot:Number):void
		{
			hoffset = bot - this.y;
		}
		///受重力影响时的动作
		public function Gravity(bot:Number):void
		{ 
			 v += g;
			 this.y += v;   
			 var t:Number=(bot - this.y) / hoffset;
			 img.filters = [AlphaFilter(t)];
			 if (LR > 0)
			 { 
				img.rotation = ExQuaternion.Lerp(0, 180, 1 - t); 
			 } 
			 else { 
				img.rotation = ExQuaternion.Lerp(360, 180, 1 - t); 
			 } 
			 if (this.y > bot)
			 {
				 if (this.parent != null)
				 {
					 this.parent.removeChild(this);
					 TowerSys.Instance.CutBlocks.splice(TowerSys.Instance.CutBlocks.indexOf(this),1);
				 }
				 
			 }
		}
		
		private function AlphaFilter(t:Number):ColorFilter
		{
			//由 20 个项目（排列成 4 x 5 矩阵）组成的数组，透明图
			var alphascaleMat:Array = [
				1, 0, 0, 0, 0, 
				0, 1, 0, 0, 0, 
				0, 0, 1, 0, 0, 
				0, 0, 0, t, 0];
			
			//创建一个颜色滤镜对象，透明图
			var alphascaleFilter: ColorFilter = new ColorFilter(alphascaleMat);
			return alphascaleFilter; 
		} 
	}

}