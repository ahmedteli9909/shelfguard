const { spawn, execSync } = require('child_process');

try { execSync('lsof -ti:38450 | xargs kill -9 2>/dev/null'); } catch(e) {}

const server = spawn('node', ['/Users/ahmedteli/Desktop/AI tools/figma-mcp-server/mcp/dist/index.js'], {
  env: { ...process.env, TRANSPORT: 'stdio' },
  stdio: ['pipe', 'pipe', 'pipe']
});

server.stdout.on('data', (data) => {
  const str = data.toString();
  if (str.includes('"id":2')) {
    console.log(str);
    process.exit(0);
  }
});

server.stdin.write(JSON.stringify({
  jsonrpc: '2.0', id: 1, method: 'initialize',
  params: { protocolVersion: '2024-11-05', capabilities: {}, clientInfo: { name: 'test', version: '1.0' } }
}) + '\n');
server.stdin.write(JSON.stringify({ jsonrpc: '2.0', method: 'notifications/initialized' }) + '\n');

// Wait 3 seconds for Figma plugin to automatically reconnect
setTimeout(() => {
  server.stdin.write(JSON.stringify({
    jsonrpc: '2.0', id: 2, method: 'tools/call',
    params: { name: 'get-node-info', arguments: { id: '7:7642' } }
  }) + '\n');
}, 3000);

setTimeout(() => {
  console.log("Error: Figma plugin connection timeout. Please make sure the plugin is open.");
  process.exit(1);
}, 15000);
