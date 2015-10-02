package src.db;

import jp.saken.utils.Ajax;
import jp.saken.utils.Dom;
 
class Database {
	
	private var _db :Array<Dynamic>;
	private static var _counter:Int;
	
	/* =======================================================================
	Constructor
	========================================================================== */
	public function new(table:String,columns:Array<String>,where:String = ''):Void {
		
		_db = [];
		
		if (_counter == null) _counter = 0;
		_counter++;
		
		Ajax.getData(table,columns,function(data:Array<Dynamic>):Void {
			
			for (p in 0...data.length) {
				
				var obj:Dynamic = data[p];
				_db[obj.id] = obj;
				
			}
			
			_counter--;
			if (_counter == 0) Dom.jWindow.trigger('loadDB');
			
		},where);
		
	}
	
		/* =======================================================================
		Public - Get DB
		========================================================================== */
		public function getDB():Array<Dynamic> {
			
			return _db;
			
		}

}