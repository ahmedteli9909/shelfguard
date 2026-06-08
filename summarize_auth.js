const fs = require('fs');

const data = JSON.parse(fs.readFileSync('brainly_auth.json', 'utf8'));
const authNode = data["1:3"];

if (!authNode) {
    console.log("Error: 1:3 not found.");
    process.exit(1);
}

if (authNode.error) {
    console.log("Figma API Error:", authNode.error);
    process.exit(1);
}

function traverse(node, depth = 0) {
    const indent = "  ".repeat(depth);
    let info = `${indent}- [${node.type}] ${node.name}`;
    
    // Extract background colors if any
    if (node.fills && node.fills.length > 0) {
        const fill = node.fills[0];
        if (fill.type === "SOLID" && fill.color) {
            info += ` (Color: rgb(${Math.round(fill.color.r*255)},${Math.round(fill.color.g*255)},${Math.round(fill.color.b*255)}))`;
        } else if (fill.type === "IMAGE") {
            info += ` (IMAGE Fill)`;
        } else if (fill.type === "GRADIENT_LINEAR") {
            info += ` (GRADIENT)`;
        }
    }

    if (node.type === "TEXT") {
        info += ` => "${node.characters}"`;
    }

    // layout details
    if (node.layoutMode) {
        info += ` (Layout: ${node.layoutMode}, Padding: ${node.paddingTop}v ${node.paddingLeft}h, Radius: ${node.cornerRadius})`;
    }

    console.log(info);

    if (node.children) {
        for (const child of node.children) {
            traverse(child, depth + 1);
        }
    }
}

console.log(`Analyzing Node 1:3: ${authNode.name}`);
console.log(`Background:`, authNode.backgrounds);
traverse(authNode);
