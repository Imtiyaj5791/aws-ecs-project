
const request = require("supertest");
const app = require("../src/server");

describe("Application API Tests", () => {

    beforeEach(() => {
        delete process.env.ENVIRONMENT;
    });

    test("GET / should return application message", async () => {
        const response = await request(app).get("/");

        expect(response.statusCode).toBe(200);
        expect(response.body.message).toBe(
            "AWS ECS application is running!"
        );
        expect(response.body.environment).toBe("local");
    });

    test("GET /health should return healthy status", async () => {
        const response = await request(app).get("/health");

        expect(response.statusCode).toBe(200);
        expect(response.body).toEqual({
            status: "healthy"
        });
    });

});
