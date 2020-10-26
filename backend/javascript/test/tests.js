"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const chai_1 = __importDefault(require("chai"));
const chai_http_1 = __importDefault(require("chai-http"));
const child_process_1 = require("child_process");
chai_1.default.use(chai_http_1.default);
chai_1.default.should();
const SERVER_URL = "http://localhost:3000";
// launch the server in the background to run the tests
const _SERVER = child_process_1.exec("npm start &", (err, STDOUT, STDERR) => {
    if (err)
        throw Error("Couldn't launch the server for tests");
});
let auth = "";
describe("Sanity checks", () => {
    it("Check server is alive", (done) => {
        chai_1.default.request(SERVER_URL).get("/").end((err, res) => {
            if (!res)
                chai_1.default.assert.fail("No response from server on route '/'");
            chai_1.default.expect(res.status).equal(200);
            done();
        });
    });
});
describe("JWT tests", () => {
    it("Try to access protected resource without auth", (done) => {
        chai_1.default.request(SERVER_URL).get("/protectedResource").end((err, res) => {
            if (!res)
                chai_1.default.assert.fail("No response from server on route '/protectedResource'");
            chai_1.default.expect(res.status).equal(401);
            done();
        });
    });
    it("Try to obtain auth token", (done) => {
        chai_1.default.request(SERVER_URL).get("/token").query({ name: "testUser" }).end((err, res) => {
            if (!res)
                chai_1.default.assert.fail("No response from server on route '/token'");
            chai_1.default.expect(res.status).equal(200);
            auth = "Bearer " + res.text;
            done();
        });
    });
    it("Try to access protected resource with auth", (done) => {
        chai_1.default.request(SERVER_URL).get("/protectedResource")
            .set("authorization", auth)
            .end((err, res) => {
            if (!res)
                chai_1.default.assert.fail("No response from server on route '/protectedResource'");
            chai_1.default.expect(res.status).equal(200);
            done();
        });
    });
});
