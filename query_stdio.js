const { spawn, execSync } = require('child_process');

try { execSync('lsof -ti:38450 | xargs kill -9 2>/dev/null'); } catch(e) {}

console.log("Starting MCP Server... Waiting for Figma plugin to connect...");

const server = spawn('node', ['/Users/ahmedteli/Desktop/AI tools/figma-mcp-server/mcp/dist/index.js'], {
  env: { ...process.env, TRANSPORT: 'stdio' },
  stdio: ['pipe', 'pipe', 'pipe']
});

let isInitialized = false;
let isFigmaConnected = false;
let requestSent = false;

function trySendRequest() {
  if (isInitialized && isFigmaConnected && !requestSent) {
    requestSent = true;
    console.log("Sending get-node-info request for 7:7642...");
    server.stdin.write(JSON.stringify({
      jsonrpc: '2.0',
      id: 2,
      method: 'tools/call',
      params: { name: 'get-node-info', arguments: { id: '7:7642' } }
    }) + '\n');
  }
}

server.stdout.on('data', (data) => {
  const str = data.toString();
  if (str.includes('"id":1')) {
    isInitialized = true;
    trySendRequest();
  }
  if (str.includes('"id":2')) {
    console.log('RESULT RECEIVED:\n', str);
    process.exit(0);
  }
});

server.stderr.on('data', (data) => {
  const str = data.toString();
  if (str.includes('a user connected')) {
    console.log("Figma Plugin Connected!");
    isFigmaConnected = true;
    trySendRequest();
  }
});

server.stdin.write(JSON.stringify({
  jsonrpc: '2.0',
  id: 1,
  method: 'initialize',
  params: { protocolVersion: '2024-11-05', capabilities: {}, clientInfo: { name: 'test', version: '1.0' } }
}) + '\n');
server.stdin.write(JSON.stringify({ jsonrpc: '2.0', method: 'notifications/initialized' }) + '\n');

setTimeout(() => {
  console.log("Script timed out waiting for Figma connection.");
  process.exit(1);
}, 120000);
