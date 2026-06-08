const fs = require('fs');

const intro = JSON.parse(fs.readFileSync('deep_figma_intro_screen.json', 'utf8'));
const phone = JSON.parse(fs.readFileSync('deep_figma_phone_screen.json', 'utf8'));
const otp = JSON.parse(fs.readFileSync('deep_figma_otp_screen.json', 'utf8'));

console.log("=== Intro Screen Bounding Boxes ===");
intro.children.forEach(c => {
  console.log(`  - ${c.name} (${c.type}): x=${c.x}, y=${c.y}, w=${c.width}, h=${c.height}`);
});

console.log("\n=== Phone Auth Screen Bounding Boxes ===");
phone.children.forEach(c => {
  console.log(`  - ${c.name} (${c.type}): x=${c.x}, y=${c.y}, w=${c.width}, h=${c.height}`);
});

console.log("\n=== OTP Verification Screen Bounding Boxes ===");
otp.children.forEach(c => {
  console.log(`  - ${c.name} (${c.type}): x=${c.x}, y=${c.y}, w=${c.width}, h=${c.height}`);
});
