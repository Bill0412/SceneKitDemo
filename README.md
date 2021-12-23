# SceneKit Demo

## Intro

This is a demo that shows you how you can manipulate data in Swift SceneKit using your customized functions in C/C++.

## Demo

When you run the program, you should move your camera so that a shape comprised of 5 cylinders conntect head to end can be constructed. The position of the joints are determined by your camera position in 5 seconds, every 1 second camera position data as a point.

After 5 seconds, the shape you created by your phone will move up 0.01m every 1 second.

## References
1. [Integer from Swift to C](https://stackoverflow.com/questions/32478352/pass-int-to-c-function)
2. [Pass Swift Array as C argument](https://gist.github.com/kirsteins/6d6e96380db677169831)
3. [SceneKit SCNNode Documentation](https://developer.apple.com/documentation/scenekit/scnnode)
4. [Bridging using SIMD](https://developer.huawei.com/consumer/cn/forum/topic/41600165?fid=19)