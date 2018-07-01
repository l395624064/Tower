package 
{
	import control.DataSys;
	import laya.display.Sprite;
	import laya.resource.Texture;
	import laya.wx.mini.MiniAdpter;
	import laya.utils.Browser;
	import laya.net.ResourceVersion;
	import laya.utils.Handler;
	
	/**
	 * 主域接口
	 * 微信SDK1.02.1804251
	 * laya 1.7.17(引擎存在bug,需要手动修改部分文件)
	 * ————请在laya.init()前，填写MiniAdpter.init(true);
	 * ————需要将主域编译后的game.json 中添加子域目录："openDataContext": "src/myOpenDataContext",
	 * ————laya初始化时要开启WebGL
	 * ————无需WX_Tool类
	 * ————不要使用this来指向内部属性！！
	 * ————(PS:在类库文件为laya.resource.Texture)编译后的code.js类中找到var Texture关键字，可以找到bitmap._addReference关键字，需要修改为if(bitmap&& bitmap._addReference)
	 * @author ...
	 */
	public class WX_main 
	{
		public var reliveNum:int;//从服务器获取的复活币 
		
		private var postMsg:Object = __JS__('wx.postMessage');
		private var _rankMsg:Object;//子域rank信息
		private var ranksp:Sprite;//排行榜sp
		public var playerMsg:Object;//当前用户msg   shareTick//nickName//opid
		private var shareTick:String;//群分享卡片shareTicket
		private var sysTemMsg:Object;//手机系统信息
		
		public  var mycallfunc:Function;//返回给view参数
		public  var serverSystem:Object;//S端返回的配置信息
		private var gameID:int;//游戏ID
		
		
		public function WX_main() 
		{
			
		}
		
		/**
		 * 请在laya初始化后调用
		 * @param   _rankMsg:object={stageW,stageH,rankX,rankY,rankW,rankH} //目前laya版本子域矩阵转换,缩放会存在问题,请使用定值
		 * @param	_arr:资源列表
		 * @version _version:资源版本控制文件，默认为"version.json"
		 */
		public function init(_gameID:int,_rank:Object,_arr:Array=[],_version:String="version.json"):void
		{
			trace("JY1.7:");
			altsArr = _arr;
			_rankMsg = _rank;
			showShareMenu();//初始化withShareTicket=true
			
			this.gameID = _gameID;//获取游戏ID
			
			//激活资源版本控制
             ResourceVersion.enable(_version, Handler.create(this, overLoadAlts), ResourceVersion.FILENAME_VERSION);
			//overLoadAlts();
			login();//login
			
			//转发信息监听
			var listenAppshare:Object = __JS__('wx.onShareAppMessage');
			listenAppshare(this.listenShare);
			
			//检测新玩家onshow获取启动参数
			var onshow:Object = __JS__('wx.onShow');
			onshow(this.newShareplayer);//onshow方式获取
			
			getLaunchOptionsSync();//getLaunchOptionsSync方式获取
			
			//老玩家进去游戏前10S通过分享获取的复活币
			Laya.timer.loop(1000, this, checkPrent);
		}
		
		/**
		 * 返回小程序时的启动参数
		 */
		private function getLaunchOptionsSync():void
		{
			var launchOption:Object = __JS__('wx.getLaunchOptionsSync()');
			//trace("launchOption:",launchOption);
		}
		
		/**
		 * 监听小游戏回到前台的事件
		 * @param	res
		 */
		private function newShareplayer(res):Object
		{
			//trace("——onshow:", res);
			trace("————通过转发卡片进入",res.shareTicket);
			shareTick = res.shareTick;
			return res;
		}
		
		/**
		 * 获取当前手机系统信息
		 */
		private function getSystemInfo():void
		{
			var getSystemInfo:Object = __JS__('wx.getSystemInfo');
			getSystemInfo({
				success:function(res){
					trace("当前手机信息获取成功");
					sysTemMsg = res;
				},
				fail:function(){
					trace("当前手机系统信息获取失败");
				}
			});
		}
		
		
		public function newPlayerTest():void
		{
			//_ifCard = true;
			_ifPrent = true;
			Laya.timer.once(2000, this, onCheckgold);
		}
		
		private function onCheckgold():void
		{
			trace("当前玩家获取奖励————:",reliveNum);
		}
		
		
		private var _ifCard:Boolean;
		private var _ifPrent:Boolean;
		private var _timeIndex:int;//time次数
		private function checkPrent():void
		{
			if (playerMsg && playerMsg.opid){
				if (shareTick!=""&&_ifCard){
					var data:Object = {
						"game_id":playerMsg.nickName,
						"open_id":playerMsg.opid,
						"share_ticket":playerMsg.shareTick
					};
					//通过卡片分享进入游戏的玩家——
					request("playerToCard", "https://api.wxyoule.com/api/v1/joinshareticket", data);
				}
				if (_ifPrent){
					var msg:Object = {
						"game_id":playerMsg.nickName,
						"open_id":playerMsg.opid
					};
					//通过转发分享获得奖励的玩家——
					request("groupPrent", "https://api.wxyoule.com/api/v1/getrelive", msg);
				}
			}
			
			_timeIndex++;
			if (_timeIndex>20||_ifCard||_ifPrent){
				Laya.timer.clear(this, checkPrent);
			}
		}
		
		
		
		/**
		 * 网络请求
		 * @param	_url地址
		 * @param   _data请求的参数
		 * @param	_method:GET//HEAD//POST//PUT//DELETE//TRACE//CONNECT
		 * @return string类型——开发者服务器返回的数据
		 */
		private  function request(_type:String,_url:String,_data:*,_method:String="POST"):void
		{
			var req:Object = __JS__('wx.request');
			//_data = JSON.stringify(_data);
			//trace("request.data::",_data);
			req({
				url:_url,
				data:_data,
				method:_method,
				success:function(res){
					trace("获取S端信息:",res);
					if (_type == "opid"){
						playerMsg.opid = res.data.data.openId;//记录opid
						trace("opid———",playerMsg.opid);
					}
					else if (_type == "playerToCard"){
						trace("playerToCard——");
						_ifCard = true;
					}
					else if (_type == "groupPrent"){
						_ifPrent = true;
						reliveNum = res['data']['data']['relive'];
						trace("groupPrent——",reliveNum);
					}
					else if (_type == "groupRank"){
						trace("groupRank———————",res.shareTickets);
						postMsgTo("group");//发送给子域:获取群组成员 rankview
					}
					else if (_type=="systemInfo"){
						serverSystem = res;
						DataSys.Instance.serverSystem = res;///////////////////////////////////////////////
						trace("获取游戏配置——————", serverSystem);
						trace("res——————", res);
						//WX_main.mycallfunc(res);
					}
				}
			});
		}
		
		/**
		 * 转发信息主体
		 * @return 
		 * {
		 * title:string//转发标题，
		 * imageUrl:string//转发显示图片的链接，可以是网络图片路径或本地图片文件路径或相对代码包根目录的图片文件路径。
		 * query:string//查询字符串，必须是 key1=val1&key2=val2 的格式。从这条转发消息进入后，可通过 wx.onLaunch() 或 wx.onShow 获取启动参数中的 query
		 * }
		 */
		private function listenShare(res):Object
		{
			trace("转发信息123——",res);
			return {
				title: '被动转发',
				imageUrl:'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3612345154,1744882367&fm=27&gp=0.jpg',
				success:function(res){
					trace("获取转发shareTicket：", res.shareTickets);
					shareTick = res.shareTickets[0];
				}
			};
		}
		
		/**
		 * 转发至群组成功后会获取shareTick
		 * @param	_url
		 * @param	_ifrequest
		 * @param	_data
		 */
		public function shareAppMessage(_url:String="",_addrank:Boolean=false,_ifrequest:Boolean=false,_data:Object=null):void
		{
			//updateShareMenu();//修改转发属性,2.0版以后,默认修改不可用，必须每次修改
			
			//2.0版本库会禁止获取shareTickets
			var shareMsg:Object = __JS__('wx.shareAppMessage');
			shareMsg({
				title: '主动转发',
				imageUrl:_url,
				success:function(res){
					playerMsg.shareTick = res.shareTickets[0];
					//trace("获取转发shareTicket：", playerMsg.shareTick);
					if (!_ifrequest&&playerMsg&&playerMsg.shareTick){
						return;
					}
					
					var data:Object = {
						"game_id":playerMsg.nickName,
						"open_id":playerMsg.opid,
						"share_ticket":playerMsg.shareTick
					};
					if(_addrank){
						request("groupRank", "https://api.wxyoule.com/api/v1/addshareticket", data);//只转发不调用群排行
					}
				},
				fail:function(res){
					trace("获取分享未成功", res);
				}
			});
		}
		
		/**
		 * 修改转发属性
		 */
		private function updateShareMenu(_tick:Boolean=true):void
		{
			var updateShareMenu:Object = __JS__('wx.updateShareMenu');
			updateShareMenu({
				withShareTicket:_tick,
				success:function(res){
					trace("转发属性修改成功",res);
				}
			})
		}
		
		/**
		 * set当前用户存档至云，必须set过的用户信息才能get
		 * @param	_score:如果为-1,则为随机值
		 */
		public function setUserInfo(_score:int=-1):void
		{
			if (_score<0){
				var num:int = Math.floor(Math.random() * 100);
			}
			var _msg:Array = [{
				key:"score",
				value:String(num)
			}];
			setUserCloudStorage(_msg);//存储用户信息
		}
		 
		/**
		 * 游戏结束之后存储至本地缓存
		 * ————上传至微信云端
		 * —————本地存储
		 * @param	_obj:{"score":int,"lifeGold":int}
		 * @param	_storageKey:本地key
		 */
		public function setStorage(_obj:Object,_storageKey:String="usersInfo"):void
		{
			var setStorage:Object = __JS__("wx.setStorage");
			setStorage({
				key:_storageKey,
				data:_obj,
				success:function(){
					trace("————本地存档建立成功",_obj);
				},
				fail:function(){
					trace("—————本地存档建立失败");
				}
			});
		}
		
		/**
		 * 异步版本：游戏开始前获取本地存储信息
		 * @param	_callBack:回调参数
		 * @param	_storageKey
		 */
		public function getStorage(_callBack:Function,_storageKey:String="usersInfo"):Object
		{
			var getStorage:Object = __JS__("wx.getStorage");
			getStorage({
				key:_storageKey,
				success:function(res){
					trace("————获取本地存储信息",res.data);
					_callBack(res.data);
				},
				fail:function(){
					trace("—————本地存储未获取成功");
					_callBack(null);
				}
			});
		}
		
		/**
		 * wx.getStorage 的同步版本
		 * @param	_storageKey
		 * @return
		 */
		public function getStorageSync(_storageKey:String="usersInfo"):Object
		{
			var getStorageSync:Object = __JS__("wx.getStorageSync");
			getStorageSync({
				key:_storageKey,
				success:function(res){
					trace("————获取本地存储信息");
					return res;
				},
				fail:function(){
					trace("—————本地存储未获取成功");
					return null;
				}
			});
		}
		
		
		/**
		 * 向子域发送消息：
		 * @param	_str:string="self","friend","group","close" 个人,好友,群组,关闭
		 */
		public function postMsgTo(_str:String,_obj:Object=null):void
		{
			//发送给子域
			var msg:Object = {};
			if (_obj){
				msg = _obj;
				//重置主域的sharedcanvas尺寸
				Browser.window.sharedCanvas.x = _obj.rankX;
				Browser.window.sharedCanvas.y = _obj.rankY;
				Browser.window.sharedCanvas.width = _obj.rankW;
				Browser.window.sharedCanvas.height = _obj.rankH;
			}
			else{
				msg.type = _str;//群组信息榜
			}
			
			switch (_str) 
			{
				case "initRank"://初始化子域舞台
				break;
				case "self"://个人信息榜
				break;
				case "friend"://好友信息榜
				break;
				case "group":msg._shareTickets = playerMsg.shareTick;
				break;
				case "groupCard":msg._shareTickets = playerMsg.shareTick;
				break;
				case "selfscore"://个人信息
				break;
				case "close"://关闭信息
				break;
				default:trace("——发给子域信息type未设置——");
			}
			trace("————————向子域发送信息:", msg);
			postMsg(msg);
			Laya.stage.addChild(ranksp);
			
			if (_str == "close"){
				ranksp.removeSelf();
			}
			
		}
		
		
		/**
		 * 显示当前页面的转发按钮
		 * @param _ifTicket:使用带 shareTicket 的转发 默认为true
		 */
		public function showShareMenu(_ifTicket:Boolean):void
		{
			var showShare:Object = __JS__('wx.showShareMenu');
			showShare({
				withShareTicket:true,
				success:function(res){
					//显示分享菜单：res;
				},
				fail:function(){
					//分享菜单调用失败
				}
			});
		}
		
		public function hideShareMenu():void
		{
			var hideShare:Object = __JS__('wx.hideShareMenu');
			hideShare({
				success:function(){
					trace("隐藏分享菜单");
				}
			});
		}
		
		
		public function toTempFilePath():void
		{
			//先获取主域的sharedCanvas三种方式:主域请尽量使用Browser.window.sharedCanvas获取
			//var canvas2:*= Browser.window.sharedCanvas;
			//var canvas5:*= MiniAdpter.window.sharedCanvas;
			//__JS__('sharedCanvas');
			var canvas:*= Browser.window.sharedCanvas;
			trace("canvas:",canvas);
			
			//存储至微信缓存
			var toFilePath:Object = __JS__('canvas.toTempFilePath');
			var shareMsg:Object = __JS__('wx.shareAppMessage');
			toFilePath({
				x:0,
				y:0,
				width:500,
				height:500,
				destWidth:500,
				destHeight:500,
				success:function(res){
					trace("本地图片缓存地址res.tempFilePath:", res);
					shareAppMessage(res.tempFilePath);
					//主动拉取分享弹窗
				},
				fail:function(res){
					trace("本地图片缓存地址获取失败");
				}
			});
		}
		
		/**
		 * Canvas.toTempFilePath 的同步版本
		 */
		public function toTempFilePathSync():void
		{
			var canvas:*= Browser.window.sharedCanvas;
			trace("canvas:", canvas);
			var toTempFilePath:Object = __JS__('canvas.toTempFilePathSync');
			var path:*= toTempFilePath({
				x:0,
				y:0,
				width:400,
				height:400,
				destWidth:400,
				destHeight:300,
				success:function(res){
					trace("本地图片缓存地址Path:", res.tempFilePath);
					return res.tempFilePath;
				},
				fail:function(){
					trace("本地图片缓存地址获取失败");
				}
			});
		}
		
		
		/**
		 * 使用HTMLCanvas节点绘制纹理
		 */
		private function creatTexture():void
		{
			var icoImg:Sprite = new Sprite();
			var htmlC:HTMLCanvas = icoImg.drawToCanvas(400, 400, 0, 0);//此处将canvas指定区域进行截屏
			var _texture:Texture = new Texture(htmlC);//获取截屏区域的texture
			var sp2:Sprite = new Sprite();//将截屏的texture进行draw绘制并显示到舞台
			sp2.x = 300;
			sp2.graphics.drawTexture(_texture,0,0,100,100);
			Laya.stage.addChild(sp2);
		}
		
		/**
		 * 对用户托管数据进行写数据操作，允许同时写多组 KV 数据
		 * 主域和数据域可用
		 * @param	_keyArr:Array.<KVData>
		 */
		private  function setUserCloudStorage(_keyArr:Array):void
		{
			var setMsg:Object = __JS__('wx.setUserCloudStorage');
			setMsg({
				KVDataList:_keyArr,
				success:function(res){
					//设置成功
					trace("setUserCloudStorage设置成功:");
				},
				fail:function(res){
					trace("setUserCloudStorage设置失败");
				}
			});
		}
		/**
		 * 对用户托管数据进行写数据操作，允许同时写多组 KV 数据
		 * 主域和数据域可用
		 * @param	_keyArr:Array.<KVData>
		 */
		private  function setUserCloudStorage(_keyArr:Array):void
		{
			var setMsg:Object = __JS__('wx.setUserCloudStorage');
			setMsg({
				KVDataList:_keyArr,
				success:function(res){
					//设置成功
					trace("setUserCloudStorage设置成功:");
				},
				fail:function(res){
					trace("setUserCloudStorage设置失败");
				}
			});
		}
		
		/**
		 * 获取登录凭证
		 * 使用（code）后台调用code2accessToken换取用户登录态信息，包括用户的唯一标识（openid） 及本次登录的 会话密钥（session_key）等。
		 * 用户数据的加解密通讯需要依赖会话密钥完成。
		 * @return 返回res.code
		 */
		private function login():void
		{
			var data:Object = new Object();
			var log:Object = __JS__('wx.login');
			log({
				success:function(res){
					trace("login——");
					data.code = res.code;
					var getMsg:Object = __JS__('wx.getUserInfo');
					getMsg({
						success:function(e){
							playerMsg = JSON.parse(e.rawData);//记录玩家信息
							trace("playerMsg::",playerMsg);
							//玩家信息获取：：playerMsg;
							data.encryptedData = e.encryptedData;
							data.iv = e.iv;
							data.rawData = e.rawData;
							data.signature = e.signature;
							request("opid", "https://api.wxyoule.com/api/v1/wxlogin?game_id=1", data);//向服务器发送信息记录openid
							request("systemInfo", "https://api.wxyoule.com/api/v1/getconfig", {"game_id":gameID});
							trace("gameID"+gameID);
						}
					})
				},
				fail:function(){
					//获取登录失败
				}
			})
		}
		
		
		/**
		 * 长震动400 ms
		 */
		public  function vibrateLong():void
		{
			var short:Object = __JS__('wx.vibrateLong');
			short({
				success:function(){
					//onSuccess()
				},
				fail:function(){
					//onFail()
				},
				complete:function(){
					//onComplete()
				}
			});
		}
		
		/**
		 * 短震动15 ms
		 */
		public  function vibrateShort():void
		{
			var short:Object = __JS__('wx.vibrateShort');
			short({
				success:function(){
					//onSuccess()
				},
				fail:function(){
					//onFail()
				},
				complete:function(){
					//onComplete()
				}
			});
		}
		
		/**
		 * 预览图片
		 * @param	_urls：Array.<string>
		 */
		 
		public function previewImage(callBack:Function,_urls:Array):void
		{
			var previewImage:Object = __JS__("wx.previewImage");
			previewImage({
				urls:_urls,
				success:function(){
					trace("——————预览图片");
					if (callBack != null)
					 callBack();
				},
				fail:function(){
					trace("——————预览图片失败");
				}
				
			});
		}
		
		
		
		
		private var altsArr:Array = [];
		private function overLoadAlts():void
		{
			//trace("激活资源版本控制");
			Laya.loader.load(altsArr, new Handler(this, loaderComplete));
			
			ranksp = new Sprite();
			ranksp.pos(_rankMsg.rankX, _rankMsg.rankY);
			ranksp.size(_rankMsg.rankW, _rankMsg.rankH);
			
			
			//初始化sharedCanvas
			MiniAdpter.window.sharedCanvas.windth = Laya.stage.width;
			MiniAdpter.window.sharedCanvas.height = Laya.stage.height;
			
			//将纹理绘制到ranksp
			if (Browser.onMiniGame){
				var rankTexture:Texture = new Texture(Browser.window.sharedCanvas);
				//rankTexture.bitmap.alwaysChange = true;//cpu消耗中高,测试用
				ranksp.graphics.drawTexture(rankTexture, 1, 1, _rankMsg.rankW, _rankMsg.rankH);
			}
		}
		private function loaderComplete():void
		{
			trace("美术资源加载完成");
		}
		
		
		public function setcallback(_func:Function):void
		{
			mycallfunc = _func;
		}
		
		//public function set setbackFunc(_func:Function):void
		//{
			//this.mycallfunc = _func;
		//}
		//public function get sendFunc(res):void{
			//return mycallfunc;
		//}
	}

}