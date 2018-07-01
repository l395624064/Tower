package 
{
	import laya.display.Text;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.ui.Image;
	import laya.ui.Panel;
	import laya.wx.mini.MiniAdpter;
	import laya.display.Sprite;
	import laya.utils.Browser;
	import laya.events.Event;
	/**
	 * 请在laya.init()之前 添加 MiniAdpter.init(true,true);一参为主域,二参为开放数据域
	 * @author ...
	 */
	public class WX_Tool 
	{
		public static var userMsg:Object=new Object();//用户当前详细信息,score属性为当前用户最新分数
		public static var itemArr:Array = [];//信息数组：接收close事件后 注销
		public static var friendMsg:Array = [];//微信好友信息——好友排行榜调用
		public static var groupMsg:Array = [];//微信群信息——群排行榜调用
		
		public function WX_Tool() 
		{
			
		}
		
		
		
		
		/**
		 * 获取登录凭证
		 * 使用（code）后台调用code2accessToken换取用户登录态信息，包括用户的唯一标识（openid） 及本次登录的 会话密钥（session_key）等。
		 * 用户数据的加解密通讯需要依赖会话密钥完成。
		 * @return 返回res.code
		 */
		public static function login():String
		{
			var log:Object = __JS__('wx.login');
			log({
				success:function(res){
					trace("login:",res);
					return res.code;//需要在开发者服务器后台调用 code2accessToken，使用 code 换取 openid 和 session_key 等信息
				},
				fail:function(){
					return null;
				}
			})
		}
		
		
		
		
		/**
		 * 提前发起授权。
		 * 调用后会立刻弹窗询问用户是否同意授权小程序使用某项功能或获取用户的某些数据，但不会实际调用对应接口。
		 * 如果用户之前已经同意授权，则不会出现弹窗，直接返回成功。
		 * @param	_scope scope.userInfo:用户信息;scope.userLocation:地理位置;scope.werun:微信运动步数;scope.record:录音功能;scope.writePhotosAlbum:保存到相册
		 */
		public static function authorize(_scope:String):void
		{
			var getAuth:Object = __JS__('wx.authorize');
			getAuth({
				scope:_scope,
				fail:function(res){
					if (res.errMsg.indexOf('auth deny') > -1 || res.errMsg.indexOf('auth denied') > -1){
						//处理用户拒绝授权的情况
					}
				}
			})
		}
		
		/**
		 * 获取用户某个scope授权信息
		 * @param	_scope  scope.userInfo:用户信息;scope.userLocation:地理位置;scope.werun:微信运动步数;scope.record:录音功能;scope.writePhotosAlbum:保存到相册
		 * @return
		 */
		public static function getSetting(_scope:String):Boolean
		{
			var getSet:Object = __JS__('wx.getSetting');
			getSet({
				success:function(res){
					var auth:*= res.authSetting
					return auth[_scope];
				}
			});
		}
		
		/**
		 * 在无须用户授权的情况下，批量获取用户信息。
		 * 该接口只在开放数据域下可用
		 * @param	_openId:要获取信息的用户的 openId 数组
		 * @return 返回objArray 
		 * 
		 * res.data 的结构:
		 * avatarUrl:string//头像url
		 * city:string//城市
		 * country:string//国家
		 * gender:number//性别
		 * language:string//语言
		 * nickName:string//用户昵称
		 * openId:string//openId
		 * province:string//省份
		 */
		public static function getUserInfo(_openId:Array=["selfOpenId"]):Array
		{
			var getMsg:Object = __JS__('wx.getUserInfo');
			getMsg({
				openIdList:_openId,
				lang: 'zh_CN',
				success:function(res){
					trace("getUserInfo:", res.data);
					//将个人用户信息存储至userobj
					WX_Tool.userMsg = res.data;
					return res.data;
				},
				fail:function(res){
					return null;
				}
			});
		}
		
		/**
		 * 长震动400 ms
		 */
		public static function vibrateLong():void
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
		public static function vibrateShort():void
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
		 * ————rankviewMsg数据结构
		 * {"type":"initRank",
		 * 	"stageW":Laya.stage.width,"stageH":Laya.stage.height,
			"rankX":0,"rankY":0,"rankW":610,"rankH":750,
			"rankNumX":15,"soldW":600,"soldH":100,
			"icoW":80,"icoH":80,
			"scoreX":470,
			"icoX":100,
			"nameX":200,
			"fontsize":40,"pix":30
			};
		 */
		public static var rankviewMsg:Object;
		public static var canvasImg:Sprite = new Sprite();//当前rank画布
		public static var rankPanel:Panel = new Panel();
		/**
		 * 通过主域信息，将sharedCanvas初始化
		 * laya矩阵转换1.7.17存在问题，请使用定值
		 * @param	_obj
		 */
		public static function initStageNum(_obj:Object):void
		{
			//获取rankviewMsg信息
			WX_Tool.rankviewMsg = _obj;
			//强制当前舞台和sharedCanvas同步
			Browser.window.sharedCanvas.width = _obj.stageW;
			Browser.window.sharedCanvas.height = _obj.stageH;
			//Laya.stage.width = Browser.window.sharedCanvas.width;
			//Laya.stage.height = Browser.window.sharedCanvas.height;
			////////////////////////////////////////////////////////////////////////////////////////
			
			//方式2：好友排行榜
			//创建panel
			WX_Tool.rankPanel.pos(0, 0);
			WX_Tool.rankPanel.hScrollBarSkin = "";//水平滚动
			WX_Tool.rankPanel.vScrollBarSkin = "";//垂直滚动
			WX_Tool.rankPanel.size(_obj.rankW, _obj.rankH);
			WX_Tool.rankPanel.graphics.drawRect(0, 0, _obj.rankW, _obj.rankH, "#123456", "#544444", 5);
			//Laya.stage.addChild(WX_Tool.rankPanel);
			WX_Tool.getFriendCloudStorage(new Array("score"));
		}
		
		
		
		/**
		 * 好友数组排序
		 * @param	_arr
		 * @return
		 */
		public static function sortArr(_arr:Array):Array
		{
			//填充数组
			trace("_arr排序前:",_arr);
			//如果不含有kvdate属性则填充
			for (var j:int = 0; j < _arr.length; j++) 
			{
				if (_arr[j]['KVDataList'].length<=0){
					_arr[j]['KVDataList'][0] = {key: "score", value:"0"};
				}
			}
			var resetArr:Vector.<Object> = Copy(_arr);
			var afterArr= WX_Tool.Sort(resetArr);
			trace("_arr排序后:",afterArr);
			//排序后,添加排名 属性——便于单独拿出来时获取当前obj的排名
			for (var i:int = 0; i < afterArr.length; i++) 
			{
				afterArr[i]['rankNum'] = i+1;
			}
			
			return afterArr;
		}
		
		/**
		 * 排序算法
		 * @param	src
		 * @return
		 */
		public static function Copy(src:Array):Vector.<Object>
		{
			var des:Vector.<Object>  = new Vector.<Object>();
			for each(var obj1:Object in src)
			{
				des.push(obj1);
			}
			return des;
		}
		public static function Sort(arr:Vector.<Object>):Array{
			var result:Array = [];
			//trace("arr.length"+arr.length);
			while (arr.length > 0)
			{
				//trace("arr.length"+arr.length);
				result.push(WX_Tool.Min(arr));
			}
			return result;
		}
		public static function Min(arr:Vector.<Object>):Object{
			var min:int = -65534; var minObject:Object;
			//trace("Min" + arr.length);
			//trace("arr" + arr);
			for (var i:int = 0; i < arr.length; i++ )
			{
				if (Number(arr[i]['KVDataList'][0]['value'])> min)
				{
					min = Number(arr[i]['KVDataList'][0]['value']);
					minObject = arr[i];
				}
			} 
			arr.splice(arr.indexOf(minObject), 1);
			return minObject;
		} 
		
		
		
		
		
		
		
		
		
		
		
		
		public static var pageNum:int = 0;//当前page页码
		public static const signNum:int = 6;//默认单页6个 
		/**
		 * 
		 * @param	_control
		 */
		public static function creatListPage(_myArr:Array,_control:String=""):void
		{
			var maxpage:int = Math.ceil(_myArr.length / WX_Tool.signNum);
			
			if (_control=="nextPage" && WX_Tool.pageNum<maxpage){
				WX_Tool.pageNum++;
			}
			else if (_control=="prvePage" && WX_Tool.pageNum>0){
				WX_Tool.pageNum--;
			}
			else if(_control==""){
				WX_Tool.pageNum = 0;
			}
			
			//每次从arr中获取指定区间数组 x x+7
			var myArr:Array = _myArr.slice(WX_Tool.pageNum * 6, WX_Tool.pageNum * 6+7);
			
			//带入至creatlist，创建单页
			WX_Tool.creatItem(myArr);
		}
		
		/**
		 * ————rankviewMsg数据结构
		 * {"type":"initRank",
		 * 	"stageW":Laya.stage.width,"stageH":Laya.stage.height,
			"rankX":0,"rankY":0,"rankW":610,"rankH":750,
			"rankNumX":15,"soldW":600,"soldH":100,
			"icoW":80,"icoH":80,
			"scoreX":470,
			"icoX":100,
			"nameX":200,
			"fontsize":40,"pix":30
			};
		 */
		public static function creatItem(_arr:Array):void
		{
			var colorArr:Array = ["0x001122", "0x111111"];//颜色
			var rectW:int = WX_Tool.rankviewMsg.soldW;//
			var rectH:int = WX_Tool.rankviewMsg.soldH;
			var repairH:int = WX_Tool.rankviewMsg.pix;//repairH >30 较为明显
			var icoW:int = WX_Tool.rankviewMsg.icoW;
			var icoH:int = WX_Tool.rankviewMsg.icoH;
			var fSize:int = WX_Tool.rankviewMsg.fontsize;
			var scoreX:int = WX_Tool.rankviewMsg.scoreX;
			var nameX:int = WX_Tool.rankviewMsg.nameX;
			//var nameX:int = 150;//测试用
			//var scoreX:int = 150;//测试用
			//var icoW:int = 20//测试用
			//var icoH:int = 30//测试用
			//var fSize:int = 30//测试用

			var itemSp:Sprite; 
			var ico:Image;
			var score_txt:Text;
			var name_txt:Text;
			var rankNum:Text;
			for (var i:int = 0; i < _arr.length; i++) 
			{
				var _obj:Object = _arr[i];
				
				//创建单项item sp
				itemSp = new Sprite();
				itemSp.size(rectW, rectH);
				//itemSp.graphics.drawRect(0,0, rectW, rectH, colorArr[i%2]);
				itemSp.pos(0, i * 100 + i * repairH);
				
				//排名
				rankNum = new Text();
				rankNum.text = _obj['rankNum'];//排序后自建属性rankNum
				rankNum.fontSize = fSize;
				rankNum.color = "#fd0400";
				rankNum.pos(0, 0);
				itemSp.addChild(rankNum);
				
				////头像ico
				ico = new Image();
				ico.loadImage(_obj['avatarUrl']);
				ico.size(icoW, icoH);
				ico.pos(50, 0);
				itemSp.addChild(ico);
				
				//分数
				score_txt = new Text();
				if (_obj['KVDataList'].length <= 0){
					score_txt.text = 0;
				}
				else{
					score_txt.text = _obj['KVDataList'][0]['value'];
				}
				score_txt.fontSize = fSize;
				score_txt.color = "#fd0400";
				score_txt.pos(scoreX, 0);
				itemSp.addChild(score_txt);
				
				//名字
				name_txt = new Text();
				name_txt.text = _obj['nickname'];
				trace("_obj['nickname']:",_obj['nickname']);
				name_txt.fontSize = fSize;
				name_txt.color = "#fd0400";
				itemSp.addChild(name_txt);
				name_txt.pos(nameX, 0);
				itemSp.addChild(name_txt);
				
				WX_Tool.itemArr.push(itemSp);//添加入数组，当接收到close事件后，清理
				Laya.stage.addChild(itemSp);//直接添加至舞台显示
			}
			trace("ad0.9");
		}
		
		/**
		 * ————rankviewMsg数据结构
		 * {"type":"initRank",
		 * 	"stageW":Laya.stage.width,"stageH":Laya.stage.height,
		 * "rectW":int,"rectH":int,"repairW":int,
			"itemArr":
			[{
				//ico属性
				icoX:int,
				icoY:int,
				icoW:int,
				icoH:int,
				//ranktxt属性
				rankX:int,
				rankY:int,
				rankSize:int,
				rankColor:uint,
				//nametxt属性
				nameX:int,
				nameY:int,
				nameSize:int,
				nameColor:uint,
				//score属性
				scoreX:int,
				scoreY:int,
				scoreSize:int,
				scoreColor:uint
			}]
			};
		 */
		public static function creatSingleItem(_arr:Array,_data:Object,_ifside:Boolean = false):void
		{
			//将个人用户信息存储至userobj
			//WX_Tool.userMsg = res.data;
			var userName:String = WX_Tool.rankviewMsg["username"];
			var sideArr:Array = [];//存入新数组
			trace("acs1.2",userName,"sideArr:",sideArr);
			
			if (_ifside){
				//创建包含自己在内的三个名片
				sideArr = WX_Tool.findmyselfSid(_arr, userName,false);
			}
			else{
				//仅创建自己的名片
				sideArr[0] = WX_Tool.findmyselfSid(_arr, userName);
			}
			
			var rectW:int = _data['rectW'];
			var rectH:int = _data['rectH'];
			var repairW:int = _data['repairW'];
			var rankNum:Text;
			var ico:Image;
			var score_txt:Text;
			var name_txt:Text;
			for (var i:int = 0; i < sideArr.length; i++) 
			{
				var _obj:Object = _data['itemArr'][i];
				//创建单项item sp
				itemSp = new Sprite();
				itemSp.size(rectW, rectH);
				//itemSp.graphics.drawRect(0,0, rectW, rectH, colorArr[i%2]);
				itemSp.pos(0, i * 100 + i * repairW);
				
				//排名
				rankNum = new Text();
				rankNum.text = sideArr[i]['rankNum'];//排序后自建属性rankNum
				rankNum.fontSize = _obj['rankSize'];
				rankNum.color = _obj['rankColor'];
				rankNum.pos(_obj['rankX'], _obj['rankY']);
				itemSp.addChild(rankNum);
				
				////头像ico
				ico = new Image();
				ico.loadImage(sideArr[i]['avatarUrl']);
				ico.size(_obj['icoW'], _obj['icoH']);
				ico.pos(_obj['icoX'], _obj['icoY']);
				itemSp.addChild(ico);
				
				////分数
				score_txt = new Text();
				if (sideArr[i]['KVDataList'].length <= 0){
					score_txt.text = 0;
				}
				else{
					score_txt.text = sideArr[i]['KVDataList'][0]['value'];
				}
				score_txt.fontSize = _obj['scoreSize'];
				score_txt.color = _obj['scoreColor'];
				score_txt.pos(_obj['scoreX'], _obj['scoreY']);
				itemSp.addChild(score_txt);
				
				//名字
				name_txt = new Text();
				name_txt.text = sideArr[i]['nickname'];
				//trace("_obj['nickname']:",sideArr[i]['nickname']);
				name_txt.fontSize = _obj['nameSize'];
				name_txt.color = _obj['nameColor'];
				itemSp.addChild(name_txt);
				name_txt.pos(_obj['nameX'], _obj['nameY']);
				itemSp.addChild(name_txt);
				
				WX_Tool.itemArr.push(itemSp);//添加入数组，当接收到close事件后，清理
				Laya.stage.addChild(itemSp);//直接添加至舞台显示
			}
		}
		
		/**
		 * 从数组中检测出指定name的数组
		 * @param	_arr:当前检测的arr,一般为friendArr 或者groupArr
		 * @param	_username:指定的nikename,默认为rankviewMsg['username']
		 * @param	_ifsingl:
		 * @return 如果_ifsingl=false 则返回 包含_username及其前后的arrobj
		 * 		   如果_ifsingl=true  则返回 _username的obj
		 */
		public static function findmyselfSid(_arr:Array,_username:String,_ifsingl:Boolean=true):*
		{
			var _sideArr:Array = [];
			for (var i:int = 0; i < _arr.length; i++) 
			{
				if (_arr[i]['nickname'] == _username){
					if (_ifsingl){
						return _arr[i];
					}
					
					else if (i==0){
						_sideArr = _arr.slice(0, 4);
					}
					else{
						_sideArr = _arr.slice(i - 1, 4);
					}
					break;
				}
			}
			return _sideArr;
		}
		//public static function creatlist():void
		//{
			//WX_Tool.clearItemArr();//排序前清理
			////获取rankviewMsg信息
			//WX_Tool.rankviewMsg;
			//
			//
			//
			//
			//
			//
			//var _fsp:Panel = WX_Tool.rankPanel;
			//var sp:Sprite;
			//var ico:Image;
			//var score_txt:Text;
			//var name_txt:Text;
			//var rectW:int, rectH:int, repairH:int;
			//var icoX:Array, icoY:Array, nameX:Array, nameY:Array, scoreX:Array, scoreY:Array, numberX:Array, numberY:Array, fontsize:Array, itemW:Array, itemH:Array, fontcolor:Array;
			//if (WX_Tool.ifselfSide){
				//rectW = 650;
				//rectH = 265;
				//icoX = [120, 342, 565];
				//icoY = [677, 677, 677];
				//nameX = [70, 295, 520];
				//nameY = [782, 782, 782];
				//scoreX = [70, 295, 520];
				//scoreY = [782, 782, 782];
				//numberX = [110, 336, 556];
				//numberY = [623, 623, 623];
				//fontsize = [30, 30, 30];
				//itemW = [80, 176, 176];
				//itemH = [80, 40, 40];
				//fontcolor = ["#ffffff", "#ffffff", "#ffffff"];
				//
				//var userName:String = WX_Tool.rankviewMsg["username"];//截取自己onside的三个对象
				//var sideArr:Array = WX_Tool.findmyselfSid(afterArr, userName);//存入新数组
				//trace("acs1.2",userName,"sideArr:",sideArr);
				//for (var k:int = 0; k < sideArr.length; k++) 
				//{
					//sp = new Sprite();
					//sp.size(195, 270);
					//sp.graphics.drawRect(0,0, 80, 50,"#ff0000");
					//sp.pos(k*10, 0);
					//
					//
					////头像ico
					////ico = new Image();
					////ico.loadImage(sideArr[k]['avatarUrl'], 0, 0, 80, 80);
					////ico.pos(icoX[k], icoY[k]);
					////Laya.stage.addChild(ico);
					////WX_Tool.itemArr.push(ico);//添加入数组，当接收到close事件后，清理
					////分数
					//
					////名字
					//
					//Laya.stage.addChild(sp);
				//}
				//
				//
				//
				//
				//
				//return;
			//}
			//else{
				//rectW:int = 500;
				//rectH:int = 100;
				//repairH:int = 10
				//
				//
			//}
			//
			//
			//
			//
			////var colorArr:Array = ["#001122","#111111"];
			//for (var i:int = 0; i < afterArr.length; i++) 
			//{
				//var _obj:Object = res[i];
				//
				//sp = new Sprite();
				//sp.size(rectW, rectH);
				////sp.graphics.drawRect(0,0, rectW, rectH, colorArr[i % 2]);
				//sp.pos(0, i * repairH);
				//WX_Tool.itemArr.push(sp);//添加入数组，当接收到close事件后，清理
				//
				////头像ico
				//ico = new Image();
				//ico.loadImage(_obj['avatarUrl'], 0, 0, 80, 80);
				//sp.addChild(ico);
				//ico.pos(100, 100*i);
				//
				////分数
				//score_txt = new Text();
				//if (_obj['KVDataList'].length <= 0){
					//score_txt.text = 0;
				//}
				//else{
					//score_txt.text = _obj['KVDataList'][0]['value'];
				//}
				//score_txt.fontSize = 40;
				//score_txt.color = "#fd0400";
				//sp.addChild(score_txt);
				//score_txt.pos(470, 100*i);
				//
				////名字
				//name_txt = new Text();
				//name_txt.text = _obj['nickname'];
				//name_txt.fontSize = 40;
				//name_txt.color = "#141212";
				//sp.addChild(name_txt);
				//name_txt.pos(200, 100*i);
				//
				//trace("创建testlist");
				//_fsp.addChild(sp);
			//}
			//trace("ad0.6");
		//}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public static function onClick():void
		{
			trace("可以在子域制作panel!!!——————————");
		}
		
		
		
		
		/**
		 * 拉取当前用户所有同玩好友的托管数据。
		 * 开放数据域可用
		 * @param	_keyArr:Array.<string> 要拉取的 key 列表
		 * @return  Array.<UserGameData>
		 * avatarUrl:string//头像 url
		 * nickname:string//用户昵称
		 * openid:string
		 * KVDataList:Array.<KVData>//托管KV数据列表 
		 */
		public static function getFriendCloudStorage(_keyArr:Array):void
		{
			var getMsg:Object = __JS__('wx.getFriendCloudStorage');
			getMsg({
				keyList:_keyArr,
				success:function(res){
					trace("getFriendCloudStorage获取成功:", res.data);
					//排序测试
					/*
					var _arr:Array = [
					{KVDataList:[{key: "score", value: "85"}]},
					{KVDataList:[{key: "score", value: "57"}]},
					{KVDataList:[{key: "score", value: "157"}]},
					{KVDataList:[{key: "score", value: "123"}]}
					
					];*/
					WX_Tool.friendMsg = WX_Tool.sortArr(res.data);//好友信息排序后
					WX_Tool.creatListPage(WX_Tool.friendMsg);
					//WX_Tool.creatlist();/////////////////////////////////////////////////////////////////////////////////排序
				},
				fail:function(){
					trace("信息获取失败");
				}
			});
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * ————rankviewMsg数据结构
		 * {"type":"initRank","stageW":Laya.stage.width,"stageH":Laya.stage.height,
			"rankX":0,"rankY":0,"rankW":610,"rankH":750,
			"rankNumX":15,"soldW":600,"soldH":100,
			"icoW":80,"icoH":80,
			"scoreX":470,
			"icoX":100,
			"nameX":200,
			"fontsize":40,"pix":30
			};
		 */
			
		/**
		 * 暂时不用，，，，，
		 * @param	_obj
		 * @param	_index
		 * @param	_skin
		 */ 
		//public static function creatItem(_obj:Object,_index:int,_skin:String):void
		//{
			////当前图片项
			//var Item:Sprite = new Sprite();
			//Item.skin = _skin;
			//WX_Tool.rankPanel.addChild(Item);
			//
			//Item.pos(0, _index * WX_Tool.rankviewMsg.soldH);
			////Item.size(WX_Tool.rankviewMsg.soldW, WX_Tool.rankviewMsg.soldH);
			//
			//WX_Tool.itemArr.push(Item);//添加入数组，当接收到close事件后，清理
			//
			//var ico:Image;
			//var score_txt:Text;
			//var name_txt:Text;
			//for each(var num in _obj) {  
				////头像ICO
				//ico = new Image();
				//ico.loadImage(_obj['avatarUrl'], 0, 0, WX_Tool.rankviewMsg.icoW, WX_Tool.rankviewMsg.icoH);
				//Item.addChild(ico);
				//ico.pos(WX_Tool.rankviewMsg.icoX, (WX_Tool.rankviewMsg.soldH - WX_Tool.rankviewMsg.icoH) / 2);
				//
				////分数
				//score_txt = new Text();
				//if (_obj['KVDataList'].length <= 0){
					//score_txt.text = 0;
				//}
				//else{
					//score_txt.text = _obj['KVDataList'][0]['value'];
				//}
				//score_txt.fontSize = WX_Tool.rankviewMsg.fontsize;
				//score_txt.color = "#fd0400";
				//Item.addChild(score_txt);
				//score_txt.pos(WX_Tool.rankviewMsg.scoreX, 0);
				//
				////名字
				//name_txt = new Text();
				//name_txt.text = _obj['nickname'];
				//name_txt.fontSize = WX_Tool.rankviewMsg.fontsize;
				//name_txt.color = "#141212";
				//Item.addChild(name_txt);
				//name_txt.pos(WX_Tool.rankviewMsg.nameX, WX_Tool.rankviewMsg.pix);
			//}
			//trace("————创建",name_txt.text,"名片");
		//}
		
		
		/**
		 * 每次close事件
		 * 清空item项
		 */
		public static function clearItemArr():void
		{
			for (var i:int=WX_Tool.itemArr.length-1; i >=0 ; i--) 
			{
				var itm:Sprite = WX_Tool.itemArr[i];
				itm.removeSelf();
			}
			WX_Tool.itemArr = [];
		}
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 获取群同玩成员的游戏数据
		 * 开放数据域可用
		 * @param	_shareStr:群分享对应的 shareTicket
		 * @param	_keyArr:要拉取的 key 列表
		 * @return  Array.<UserGameData>
		 */
		public static function getGroupCloudStorage(_shareStr:String,_keyArr:Array=["score"]):Array
		{
			var getMsg:Object = __JS__('wx.getGroupCloudStorage');
			getMsg({
				shareTicket:_shareStr,
				keyList:_keyArr,
				success:function(res){
					trace("获取群成员数组:", res.data);
					WX_Tool.groupMsg = WX_Tool.sortArr(res.data);
					WX_Tool.creatListPage(WX_Tool.groupMsg);
				},
				fail:function(res){
					trace("群资料获取失败：",res);
				}
			});
		}
		
		/**
		 * 获取转发详细信息
		 * @param	_shareTicket:shareTicket
		 */
		public static function getShareInfo(_shareTicket:String):void
		{
			var shareInfo:Object = __JS__('wx.getShareInfo');
			shareInfo({
				shareTicket:_shareTicket,
				success:function(res){
					trace("获取转发详细信息成功：",res);
				},
				fail:function(res){
					trace("获取转发详细信息失败：",res);
				}
			});
		}
		
		
		/**
		 * 获取当前用户托管数据当中对应 key 的数据
		 * 开放数据域下可用
		 * @param	_keyArr:Array.<string> 要获取的 key 列表
		 * @return  Array.<KVData>   {key:string,value:string}
		 */
		public static function getUserCloudStorage(_keyArr:Array):Array
		{
			var getUCMsg:Object = __JS__('wx.getUserCloudStorage');
			getUCMsg({
				keyList:_keyArr,
				success:function(res){
					//trace("获取成功:", res.KVDataList);
					//WX_Tool.userMsg.score = res.KVDataList.value;
					WX_Tool.userMsg['score'] = 182;
					//每次获取成功,则更新至
					return res.KVDataList;
				}
			});
		}
		
		
		
		/**
		 * 网络请求
		 * @param	_url地址
		 * @param   _data请求的参数
		 * @param	_method:GET//HEAD//POST//PUT//DELETE//TRACE//CONNECT
		 * @param   _header
		 * @return string类型——开发者服务器返回的数据
		 */
		public static function request(_url:String,_data:Object=null,_method:String="POST",_header:Object=null):String
		{
			var req:Object = __JS__('wx.request');
			req({
				url:"api.weixin.qq.com/wxa/set_user_storage"+_url,
				data:_data,
				header:{
					'content-type':'game/json'
				},
				method:_method,
				success:function(res){
					return res.data;
				}
			});
		}
		
		
		/**
		 * 上报用户数据后台接口
		 * 小游戏可以通过本接口上报key-value数据到用户的CloudStorage。
		 * @param	_access接口调用凭证
		 * @param	_opid
		 * @param	_appid
		 * @param	_sigNq登录态签名
		 * @param	_sigM哈西方法
		 * @param	_kv上报数据
		 * @return number 0:请求成功 -1:系统繁忙
		 */
		public static function setUserStorage(_kv:Object,_access:String="",_opid:String="",_appid:String="",_sigN:String="",_sigM:String=""):Number
		{
			var setMsg:Object = __JS__('wx.setUserStorage');
			
			if (_access == ""){
				_access=WX_Tool.loginMsg.access_token//默认接口调用凭证
			}
			if (_opid==""){
				_opid=WX_Tool.loginMsg.openid//默认当前用户唯一标识符
			}
			if (_appid==""){
				_appid=WX_Tool.loginMsg.appid//默认当前 appId
			}
			if (_sigN==""){
				_sigN=WX_Tool.loginMsg.signature//默认当前登录态签名
			}
			if (_sigM==""){
				_sigM=WX_Tool.loginMsg.sig_method//默认当前登录态签名的哈希方法
			}
			
			setMsg({
				access_token:_access,
				openid:_opid,
				appid:_appid,
				signature:_sigN,
				sig_method:_sigM,
				kv_list:_kv
			});
		}
		
		
		
		/**
		 * 对用户托管数据进行写数据操作，允许同时写多组 KV 数据
		 * 主域和数据域可用
		 * @param	_keyArr:Array.<KVData>
		 */
		public static function setUserCloudStorage(_keyArr:Array):void
		{
			var setMsg:Object = __JS__('wx.setUserCloudStorage');
			setMsg({
				KVDataList:_keyArr,
				success:function(res){
					//设置成功
					//trace("setUserCloudStorage设置成功:");
				},
				fail:function(res){
					//trace("setUserCloudStorage设置失败");
				}
			});
		}
		
		
		/**
		 * 删除用户托管数据当中对应 key 的数据
		 * 主域和数据域可用
		 * @param	_keyArr
		 */
		public static function removeUserCloudStorage(_keyArr:Array):void
		{
			var removeMsg:Object = __JS__('wx.removeUserCloudStorage');
			removeMsg({
				keyList:_keyArr,
				success:function(){
					//清理成功
				}
			});
		}
		
		
		
		/**
		 * 将群分享的个人卡片绘制出来
		 */
		public static function getGroupCard():void
		{
			WX_Tool.clearItemArr();//先清空laya.stage;
			canvasImg.graphics.drawCircle(100, 100, 100, "#ff8765", "#ff0000", 10);
			canvasImg.size(500, 500);
			Laya.stage.addChild(canvasImg);
			
			canvasImg.graphics.drawCircle(0, 0, 30, "#778899", "#112233", 5);
			
			//测试
			var scoretxt:Text = new Text();
			scoretxt.text = "哈饕嚏哈";
			scoretxt.size = 50;
			scoretxt.color = "#009876";
			canvasImg.addChild(scoretxt);
			
			//头像
			//var icoImg:Image = new Image();
			//trace("WX_Tool.userMsg['avatarUrl']:",WX_Tool.userMsg['avatarUrl']);
			//icoImg.loadImage(WX_Tool.userMsg['avatarUrl'], 0, 0, 50, 50);
			//canvasImg.addChild(icoImg);
			//分数
			var scoreTxt:Text = new Text();
			//trace("WX_Tool.userMsg['score']:",WX_Tool.userMsg['score']);
			//scoreTxt.text = WX_Tool.userMsg['score'];
			//canvasImg.addChild(scoreTxt);
		}
		
		
		/**
		 * v1.02.1803181版本之后禁用
		 */
		public static function canvasToTemFilePath():void
		{
			var canvasToTempFilePath:Object = __JS__('wx.canvasToTempFilePath');
			canvasToTempFilePath({
				canvasId:Browser.window.sharedCanvas,
				x:0,
				y:0,
				width:WX_Tool.canvasImg.width,
				height:WX_Tool.canvasImg.height,
				destWidth:400,
				destHeight:300,
				success:function(res){
					trace("本地图片缓存地址Path:", res.tempFilePath);
					//传递给shareAppMessage
				},
			});
		}
		
		
		
		
		public static function shareAppMessage(_canvasUrl:String):void
		{
			var shareMsg:Object = __JS__('wx.shareAppMessage');
			shareMsg({
				title: '这个是本地缓存截图',
				imageUrl:_canvasUrl,
				success:function(res){
					trace("获取转发shareTicket：", res.shareTickets);
				}
			});
		}
		
	}

}