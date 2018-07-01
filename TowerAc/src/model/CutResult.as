package model 
{
	import laya.d3.math.Vector3;
	public class CutResult 
	{
		public var pathIndex:int;
		public var DropBlock:Vector3;
		public var NextBlock:Vector3;
		public function CutResult() 
		{
			DropBlock = new Vector3();
			NextBlock = new Vector3();
		}
		
	}

}