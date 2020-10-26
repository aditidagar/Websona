import chai from "chai";
import chaiHttp from "chai-http";
import { exec } from 'child_process';

chai.use(chaiHttp);
chai.should();

const SERVER_URL: string = "http://localhost:3000";
// launch the server in the background to run the tests
const _SERVER = exec("npm start &", (err, STDOUT, STDERR) => {
    if (err) throw Error("Couldn't launch the server for tests");
});

var auth: string = "";

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

            done();
        });
    });
});
