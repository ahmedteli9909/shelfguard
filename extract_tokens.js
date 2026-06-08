const fs = require('fs');
const data = JSON.parse(fs.readFileSync('figma_nodes.json', 'utf8'));

function extractComponentInfo(node) {
    if (!node) return null;
    return {
        name: node.name,
        type: node.type,
        width: node.width,
        height: node.height,
        cornerRadius: node.cornerRadius || 0,
        padding: {
            top: node.paddingTop || 0,
            bottom: node.paddingBottom || 0,
            left: node.paddingLeft || 0,
            right: node.paddingRight || 0,
        },
        itemSpacing: node.itemSpacing || 0,
        fills: node.fills ? node.fills.map(f => f.color) : [],
        effects: node.effects || []
    };
}

const summary = {
    buttons: [],
    inputs: []
};

// Check Buttons (1:4922)
if (data["1:4922"] && data["1:4922"].children) {
    for (const child of data["1:4922"].children) {
        summary.buttons.push(extractComponentInfo(child));
    }
}

// Check Inputs (1:4021)
if (data["1:4021"] && data["1:4021"].children) {
    for (const child of data["1:4021"].children) {
        summary.inputs.push(extractComponentInfo(child));
    }
}

fs.writeFileSync('tokens_summary.json', JSON.stringify(summary, null, 2));
console.log("Tokens extracted to tokens_summary.json");
