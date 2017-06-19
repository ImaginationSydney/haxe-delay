package com.imagination.delay;

import haxe.ds.ObjectMap;
import haxe.Timer;
import lime.app.Application;

#if flash
import flash.Lib;
import flash.events.Event;
#elseif openfl
import openfl.Lib;
import openfl.events.Event;
#end
/**
 * ...
 * @author P.J.Shand
 */
class EnterFrame
{
	private static var enterFrameObjects = new Array<EnterFrameObject>();
	//private static var enterFrameObjects = new ObjectMap<Dynamic, EnterFrameObject>();
	private static var _running:Bool = false;
	private static var running(get, set):Bool;
	
	public function new() 
	{
		
	}
	
	private static function OnTick():Void
	{
		var i = 0;
		var frameDelta = (cast 1000 / Application.current.frameRate); // passing fake delta
		
		while (i < enterFrameObjects.length) 
		{
			var enterFrameObject = enterFrameObjects[i];
			enterFrameObject.tick(frameDelta);
			
			if (enterFrameObject == enterFrameObjects[i]){
				i++;
			}else{
				var ind = enterFrameObjects.indexOf(enterFrameObject);
				if (ind != -1){
					i = ind + 1;
				}
			}
		}
		
		#if (!flash && !openfl)
			if (running) Timer.delay(OnTick, Std.int(1000 / Application.current.frameRate));
		#end
	}
	
	static public function add(callback:Int->Void):Void 
	{
		running = true;
		var enterFrameObject:EnterFrameObject = getEnterFrameObject(callback);
		if (enterFrameObject == null) {
			enterFrameObject = new EnterFrameObject(callback);
			enterFrameObjects.push(enterFrameObject);
		}
		enterFrameObject.start();
	}
	
	static public function addAt(callback:Int->Void, index:Int):Void 
	{
		var currentEnterFrameObject:EnterFrameObject = getEnterFrameObject(callback);
		if (currentEnterFrameObject != null) {
			remove(callback);
		}
		if (enterFrameObjects.length > index) {
			var newEnterFrameObjects = new Array<EnterFrameObject>();
			for (i in 0...enterFrameObjects.length) 
			{
				if (i == index) {
					var enterFrameObject:EnterFrameObject = new EnterFrameObject(callback);
					newEnterFrameObjects.push(enterFrameObject);
					enterFrameObject.start();
				}
				newEnterFrameObjects.push(enterFrameObjects[i]);
			}
			enterFrameObjects = newEnterFrameObjects;
		}
		else {
			add(callback);
		}
	}
	
	static public function remove(callback:Int->Void):Void 
	{
		var i:Int = enterFrameObjects.length - 1;
		while (i >= 0) 
		{
			if (enterFrameObjects[i].callback == callback) {
				var enterFrameObject:EnterFrameObject = enterFrameObjects[i];
				enterFrameObject.stop();
				enterFrameObject = null;
				enterFrameObjects.splice(i, 1);
			}
			i--;
		}
		if (enterFrameObjects.length == 0) running = false;
	}
	
	static private function getEnterFrameObject(callback:Int->Void):EnterFrameObject
	{
		for (i in 0...enterFrameObjects.length) 
		{
			if (enterFrameObjects[i].callback == callback) {
				return enterFrameObjects[i];
			}
		}
		return null;
	}
	
	private static function get_running():Bool
	{
		return _running;
	}
	
	private static function set_running(value:Bool):Bool
	{
		if (_running == value) return value;
		_running = value;
		if (_running) {
			#if (flash || openfl)
				Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
			#else
				OnTick();
			#end
		}
		else {
			#if (flash || openfl)
				Lib.current.stage.removeEventListener(Event.ENTER_FRAME, Update);
			#end
		}
		return _running;
	}
	
	#if (flash || openfl)
	static private function Update(e:Event):Void 
	{
		OnTick();
	}
	#end
}