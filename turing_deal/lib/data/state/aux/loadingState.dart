class LoadingState{

  static const STATE_INIT = 0;
  static const STATE_DOWNLOADING = 1;
  static const STATE_PROCESSING = 2;
  static const STATE_DONE = 3;

  int _loadingState = 0;


  int getLoadingState(){
    return _loadingState;
  }

  setLoadingState(int state){
    this._loadingState = state;
  }

  isProcessingState() {
    return _loadingState != 3;
  }
}