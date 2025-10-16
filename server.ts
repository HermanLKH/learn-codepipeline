// server.ts
const server = Bun.serve({
    port: 3000,
    hostname: "0.0.0.0", // important for Docker/ECS; use 127.0.0.1 for local only
    fetch(req) {
        const url = new URL(req.url);

        if (url.pathname === "/") {
            return new Response("Hello via Bun!");
        }

        if (url.pathname === "/json") {
            return Response.json({ ok: true, runtime: "bun" });
        }

        // simple static file example: /static/filename.txt
        if (url.pathname.startsWith("/static/")) {
            const path = url.pathname.replace("/static/", "");
            const file = Bun.file(`./public/${path}`);
            return file.size ? new Response(file) : new Response("Not found", { status: 404 });
        }

        return new Response("Not found", { status: 404 });
    },
});

console.log(`✅ Bun server listening on http://localhost:${server.port}`);
