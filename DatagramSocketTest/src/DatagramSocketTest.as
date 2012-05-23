package  
{
	
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.DatagramSocket;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author umhr
	 */
	public class DatagramSocketTest extends Sprite 
	{
		
        private var datagramSocket:DatagramSocket = new DatagramSocket();;

        private var localIP:TextField;
        private var localPort:TextField;
        private var logField:TextField;
        private var targetIP:TextField;
        private var targetPort:TextField;
        private var message:TextField;
		private var _speedBroadCast:TextField;
		private var _speedUniCast:TextField;
		private var _time:Number;
		private var _udpAccessor:UDPAccessor = new UDPAccessor();
		public function DatagramSocketTest() 
		{
			init();
		}
		private function init():void 
		{
            if (stage) onInit();
            else addEventListener(Event.ADDED_TO_STAGE, onInit);
        }
        
        private function onInit(event:Event = null):void 
        {
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			//;
            setupUI(_udpAccessor.getLocalAdress());
			_udpAccessor.addEventListener(Event.COMPLETE, udpAccessor_complete);
        }
		
		private function udpAccessor_complete(e:Event):void 
		{
			//trace("zzz");
			log(_udpAccessor.message);
		}
		
        private function log( text:String ):void
        {
            logField.appendText( text + "\n" );
            logField.scrollV = logField.maxScrollV;
        }
        private function setupUI(localIP:String = "0.0.0.0"):void
        {
            this.localIP = createTextField( 10, 10, "Local IP:", localIP);
			this.localIP.width = 150;
            localPort = createTextField( 200, 10, "port:", "8989" );
			localPort.width = 80;
			
			new PushButton(this, 80, 35, "Serch", serch);
            targetIP = createTextField( 10, 60, "Target IP:", "192.168.0.255" );
			this.targetIP.width = 150;
            targetPort = createTextField( 200, 60, "port:", "8989" );
			targetPort.width = 80;
			
            message = createTextField( 10, 100, "Message:", "Lucy can't drink milk." );
			new PushButton(this, 150, 125, "Send(BroadCast)", broadcast);
			new PushButton(this, 260, 125, "Send(UniCast)", unicast);
			
            logField = createTextField( 10, 150, "Log:", "", false, 200 );
                
			_speedBroadCast = createTextField( 135, 360, ":", "msec" );
			_speedBroadCast.width = 50;
			new PushButton(this, 80, 360, "Speed Test(BroadCast)", onSpeedTestBroadCast);
			_speedUniCast = createTextField( 135, 385, ":", "msec" );
			_speedUniCast.width = 50;
			new PushButton(this, 80, 385, "Speed Test(UniCast)", onSpeedTestUniCast);
			
			_udpAccessor.addEventListener("broadcastComplete", speedUniCast_broadcastcomplete);
			_udpAccessor.addEventListener("unicastComplete", speedUniCast_unicastcomplete);
            this.stage.nativeWindow.activate();
        }
		
		private function speedUniCast_unicastcomplete(event:Event):void 
		{
			_speedUniCast.text = String(_udpAccessor.unicast);
		}
		
		private function speedUniCast_broadcastcomplete(event:Event):void 
		{
			_speedBroadCast.text = String(_udpAccessor.broadcast);
		}
		
		private function onSpeedTestBroadCast(event:Event):void 
		{
			_udpAccessor.send("ping_echoRequest_broadcast", "192.168.0.255", parseInt(targetPort.text));
		}
		
		private function onSpeedTestUniCast(event:Event):void 
		{
			_udpAccessor.send("ping_echoRequest_unicast", targetIP.text, parseInt(targetPort.text));
		}
		
        private function broadcast( event:Event ):void
        {
			_udpAccessor.send(message.text, "192.168.0.255", parseInt(targetPort.text));
        }
		
		private function unicast(event:Event):void 
		{
			_udpAccessor.send(message.text, targetIP.text, parseInt(targetPort.text));
		}
		
		private function serch(event:Event):void 
		{
			_udpAccessor.serch();
			_udpAccessor.addEventListener("serchComplete", udpAccessor_serchcomplete);
			
		}
		
		private function udpAccessor_serchcomplete(event:Event):void 
		{
			_udpAccessor.removeEventListener("serchComplete", udpAccessor_serchcomplete);
			targetIP.text = _udpAccessor.targetAdress;
		}
        
        private function createTextField( x:int, y:int, label:String, defaultValue:String = '', editable:Boolean = true, height:int = 20 ):TextField
        {
			var textFormat:TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.RIGHT;
            var labelField:TextField = new TextField();
			labelField.defaultTextFormat = textFormat;
            labelField.text = label;
            labelField.type = TextFieldType.DYNAMIC;
            labelField.width = 65;
            labelField.x = x;
            labelField.y = y;
            
            var input:TextField = new TextField();
            input.text = defaultValue;
            input.type = TextFieldType.INPUT;
            input.border = true;
            input.selectable = editable;
            input.width = 280;
            input.height = height;
            input.x = x + labelField.width+4;
            input.y = y;
            
            this.addChild( labelField );
            this.addChild( input );
            
            return input;
        }
        
    }
}