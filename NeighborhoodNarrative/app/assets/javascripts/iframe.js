var activeCount = 0;

window.addEventListener('load', function(event) {
  if (window.parent) {
    window.parent.postMessage('loaded', '*');
  }
});

window.addEventListener('message', function(event) {
  if (
    !/^(chrome|safari)-extension:/.test(event.origin) &&
    ["https://mail.google.com", "https://inbox.google.com"].indexOf(event.origin) < 0
  ) {
    return;
  }

  function channelMessage(op, data) {
    event.source.postMessage({type:'realtime', op:op, data:data}, event.origin);
  }

  try {
    if (event.data.op === 'connect') {
      var token = event.data.token;
      var channel = new goog.appengine.Channel(token);
      var socket = channel.open({
        onopen: function() {
          channelMessage("open", null);
        },
        onmessage: function(msg) {
          channelMessage("message", msg);
        },
        onerror: function(msg) {
          channelMessage("error", msg);
        },
        onclose: function(msg) {
          activeCount--;
          channelMessage("close", msg);
        }
      });
      activeCount++;
      if (activeCount > 1) {
        console.warn("Warning: There are "+activeCount+" active connections");
      }
    }
  } catch(e) {
    channelMessage("error", {message: e&&e.message, stack: e&&e.stack});
  }
});
