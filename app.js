const express = require('express');
const app = express();
const port = 3000;

// Middleware to log requests
app.use((req, res, next) => {
    console.log(`Request received: ${req.method} ${req.url}`);
    next();
});

// Simple "Hello World" route
app.get('/', (req, res) => {
    res.send('Hello World');
});

// Health check endpoint
app.get('/healthz', (req, res) => {
    res.status(200).send('Healthy');
});

// Start the server
app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
});
