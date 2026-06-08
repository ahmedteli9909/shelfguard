const { spawn, execSync } = require('child_process');
const fs = require('fs');

try { execSync('lsof -ti:38450 | xargs kill -9 2>/dev/null'); } catch(e) {}

const server = spawn('node', ['/Users/ahmedteli/Desktop/AI tools/figma-mcp-server/mcp/dist/index.js'], {
  env: { ...process.env, TRANSPORT: 'stdio' },
  stdio: ['pipe', 'pipe', 'pipe']
});

server.stdout.on('data', (data) => {
  const str = data.toString();
  const lines = str.split('\n').filter(l => l.trim().startsWith('{'));
  for (const line of lines) {
    if (line.includes('"id":1')) {
      setTimeout(() => {
        server.stdin.write(JSON.stringify({
          jsonrpc: '2.0', id: 2, method: 'tools/call',
          params: { name: 'get-node-info', arguments: { id: '368:9723' } }
        }) + '\n');
      }, 1000);
    } else if (line.includes('"id":2')) {
      fs.writeFileSync('node_368_9723.json', line);
      console.log("SUCCESS");
      process.exit(0);
    }
  }
});

server.stdin.write(JSON.stringify({
  jsonrpc: '2.0', id: 1, method: 'initialize',
  params: { protocolVersion: '2024-11-05', capabilities: {}, clientInfo: { name: 'test', version: '1.0' } }
}) + '\n');
server.stdin.write(JSON.stringify({ jsonrpc: '2.0', method: 'notifications/initialized' }) + '\n');

setTimeout(() => {
  console.log("Error: Timeout");
  process.exit(1);
}, 25000);
