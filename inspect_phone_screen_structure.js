const fs = require('fs');

if (fs.existsSync('deep_figma_phone_screen.json')) {
  const data = JSON.parse(fs.readFileSync('deep_figma_phone_screen.json', 'utf8'));
  
  function printChildren(node, depth = 0) {
    const indent = '  '.repeat(depth);
    let info = `${indent}- [${node.id}] ${node.name} (${node.type})`;
    if (node.width !== undefined && node.height !== undefined) {
      info += ` size: ${node.width}x${node.height}`;
    }
    console.log(info);
    if (node.children && depth < 3) {
      for (const child of node.children) {
        printChildren(child, depth + 1);
      }
    }
  }

  printChildren(data);
} else {
  console.log("deep_figma_phone_screen.json does not exist");
}
