class SceneManager {

  Scene[] scenes;
  int currentSceneIndex;

  public SceneManager(Scene[] scenes) {
    this.scenes = scenes;
    currentSceneIndex = 0;
  }

  public Scene getCurrentScene() {
    return scenes[currentSceneIndex];
  }

  public void nextScene() {
    noTint();

    currentSceneIndex = (currentSceneIndex + 1) % scenes.length;
  }
}