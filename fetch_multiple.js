const { spawn, execSync } = require('child_process');
const fs = require('fs');

try { execSync('lsof -ti:38450 | xargs kill -9 2>/dev/null'); } catch(e) {}

const server = spawn('node', ['/Users/ahmedteli/Desktop/AI tools/figma-mcp-server/mcp/dist/index.js'], {
  env: { ...process.env, TRANSPORT: 'stdio' },
  stdio: ['pipe', 'pipe', 'pipe']
});

const nodeIds = ["1:4923", "1:4925"];
const results = {};
let fetchIndex = 0;

server.stdout.on('data', (data) => {
  const str = data.toString();
  // Split by newlines in case multiple JSON RPCs arrive at once
  const lines = str.split('\n').filter(l => l.trim().startsWith('{'));
  
  for (const line of lines) {
    if (line.includes('"id":1')) {
      // initialized, wait for plugin connection
      setTimeout(fetchNext, 3000);
    } else if (line.includes('"id":2')) {
      try {
        const parsed = JSON.parse(line);
        if (parsed.result && parsed.result.content && parsed.result.content[0]) {
            results[nodeIds[fetchIndex]] = JSON.parse(parsed.result.content[0].text);
        } else {
            results[nodeIds[fetchIndex]] = parsed;
        }
      } catch(e) {
        results[nodeIds[fetchIndex]] = line;
      }
      fetchIndex++;
      if (fetchIndex < nodeIds.length) {
        fetchNext();
      } else {
        fs.writeFileSync('figma_nodes.json', JSON.stringify(results, null, 2));
        console.log("SUCCESS");
        process.exit(0);
      }
    }
  }
});

function fetchNext() {
  server.stdin.write(JSON.stringify({
    jsonrpc: '2.0', id: 2, method: 'tools/call',
    params: { name: 'get-node-info', arguments: { id: nodeIds[fetchIndex] } }
  }) + '\n');
}

server.stdin.write(JSON.stringify({
  jsonrpc: '2.0', id: 1, method: 'initialize',
  params: { protocolVersion: '2024-11-05', capabilities: {}, clientInfo: { name: 'test', version: '1.0' } }
}) + '\n');
server.stdin.write(JSON.stringify({ jsonrpc: '2.0', method: 'notifications/initialized' }) + '\n');

setTimeout(() => {
  console.log("Error: timeout");
  process.exit(1);
}, 20000);
