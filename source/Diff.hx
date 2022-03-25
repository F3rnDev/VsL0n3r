package;

class Diff{
	public static var diffData:Array<String> = ['-easy', '', '-hard']; //change when adding new difficulties\\
    public static var diffID:Int = 1; //saves the difficulty you selected, unless you close the game\\
	public static var curDiff:String; 

    public static function loadDiff(){ //updates curDiff\\
        curDiff = diffData[diffID];
    }
}