const app = require("express")();
const port = 3000;

app.get("/", (req, res) => {
    res.status(200).send("Websona Backend");
});

app.listen(process.env.PORT || port, () => {
    console.log(`Listening at http://localhost:${process.env.PORT || port}`);
});

