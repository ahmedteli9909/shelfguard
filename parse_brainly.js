const fs = require('fs');
const data = JSON.parse(fs.readFileSync('brainly_nodes.json', 'utf8'));

function printTree(node, indent = '') {
  if (!node) return;
  const props = [];
  if (node.fills && node.fills.length > 0) {
    const f = node.fills[0];
    if (f.type === 'SOLID' && f.color) {
      props.push(`fill: rgba(${Math.round(f.color.r*255)},${Math.round(f.color.g*255)},${Math.round(f.color.b*255)},${f.opacity||1})`);
    } else if (f.type === 'IMAGE') {
      props.push('IMAGE');
    }
  }
  if (node.absoluteBoundingBox) {
    props.push(`w:${node.absoluteBoundingBox.width} h:${node.absoluteBoundingBox.height}`);
  }
  if (node.cornerRadius) props.push(`radius:${node.cornerRadius}`);
  if (node.type === 'TEXT' && node.characters) props.push(`text:"${node.characters.replace(/\\n/g, ' ')}"`);
  
  console.log(`${indent}- ${node.name} [${node.type}] (${props.join(', ')})`);
  
  if (node.children) {
    node.children.forEach(c => printTree(c, indent + '  '));
  }
}

for (const [id, node] of Object.entries(data)) {
  if (!node || node.error) continue;
  console.log(`\n=== Tree for ${id} ===`);
  printTree(node);
}
