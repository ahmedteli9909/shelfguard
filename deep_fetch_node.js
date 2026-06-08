const { spawn, execSync } = require('child_process');
const fs = require('fs');

// Kill anything on port 38450 first
try {
  execSync('lsof -ti:38450 | xargs kill -9 2>/dev/null');
} catch (e) {}

const startNodeId = process.argv[2];
const outputFileName = process.argv[3];

if (!startNodeId || !outputFileName) {
  console.error("Usage: node deep_fetch_node.js <startNodeId> <outputFileName>");
  process.exit(1);
}

console.log(`Starting deep fetch for node ${startNodeId} to ${outputFileName}`);

const server = spawn('node', ['/Users/ahmedteli/Desktop/AI tools/figma-mcp-server/mcp/dist/index.js'], {
  env: { ...process.env, TRANSPORT: 'stdio' },
  stdio: ['pipe', 'pipe', 'pipe']
});

server.stderr.on('data', (data) => {
  const msg = data.toString().trim();
  if (msg) console.warn('[Server Stderr]', msg);
});

let buffer = '';
let jsonRpcId = 2;
const pendingRequests = new Map(); // id -> callback
let isFigmaConnected = false;

server.stdout.on('data', (chunk) => {
  buffer += chunk.toString();
  let lineEndIndex;
  
  while ((lineEndIndex = buffer.indexOf('\n')) !== -1) {
    const line = buffer.substring(0, lineEndIndex).trim();
    buffer = buffer.substring(lineEndIndex + 1);
    
    if (line.startsWith('{')) {
      handleJsonMessage(line);
    }
  }
});

function handleJsonMessage(line) {
  try {
    const parsed = JSON.parse(line);
    
    if (parsed.id === 1) {
      console.log("Initialized. Waiting 3.5s for Figma plugin connection...");
      setTimeout(() => {
        isFigmaConnected = true;
        startFetching();
      }, 3500);
    } else if (parsed.id && pendingRequests.has(parsed.id)) {
      const callback = pendingRequests.get(parsed.id);
      pendingRequests.delete(parsed.id);
      
      let finalResult = parsed;
      if (parsed.result && parsed.result.content && parsed.result.content[0]) {
        try {
          finalResult = JSON.parse(parsed.result.content[0].text);
        } catch (e) {
          finalResult = parsed.result.content[0].text;
        }
      }
      callback(finalResult);
    }
  } catch (e) {
    console.error("Error parsing message line:", e);
  }
}

function callTool(name, args) {
  return new Promise((resolve) => {
    const id = jsonRpcId++;
    pendingRequests.set(id, resolve);
    server.stdin.write(JSON.stringify({
      jsonrpc: '2.0',
      id: id,
      method: 'tools/call',
      params: {
        name: name,
        arguments: args
      }
    }) + '\n');
  });
}

async function fetchNodeInfo(id) {
  // Wait a small bit to not overload Socket.IO
  await new Promise(r => setTimeout(r, 100));
  console.log(`Fetching node ${id}...`);
  return await callTool('get-node-info', { id });
}

async function fetchTree(nodeId) {
  const node = await fetchNodeInfo(nodeId);
  if (!node || node.error) {
    console.warn(`Could not fetch node ${nodeId}:`, node ? node.error : 'null');
    return { id: nodeId, error: true };
  }
  
  if (node.children && node.children.length > 0) {
    const fetchedChildren = [];
    for (const child of node.children) {
      if (child.id) {
        const fullChild = await fetchTree(child.id);
        fetchedChildren.push(fullChild);
      }
    }
    node.children = fetchedChildren;
  }
  
  return node;
}

async function startFetching() {
  try {
    const tree = await fetchTree(startNodeId);
    fs.writeFileSync(outputFileName, JSON.stringify(tree, null, 2));
    console.log(`\nSUCCESS: Tree saved to ${outputFileName}`);
    process.exit(0);
  } catch (e) {
    console.error("Error during tree fetch:", e);
    process.exit(1);
  }
}

// Perform handshake
server.stdin.write(JSON.stringify({
  jsonrpc: '2.0',
  id: 1,
  method: 'initialize',
  params: {
    protocolVersion: '2024-11-05',
    capabilities: {},
    clientInfo: { name: 'query-client', version: '1.0' }
  }
}) + '\n');
server.stdin.write(JSON.stringify({ jsonrpc: '2.0', method: 'notifications/initialized' }) + '\n');

// Timeout fallback
setTimeout(() => {
  console.error("Error: Global timeout.");
  process.exit(1);
}, 600000); // 10 minutes timeout for deep tree fetching
