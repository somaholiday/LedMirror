/* Wrapper class for each of the apprentices' scenes */

abstract class Scene {

  public Scene() {
    this._setup();
  }

  // abstract drawing methods
  abstract void _setup();
  abstract void _draw();
}