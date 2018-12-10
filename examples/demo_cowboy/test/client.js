function init() {

    var wsServer = 'ws://127.0.0.1:8081/websocket?token=123';
    var websocket = new WebSocket(wsServer);
    websocket.onopen = function (evt) {
        console.log((new Date()).toTimeString() + "Connected to WebSocket server.");
    };

    websocket.onclose = function (evt) {
        console.log((new Date()).toTimeString() + "Disconnected");
    };

    websocket.onmessage = function (evt) {
        console.log((new Date()).toTimeString() + 'Retrieved data from server: ' + evt.data);
    };

    websocket.onerror = function (evt, e) {
        console.log((new Date()).toTimeString() + 'Error occured: ' + evt.data);
    };
};

function disconnect() {
  websocket.close();
};

function sendmessage(Msg) {
    websocket.send(Msg);
}