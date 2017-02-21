abstract class Scene {

  public Scene() {
    this._setup();
  }

  // abstract drawing methods
  abstract void _setup();
  abstract void _draw();
}