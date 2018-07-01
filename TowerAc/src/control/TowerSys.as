package control {
    
	 
	import Vector;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector2;
	import laya.ui.Image;
    import laya.utils.Timer;
    import laya.utils.Dictionary; 
	import model.Block;
	import model.CutBlock;
	import model.CutResult;
	import model.Layer;
	import model.Side;
    public class TowerSys 
    {
		public var cutResult:Vector.<CutResult>;
		public var CutBlocks:Vector.<CutBlock>;
		public var LayerTemplates:Vector.<Layer>; 
		public var layerPath:String="res/atlas/ui/main/main1.";
        public var blocks:Array;
		 public var curBlock:Block;
		  public var lastBlock:Block;
        private static var  _instance:TowerSys;  
		public function TowerSys() 
		{
			  Init();
		} 
 
		public static function get Instance():TowerSys 
		{
			if(_instance==null)
			{ 
			  _instance=new TowerSys();
			} 
			return _instance; 
		} 

		public function Init():void{
			 blocks = new  Array(); 
			 LayerTemplates = new Vector.<Layer>();
			 
			 CutBlocks = new Vector.<CutBlock>();
			 cutResult=new Vector.<CutResult>();
		}
        
		public function GenerateBlock(_width:Number,index:Number):Block
        {
			var _block:Block;
			if (blocks.length > 0)
			{
				_block = blocks.shift();
				_block.ClearBlock();
				 
			}
			if (_width > 0)
			{
				var _block1:Block = new Block(_width,index);
				_block1.LoadImage();
				blocks.push(_block1); 
				return _block1; 
			}else{
				return null; 
			}
			 
        } 
		public function ClearBlock():Block
        {
			var _block:Block;
			while (blocks.length > 0)
			{
				_block = blocks.shift();
				_block.ClearBlock();
				 
			}
			curBlock = null; 
        } 
		/*
		public function GenerateBlock(_width:Number):Block
        { 
			curBlock = new Block(_width:Number);
			curBlock.LoadImage(); 
            return curBlock; 
        }*/
		public function GetLayer(layerIndex:Number):Image{
			
			var layer:Image = new Image();
			layer.loadImage(layerPath + layerIndex + ".png");
			return layer;
		}
		public function TowerDrop(bot:Number):void{
			
			for (var i:int = 0; i < CutBlocks.length; i++ )
			{
				CutBlocks[i].Gravity(bot);
			}
			if(lastBlock!=null)
			lastBlock.Gravity(bot);
		}
		
		public function StoreCut(cut:CutResult):void{
			
			if (cutResult.length > 0)
			{
				cutResult.pop();
			}
			cutResult.push(cut);
			
		}
    }
}
