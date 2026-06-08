const fs = require('fs');

if (fs.existsSync('deep_figma_otp_screen.json')) {
  const data = JSON.parse(fs.readFileSync('deep_figma_otp_screen.json', 'utf8'));
  
  function findOtpNodes(node, path = '') {
    const currentPath = path ? `${path} -> ${node.name} (${node.id})` : `${node.name} (${node.id})`;
    
    // Check if the node is an input box or rectangle that might be an OTP box
    if (node.name && (node.name.toLowerCase().includes('otp') || node.name.toLowerCase().includes('digit') || node.name.toLowerCase().includes('code') || node.name.toLowerCase().includes('box') || node.name.toLowerCase().includes('field') || node.name.toLowerCase().includes('input'))) {
      console.log(`Found matching node: ${currentPath}`);
      console.log(`  Size: ${node.width}x${node.height}`);
      if (node.fills) console.log(`  Fills: ${JSON.stringify(node.fills.map(f => f.type))}`);
      if (node.strokes) console.log(`  Strokes: ${JSON.stringify(node.strokes)}`);
      if (node.cornerRadius !== undefined) console.log(`  CornerRadius: ${node.cornerRadius}`);
      if (node.itemSpacing !== undefined) console.log(`  ItemSpacing: ${node.itemSpacing}`);
      if (node.paddingLeft !== undefined) console.log(`  Padding: [L:${node.paddingLeft}, R:${node.paddingRight}, T:${node.paddingTop}, B:${node.paddingBottom}]`);
    }
    
    if (node.children) {
      for (const child of node.children) {
        findOtpNodes(child, currentPath);
      }
    }
  }

  console.log("=== Searching for OTP Node properties in deep_figma_otp_screen.json ===");
  findOtpNodes(data);
} else {
  console.log("deep_figma_otp_screen.json does not exist");
}
