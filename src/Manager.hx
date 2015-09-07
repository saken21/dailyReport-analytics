package src;

import js.JQuery;
import src.datalist.*;
import src.view.*;
import src.utils.*;
 
class Manager {
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init(event:JqEvent):Void {
		
		Clientlist.init();
		Worklist.init();
		Teamlist.init();
		Memberlist.init();
		
		Form.init();
		Result.init();
		Csv.init();
		
	}

}