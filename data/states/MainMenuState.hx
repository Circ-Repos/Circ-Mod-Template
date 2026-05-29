import flixel.object.FlxObject;
import flixel.text.FlxTextAlign;



function postCreate() {
      for(bg in [bg,magenta]){
        bg.scrollFactor.x = 0; 
        bg.scrollFactor.y = 0.05;
        bg.setGraphicSize(Std.int(FlxG.width * 1.2));
        bg.updateHitbox();
        bg.screenCenter();
    }
    
    camFollow = new FlxObject(camFollow, 0, 1, 1);

    var spacing = 160;
    var top = (FlxG.height - (spacing * (menuItems.length - 1))) / 2;
    for (i in 0...menuItems.length)
    {
      var menuItem = menuItems.members[i];
      menuItem.y = 115 + 230*i;
      menuItem.scrollFactor.x = 0;
      menuItem.scrollFactor.y = 0.7;
      if (i == 1)
      {
        camFollow.setPosition(menuItem.getGraphicMidpoint().x, menuItem.getGraphicMidpoint().y);
      }
    }
    camFollow.y = bg.getGraphicMidpoint().y;
    FlxG.camera.follow(camFollow, null, 0.06);


		giftSquare = new FlxSprite(100,200).makeGraphic(150, 150, FlxColor.RED);
		giftSquare.updateHitbox();
		add(giftSquare);

		currentCoolText = new FlxText(100, 100, 0, 'this cube \nis a Cube\nIt Does Nothing\n-Circ');
		currentCoolText.setFormat(Paths.font("VCR.ttf"), 16, FlxColor.RED, FlxTextAlign.CENTER);
		currentCoolText.antialiasing = false;
		currentCoolText.updateHitbox();
		add(currentCoolText);
}