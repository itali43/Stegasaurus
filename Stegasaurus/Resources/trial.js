function myFunction(){
    // this code will be called every 5 seconds
    console.log("Hi Elliott.  How are you today?")
}

function setupWKWebViewJavascriptBridge(callback) {
    if (window.WKWebViewJavascriptBridge) { return callback(WKWebViewJavascriptBridge); }
    if (window.WKWVJBCallbacks) { return window.WKWVJBCallbacks.push(callback); }
    window.WKWVJBCallbacks = [callback];
    window.webkit.messageHandlers.iOS_Native_InjectJavascript.postMessage(null)
}



setupWKWebViewJavascriptBridge(function(bridge) {
                               
                               /* Initialize your app here */
                               console.log("Hi Elliott.  How are you today?")
                               bridge.registerHandler('testJavascriptHandler', function(data, responseCallback) {
                                                      console.log('iOS called testJavascriptHandler with', data)
                                                      responseCallback({ 'Javascript Says':'Right back atcha!' })
                                                      })
                               
                               bridge.callHandler('testiOSCallback', {'foo': 'bar'}, function(response) {
                                                  console.log('JS got response', response)
                                                  })
                               })
