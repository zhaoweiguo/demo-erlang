


var ws = new WebSocket("wss://deviot.lenovo.com.cn/device/connect?ver=0.0.1&deviceType=200101&token=c8b86724ffcb7f5600f8721d3a4ecf50d112842831fe9b5065daaef498779a88&sn=20010100001");

ws.onopen = function(evt) {
    console.log("Connection open ...");
    ws.send("Hello WebSockets!");
};

ws.onmessage = function(evt) {
    console.log( "Received Message: " + evt.data);
    ws.close();
};

ws.onclose = function(evt) {
    console.log("Connection closed.");
};




