
var task = new Task(init);
task.schedule(100);

function init()
{
	//post("here");
	var basic = this.patcher;
	if( basic != null )
	{
		basic.message("gridsize", 10., 10.);
		basic.message("gridonopen", 1 );	
		basic.message("gridsnaponopen", 1 );	
		basic.message("toolbarvisible", 0 );	
		basic.message("fontsize", 11);
		basic.message("fontname", "Arial");
		basic.message("locked_bgcolor", 0.9, 0.9, 0.9, 0.9);
		basic.message("editing_bgcolor", 0.9, 0.9, 0.9, 0.9);
	}
}

