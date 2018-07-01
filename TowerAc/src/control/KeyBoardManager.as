package control {
	 
	import laya.display.Sprite; 
	public class KeyBoardManager  
	{
		var Event   = Laya.Event;
        var logger, keyDownList;
		var curX:Number;
        private static var  _instance:KeyBoardManager;   
        public function KeyBoardManager() 
		{ 
		} 
       
        public static function get Instance():KeyBoardManager 
        {
            if(_instance==null)
            { 
                _instance=new KeyBoardManager();
            } 
                return _instance; 
        } 
        public function Init():void
        {
                setup(); 
        }
        public function setup():void
        {
            listenKeyboard(); 
          
        }

        function listenKeyboard()
        {
            keyDownList = [];

            //添加键盘按下事件,一直按着某按键则会不断触发
            Laya.stage.on(Event.KEY_DOWN, this, onKeyDown);
            //添加键盘抬起事件
            Laya.stage.on(Event.KEY_UP, this, onKeyUp);
        }

        /**键盘按下处理*/
        function onKeyDown(e)
        {
            
           
        }

        /**键盘抬起处理*/
        function onKeyUp(e)
        {
           
        }

       
    }
	 
	 
}