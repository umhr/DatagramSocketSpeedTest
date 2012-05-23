package  
{
	import flash.events.DatagramSocketDataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.DatagramSocket;
	import flash.net.InterfaceAddress;
	import flash.net.IPVersion;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author umhr
	 */
	public class UDPAccessor extends EventDispatcher
	{
		
        private var _datagramSocket:DatagramSocket = new DatagramSocket();
		private var _time:Number;
		private var _localAdress:String;
		public var targetAdress:String;
		public var message:String;
		public var broadcast:int;
		public var unicast:int;
		public function UDPAccessor() 
		{
			init();
		}
		
		private function init():void 
		{
			bind(getLocalAdress(), 8989);
		}
		
        private function bind(localAdress:String,localPort:int):void
        {
			_localAdress = localAdress;
            if( _datagramSocket.bound ) 
            {
                _datagramSocket.close();
                _datagramSocket = new DatagramSocket();
            }
            _datagramSocket.bind(localPort, localAdress );
            _datagramSocket.addEventListener( DatagramSocketDataEvent.DATA, dataReceived );
            _datagramSocket.receive();
            trace( "Bound to: " + _datagramSocket.localAddress + ":" + _datagramSocket.localPort );
        }
		
		public function serch(targetAdress:String = "192.168.0.255"):void {
			send("serchmode", targetAdress);
		}
		
        public function send(message:String, targetAdress:String, targetPort:int = 8989):void
        {
			
			//Create a message in a ByteArray
            var data:ByteArray = new ByteArray();
            data.writeUTFBytes( message );
			
			_time = new Date().time;
			
            //Send a datagram to the target
            try
            {
                _datagramSocket.send( data, 0, 0, targetAdress, targetPort);
            }
            catch ( error:Error )
            {
                trace( error.message );
            }
        }
		
        private function dataReceived( event:DatagramSocketDataEvent ):void
        {
			var message:String = event.data.readUTFBytes( event.data.bytesAvailable );
			
			var isMe:Boolean = _localAdress == event.srcAddress;
			
			if (message == "ping_echoRequest_broadcast" && !isMe) {
				// bradcastでリクエストがきた場合、ブロードキャストで返す
				send("ping_echoReplay_broadcast", "192.168.0.255");
			}else if (message == "ping_echoRequest_unicast" && !isMe) {
				// uniでリクエストがきた場合、発信元に返す
				send("ping_echoReplay_unicast", event.srcAddress);
			}else if (message == "ping_echoReplay_broadcast" && !isMe) {
				broadcast = new Date().time-_time;
				dispatchEvent(new Event("broadcastComplete"));
			}else if (message == "ping_echoReplay_unicast" && !isMe) {
				unicast = new Date().time-_time;
				dispatchEvent(new Event("unicastComplete"));
			}else if (message == "serchmode" && !isMe) {
				send("serchmodeResponse" + _localAdress, event.srcAddress);
			}else if (message.substr(0, "serchmodeResponse".length) == "serchmodeResponse") {
				targetAdress = message.substr("serchmodeResponse".length);
				dispatchEvent(new Event("serchComplete"));
			}else if(_localAdress == event.srcAddress){
			}else {
				this.message = message;
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
        }
		
		/**
		 * addressをリスト化して、ソートしているのは、
		 * VMwareを設定した環境では、アクティブなipを複数持つことがあったため。
		 * @return
		 */
        public function getLocalAdress():String
        {
            var addressList:Array/*String*/ = [];
            var networkInfo:NetworkInfo = NetworkInfo.networkInfo;
            var networkInterfaceList:Vector.<NetworkInterface> = networkInfo.findInterfaces();
            
            for each (var networkInterface:NetworkInterface  in networkInterfaceList)
            {
				if (networkInterface.active) {
					for each (var interfaceAddress:InterfaceAddress in networkInterface.addresses)
					{
						if (interfaceAddress.ipVersion == IPVersion.IPV4 && interfaceAddress.broadcast) {
							addressList.push(interfaceAddress.address);
						}
					}
                }
            }
			
			addressList.sort();
            return addressList[0];
        }
	}

}