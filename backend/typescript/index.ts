import express from 'express';

const PORT = 3000;
const app: express.Express = express();

app.get("/", (req, res) => {
    res.status(200).send("Websona Backend");
});

app.listen(process.env.PORT || PORT, () => {
    console.log(`Listening at http://localhost:${process.env.PORT || PORT}`);
});

