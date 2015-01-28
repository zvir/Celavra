package clv.reactor 
{
	import clv.common.FlashGlobals;
	import clv.reactor.Reactor;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.proxy.IClassProxyInfo;
	import org.as3commons.bytecode.proxy.impl.ProxyFactory;
	import org.as3commons.bytecode.proxy.IProxyFactory;
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.osflash.signals.Signal;
	
	
	/**
	 * ...
	 * @author Zvir
	 */
	public class ReactorFactory 
	{
		private var interfaceFullName:String;
		private var interfaceNameParts:Array;
		private var interfacePackage:String;
		private var interfaceName:String;
		private var className:String;
		private var classFullName:String;
		
		public const onComplete:Signal = new Signal(Object);
		
		public function ReactorFactory()
		{
			
		}
		
		public function create2(_interface:Class):void
		{
			var r:Reactor = new Reactor();
			
			var x:XML = describeType(_interface);
			
			trace(x.toString());
			
			interfaceFullName = x.@name;
			interfaceNameParts = interfaceFullName.split("::");
			interfacePackage = interfaceNameParts[0];
			interfaceName = interfaceNameParts[1];
			
			className = interfaceName.substr(1);
			
			interfaceFullName = interfacePackage + "." + interfaceName;
			
			classFullName = interfacePackage + "." + className;
			
			var _applicationDomain:ApplicationDomain = FlashGlobals.loaderInfo.applicationDomain;
			ByteCodeType.fromLoader(FlashGlobals.loaderInfo);
			
			var proxyFactory:IProxyFactory = new ProxyFactory();
			
			var classProxyInfo:IClassProxyInfo = proxyFactory.defineProxy(Reactor, null, _applicationDomain);
			classProxyInfo.implementInterface(_interface);
			
			proxyFactory.generateProxyClasses();
			
			proxyFactory.addEventListener(Event.COMPLETE, proxiesLoadedHandler);
			
			proxyFactory.loadProxyClasses();
			
		}
		
		private function proxiesLoadedHandler(e:Event):void 
		{
		/*	var proxyFactory:IProxyFactory = (event.target as IProxyFactory);
			proxyFactory.addEventListener(ProxyFactoryEvent.GET_METHOD_INVOCATION_INTERCEPTOR, createMethodInterceptor);
			var myBusinessObj:MyBusinessObject = proxyFactory.createProxy(MyBusinessObject);
			//This will yield a trace something like this: 'Sun Dec 26 17:43:19 GMT+0100 2010 DEBUG - MyBusinessObject was instantiated'
			myBusinessObj.calculateTotalPrice(new Order());
			//And this will yield a trace like this: 'Sun Dec 26 17:43:19 GMT+0100 2010 DEBUG - calculateOrderPrice was invoked with parameter Order'
			
			*/
			trace("complete");
		}
		
		public function create(_interface:Class):void
		{
			
			var r:Reactor = new Reactor();
			
			var x:XML = describeType(_interface);
			
			trace(x.toString());
			
			interfaceFullName = x.@name;
			interfaceNameParts = interfaceFullName.split("::");
			interfacePackage = interfaceNameParts[0];
			interfaceName = interfaceNameParts[1];
			
			className = interfaceName.substr(1);
			
			interfaceFullName = interfacePackage + "." + interfaceName;
			
			classFullName = interfacePackage + "." + className;
			
			var abcBuilder:IAbcBuilder = new AbcBuilder();
			var packageBuilder:IPackageBuilder = abcBuilder.definePackage(interfacePackage);
			var classBuilder:IClassBuilder = packageBuilder.defineClass(className, "clv.reactor.Reactor");
			
			classBuilder.implementInterface(interfaceFullName);
			classBuilder.isDynamic = true;
			
			
			trace("-------------------------- methods --------------------------");
			
			for each (var method:XML in x.factory.method) 
			{
				trace(method.@name);
				
				var methodBuilder:IMethodBuilder = classBuilder.defineMethod(method.@name);
				
				var parameters:Array = [];
				
				for each (var parameter:XML in method.parameter) 
				{
					parameters[int(parameter.@index) - 1] = parameter.@type;
				}
				
				for (var i:int = 0; i < parameters.length; i++) 
				{
					methodBuilder.defineArgument(parameters[i]);
				}
				
				
				
			}
			
			abcBuilder.addEventListener(Event.COMPLETE, loadedHandler);
			abcBuilder.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			abcBuilder.addEventListener(IOErrorEvent.VERIFY_ERROR, errorHandler);
			abcBuilder.buildAndLoad();
			
		}
		
		private function errorHandler(e:IOErrorEvent):void 
		{
			
		}
		
		private function loadedHandler(e:Event):void 
		{
			
			var clazz:Class = ApplicationDomain.currentDomain.getDefinition(classFullName) as Class;
			var instance:Object = new clazz();
			
			onComplete.dispatch(instance);
			
		}
		
		
		
	}

}