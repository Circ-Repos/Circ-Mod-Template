function postCreate() {
    absentia = new FlxSprite(0,0,Paths.image("absense"));
    absentia.camera = camHUD;
    absentia.antialiasing = Options.antialiasing;
    healthBar.scale.set(1,8);
    healthBar.updateHitbox();
    remove(healthBarBG,true);
    add(absentia);
    remove(absentia, true);
    insert(0, absentia);
}