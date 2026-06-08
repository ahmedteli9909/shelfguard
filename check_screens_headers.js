const fs = require('fs');

function findHeaders(node, path = '') {
  const currentPath = path ? `${path} -> ${node.name} (${node.id})` : `${node.name} (${node.id})`;
  
  if (node.name && (node.name.toLowerCase().includes('header') || node.name.toLowerCase().includes('status bar') || node.name.toLowerCase().includes('nav') || node.name.toLowerCase().includes('appbar') || node.name.toLowerCase().includes('app bar') || node.id === '368:9723')) {
    console.log(`Found header match: ${currentPath} size: ${node.width}x${node.height}`);
    if (node.fills) {
      console.log(`  Fills: ${JSON.stringify(node.fills.map(f => f.type))}`);
      if (node.fills[0] && node.fills[0].gradientStops) {
        console.log(`  Stops: ${JSON.stringify(node.fills[0].gradientStops)}`);
      }
    }
  }
  
  if (node.children) {
    for (const child of node.children) {
      findHeaders(child, currentPath);
    }
  }
}

if (fs.existsSync('deep_figma_phone_screen.json')) {
  console.log("=== Phone Screen Headers ===");
  findHeaders(JSON.parse(fs.readFileSync('deep_figma_phone_screen.json', 'utf8')));
}

if (fs.existsSync('deep_figma_otp_screen.json')) {
  console.log("\n=== OTP Screen Headers ===");
  findHeaders(JSON.parse(fs.readFileSync('deep_figma_otp_screen.json', 'utf8')));
}
