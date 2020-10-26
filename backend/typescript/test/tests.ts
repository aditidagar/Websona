import chai from "chai";
import chaiHttp from "chai-http";
import app from "../index";

chai.use(chaiHttp);
chai.should();

const SERVER_URL: string = "http://localhost:8000";
const _SERVER = app.listen(8000, () => console.log("Launched server"));

let auth: string = "";

describe("Sanity checks", () => {

    it("Check server is alive", (done) => {
        chai.request(SERVER_URL).get("/").end((err, res) => {
            if(!res) chai.assert.fail("No response from server on route '/'");
            chai.expect(res.status).equal(200);

            done();
        });
    });

});

describe("JWT tests", () => {

    it("Try to access protected resource without auth", (done) => {
        chai.request(SERVER_URL).get("/protectedResource").end((err, res) => {
            if (!res) chai.assert.fail("No response from server on route '/protectedResource'");
            chai.expect(res.status).equal(401);

            done();
        });
    });

    it("Try to obtain auth token", (done) => {
        chai.request(SERVER_URL).get("/token").query({ name: "testUser"}).end((err, res) => {
            if (!res) chai.assert.fail("No response from server on route '/token'");
            chai.expect(res.status).equal(200);
            auth = "Bearer " + res.text;
            done();
        });
    });

    it("Try to access protected resource with auth", (done) => {
        chai.request(SERVER_URL).get("/protectedResource")
        .set("authorization", auth)
        .end((err, res) => {
            if (!res) chai.assert.fail("No response from server on route '/protectedResource'");
            chai.expect(res.status).equal(200);

            _SERVER.close();
            done();
        });
    });
});
