package src;

import js.JQuery;
import jp.saken.utils.Dom;
import src.db.*;
import src.datalist.*;
import src.view.*;
import src.utils.*;
 
class Manager {
	
	private static var _counter:Int;
	
	/* =======================================================================
	Public - Init
	========================================================================== */
	public static function init(event:JqEvent):Void {
		
		Dom.jWindow.on('loadDB',onLoadedDB);
		
		Members.load();
		Works.load();
		Clients.load();
		
	}
	
	/* =======================================================================
	On Loaded DB
	========================================================================== */
	private static function onLoadedDB(event:JqEvent):Void {
		
		Dom.jWindow.unbind('loadDB',onLoadedDB);
		
		Clientlist.init();
		Worklist.init();
		
		Form.init();
		Result.init();
		Csv.init();
		
	}

}