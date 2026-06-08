const fs = require('fs');

function search(fileName, query) {
  if (!fs.existsSync(fileName)) return;
  const data = JSON.parse(fs.readFileSync(fileName, 'utf8'));
  console.log(`Searching for "${query}" in ${fileName}...`);
  const found = [];
  
  function traverse(node) {
    if (node.name && node.name.toLowerCase().includes(query.toLowerCase())) {
      found.push({ id: node.id, name: node.name, type: node.type });
    }
    if (node.children) {
      node.children.forEach(traverse);
    }
  }
  
  if (Array.isArray(data)) {
    data.forEach(traverse);
  } else if (data.result && Array.isArray(data.result)) {
    data.result.forEach(traverse);
  } else {
    traverse(data);
  }
  
  console.log(`Found ${found.length} nodes:`);
  found.forEach(n => console.log(`  - [${n.id}] ${n.name} (${n.type})`));
}

search('figma_nodes.json', 'shelf');
search('figma_nodes.json', 'guard');
search('brainly_nodes.json', 'shelf');
search('brainly_nodes.json', 'guard');
