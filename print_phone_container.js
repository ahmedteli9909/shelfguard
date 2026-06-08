const fs = require('fs');

if (fs.existsSync('deep_figma_phone_screen.json')) {
  const data = JSON.parse(fs.readFileSync('deep_figma_phone_screen.json', 'utf8'));
  
  function findNode(node, id) {
    if (node.id === id) return node;
    if (node.children) {
      for (const child of node.children) {
        const found = findNode(child, id);
        if (found) return found;
      }
    }
    return null;
  }

  const container = findNode(data, '240:4929');
  if (container) {
    printNodeDetails(container);
  } else {
    console.log("Could not find Frame 427320227");
  }

  function printNodeDetails(node, depth = 0) {
    const indent = '  '.repeat(depth);
    let info = `${indent}- [${node.id}] ${node.name} (${node.type}) size: ${node.width}x${node.height}`;
    if (node.characters !== undefined) {
      info += ` text: "${node.characters.replace(/\n/g, '\\n')}"`;
    }
    if (node.fills && node.fills.length > 0) {
      info += ` fills: ${JSON.stringify(node.fills.map(f => f.type))}`;
    }
    console.log(info);
    if (node.children) {
      for (const child of node.children) {
        printNodeDetails(child, depth + 1);
      }
    }
  }
} else {
  console.log("deep_figma_phone_screen.json not found");
}
