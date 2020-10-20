"use strict";
var app = require("express")();
var port = 3000;
app.get("/", function (req, res) {
    res.status(200).send("Websona Backend");
});
app.listen(process.env.PORT || port, function () {
    console.log("Listening at http://localhost:" + (process.env.PORT || port));
});
