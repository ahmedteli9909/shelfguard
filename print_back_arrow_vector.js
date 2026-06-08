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

const arrowNode = findNode(data, 'I368:9727;11:293');
if (arrowNode) {
  console.log(`=== Arrow Node (I368:9727;11:293) ===`);
  console.log(JSON.stringify(arrowNode, null, 2));
} else {
  console.log("Could not find arrow node by specific ID, finding any arrow_left_line children...");
  const navBar = findNode(data, '368:9725');
  if (navBar) {
    function findArrow(node) {
      if (node.name === 'arrow_left_line') {
        console.log(`Found:`, JSON.stringify(node, null, 2));
      }
      if (node.children) {
        node.children.forEach(findArrow);
      }
    }
    findArrow(navBar);
  }
}
