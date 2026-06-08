const fs = require('fs');

function checkBackground(fileName) {
  if (!fs.existsSync(fileName)) {
    console.log(`${fileName} does not exist`);
    return;
  }
  const data = JSON.parse(fs.readFileSync(fileName, 'utf8'));
  console.log(`=== File: ${fileName} ===`);
  
  // Find background fills of the top level frame
  if (data.fills) {
    console.log(`Fills: ${JSON.stringify(data.fills)}`);
  }
  if (data.backgroundColor) {
    console.log(`BackgroundColor: ${JSON.stringify(data.backgroundColor)}`);
  }
}

checkBackground('deep_figma_phone_screen.json');
checkBackground('deep_figma_otp_screen.json');
checkBackground('deep_figma_intro_screen.json');
