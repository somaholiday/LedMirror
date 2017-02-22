class SceneManager {

  static final int FRAMES_PER_SCENE = 30 * 45;
  static final int FRAMES_PER_FADE = 30 * 6;
  static final int FRAMES_BETWEEN_FADES = 30 * 2;

  private Scene[] scenes;
  private int currentSceneIndex;
  private int currentFrameCount = 0;

  public SceneManager(Scene[] scenes) {
    this.scenes = scenes;
    currentSceneIndex = 0;
  }

  private Scene getCurrentScene() {
    return scenes[currentSceneIndex];
  }

  public void nextScene() {
    noTint();

    currentSceneIndex = (currentSceneIndex + 1) % scenes.length;
  }

  public void update() {
    currentFrameCount++;
    
    getCurrentScene()._draw(); 

    // FADE IN 
    if (currentFrameCount < FRAMES_PER_FADE) {
      float fade = norm(currentFrameCount, FRAMES_PER_FADE, 0);
      fadeRect(fade * 255);
    }

    // FADE OUT
    if (FRAMES_PER_SCENE - currentFrameCount < FRAMES_PER_FADE) {
      float fade = norm(FRAMES_PER_SCENE - currentFrameCount, FRAMES_PER_FADE, 0);
      fadeRect(fade * 255);
    }

    if (currentFrameCount > FRAMES_PER_SCENE + FRAMES_BETWEEN_FADES) {
      nextScene();
      currentFrameCount = 0;
    }
  }
}