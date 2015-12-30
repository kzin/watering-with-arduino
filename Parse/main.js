
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("send", function(request, response) {   
  Parse.Push.send({
    channels: [ "client" ], // Set our Installation query
    data: {
      alert: "Reservatório vazio!"
    }
  }, {
    success: function() {
      // Push was successful
      response.success("push send");
    },
    error: function(error) {
      throw "Got an error " + error.code + " : " + error.message;
      response.error("failed");
    }
  });
});
