package src;

import js.JQuery;
import src.datalist.*;
 
class Manager {
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init(event:JqEvent):Void {
		
		Clientlist.init();
		Worklist.init();
		Memberlist.init();
		
	}

}