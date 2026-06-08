const fs = require('fs');

const files = fs.readdirSync('.').filter(f => f.startsWith('figma_') && f.endsWith('.json'));

for (const file of files) {
  try {
    const data = JSON.parse(fs.readFileSync(file, 'utf8'));
    console.log(`=== File: ${file} ===`);
    console.log(`Name: ${data.name || 'N/A'}`);
    console.log(`Type: ${data.type || 'N/A'}`);
    if (data.children) {
      console.log(`Children (${data.children.length}):`);
      data.children.slice(0, 5).forEach(c => console.log(`  - [${c.id}] ${c.name} (${c.type})`));
    }
  } catch (e) {
    console.log(`Failed to parse ${file}`);
  }
}
