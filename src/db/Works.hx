package src.db;
 
class Works {
	
	private static var _database:Database;
	
	private static inline var TABLE_NAME:String = 'works';
	private static var COLUMN_LIST:Array<String> = ['id','client_id','name'];
	
	/* =======================================================================
	Public - Load
	========================================================================== */
	public static function load():Void {
		
		_database = new Database(TABLE_NAME,COLUMN_LIST);
		
	}
	
		/* =======================================================================
		Public - Get DB
		========================================================================== */
		public static function getDB():Array<Dynamic> {
			
			return _database.getDB();

		}

}