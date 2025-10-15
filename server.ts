import Fastify from "fastify";

const app = Fastify({ logger: true });

// Health check endpoint for ALB target group
app.get("/", async () => {
    return { ok: true, service: "fastify", version: "1.0.0" };
});

// Example API endpoint
app.get("/hello", async () => {
    return { message: "Hello from Fastify!" };
});

// In containers/ECS you must listen on 0.0.0.0
const PORT = Number(process.env.PORT) || 3000;
const HOST = "0.0.0.0";

app
    .listen({ port: PORT, host: HOST })
    .then(() => {
        app.log.info(`Server listening on http://${HOST}:${PORT}`);
    })
    .catch((err) => {
        app.log.error(err);
        process.exit(1);
    });
