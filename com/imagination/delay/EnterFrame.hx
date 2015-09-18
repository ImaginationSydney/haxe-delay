package com.imagination.delay;

/**
 * ...
 * @author P.J.Shand
 */
class EnterFrame
{
	private static var enterFrameObjects = new Array<EnterFrameObject>();
	
	public function new() 
	{
		
	}
	
	static public function add(callback:Int->Void):Void 
	{
		var enterFrameObject:EnterFrameObject = new EnterFrameObject(callback);
		enterFrameObject.start();
		enterFrameObjects.push(enterFrameObject);
	}
	
	static public function remove(callback:Int->Void):Void 
	{
		for (i in 0...enterFrameObjects.length) 
		{
			if (enterFrameObjects[i].callback == callback) {
				enterFrameObjects[i].stop();
				enterFrameObjects[i] = null;
				enterFrameObjects.splice(i, 1);
			}
		}
	}
}