const fs = require('fs');

const data = JSON.parse(fs.readFileSync('node_368_9723_deep.json', 'utf8'));

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

function printDetailedTree(node, depth = 0) {
  const indent = '  '.repeat(depth);
  let info = `${indent}- [${node.id}] ${node.name} (${node.type})`;
  if (node.width !== undefined && node.height !== undefined) {
    info += ` size: ${node.width}x${node.height}`;
  }
  if (node.layoutMode) {
    info += ` layout: ${node.layoutMode}`;
  }
  if (node.paddingLeft !== undefined) {
    info += ` pad: [L:${node.paddingLeft}, R:${node.paddingRight}, T:${node.paddingTop}, B:${node.paddingBottom}]`;
  }
  if (node.itemSpacing !== undefined) {
    info += ` spacing: ${node.itemSpacing}`;
  }
  if (node.primaryAxisAlignItems) {
    info += ` primaryAlign: ${node.primaryAxisAlignItems}`;
  }
  if (node.counterAxisAlignItems) {
    info += ` counterAlign: ${node.counterAxisAlignItems}`;
  }
  if (node.fills && node.fills.length > 0) {
    info += ` fills: ${JSON.stringify(node.fills.map(f => {
      if (f.type === 'SOLID') {
        const c = f.color;
        const toHex = (val) => Math.round(val * 255).toString(16).padStart(2, '0').toUpperCase();
        return `SOLID(#${toHex(c.r)}${toHex(c.g)}${toHex(c.b)})`;
      }
      return f.type;
    }))}`;
  }
  if (node.characters !== undefined) {
    info += ` text: "${node.characters}"`;
  }
  console.log(info);

  if (node.children) {
    for (const child of node.children) {
      printDetailedTree(child, depth + 1);
    }
  }
}

const frame26 = findNode(data, '368:9726');
if (frame26) {
  console.log(`=== FRAME 427320231 (368:9726) ===`);
  printDetailedTree(frame26);
} else {
  console.log("Could not find 368:9726");
}
