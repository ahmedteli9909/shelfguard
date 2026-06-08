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

const titleNode = findNode(data, '368:9728');
if (titleNode) {
  console.log(`=== Title Node (368:9728) Styling ===`);
  console.log(JSON.stringify(titleNode, null, 2));
} else {
  console.log("Could not find title node");
}
