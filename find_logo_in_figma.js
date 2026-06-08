const fs = require('fs');

function searchJson(fileName, query) {
  if (!fs.existsSync(fileName)) {
    console.log(`${fileName} does not exist`);
    return;
  }
  let data;
  try {
    data = JSON.parse(fs.readFileSync(fileName, 'utf8'));
  } catch (e) {
    console.log(`Failed to parse ${fileName}`);
    return;
  }
  console.log(`=== Searching in ${fileName} ===`);
  const foundNodes = [];
  
  function traverse(node) {
    if (node.name && node.name.toLowerCase().includes(query.toLowerCase())) {
      foundNodes.push({ id: node.id, name: node.name, type: node.type, width: node.width, height: node.height });
    }
    if (node.children) {
      for (const child of node.children) {
        traverse(child);
      }
    }
  }

  // Handle nested content structure if present
  if (Array.isArray(data)) {
    data.forEach(traverse);
  } else if (data.result && Array.isArray(data.result)) {
    data.result.forEach(traverse);
  } else if (data.result && data.result.content) {
    try {
      const parsed = JSON.parse(data.result.content[0].text);
      traverse(parsed);
    } catch(e) {
      traverse(data);
    }
  } else {
    traverse(data);
  }

  console.log(`Found ${foundNodes.length} nodes matching "${query}":`);
  foundNodes.slice(0, 20).forEach(n => console.log(`  - [${n.id}] ${n.name} (${n.type}) ${n.width}x${n.height}`));
}

searchJson('deep_figma_phone_screen.json', 'logo');
searchJson('deep_figma_otp_screen.json', 'logo');
searchJson('deep_figma_intro_screen.json', 'logo');
searchJson('deep_figma_phone_screen.json', 'brand');
searchJson('deep_figma_otp_screen.json', 'brand');
searchJson('deep_figma_intro_screen.json', 'brand');
