const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const CONFIG = {
    srcDir: 'RoseUI',
    tempDir: 'temp_build',
    outputFile: 'dist/roseui.lua',
    projectName: 'RoseUI',
    version: '2.5.0',
    author: 'RoseUI Team'
};

function generateHeader() {
    const date = new Date().toLocaleString();
    return `--[[
    ____  ____  _____ ______   __  ______
   / __ \\/ __ \\/ ___// ____/  / / / /  _/
  / /_/ / / / /\\__ \\/ __/    / / / // /  
 / _, _/ /_/ /___/ / /___   / /_/ // /   
/_/ |_|\\____//____/_____/   \\____/___/   
                                         
    ${CONFIG.projectName} v${CONFIG.version}
    Created by ${CONFIG.author}
    Build Date: ${date}
    
    This is a unified distribution file. 
]]\n\n`;
}

function processDirectory(directory) {
    const files = fs.readdirSync(directory);
    files.forEach(file => {
        const filePath = path.join(directory, file);
        const stats = fs.statSync(filePath);
        if (stats.isDirectory()) {
            processDirectory(filePath);
        } else if (file.endsWith('.lua')) {
            let content = fs.readFileSync(filePath, 'utf8');
            // Remove local import = ... or import = ...
            content = content.replace(/local\s+import\s*=\s*\.\.\./g, '-- import definition removed');
            content = content.replace(/^import\s*=\s*\.\.\./gm, '-- import definition removed');

            // Replace import("Path") with require("@RoseUI/Path")
            // The @RoseUI alias is defined in .darklua.json pointing to the root
            content = content.replace(/import\((['"])(.*?)\1\)/g, 'require($1RoseUI/$2$1)');
            fs.writeFileSync(filePath, content);
        }
    });
}

function build() {
    console.log(`Starting robust build for ${CONFIG.projectName}...`);

    try {
        // 1. Cleanup & Create Temp
        if (fs.existsSync(CONFIG.tempDir)) fs.rmSync(CONFIG.tempDir, { recursive: true });
        if (!fs.existsSync('dist')) fs.mkdirSync('dist');

        // 2. Copy source to temp
        console.log('Preparing temp source...');
        execSync(`xcopy /E /I /Y ${CONFIG.srcDir} ${CONFIG.tempDir}`, { stdio: 'ignore' });

        // 3. Transform import -> require
        console.log('Transforming import calls...');
        processDirectory(CONFIG.tempDir);

        // 4. Bundle with darklua
        console.log('Bundling with darklua...');
        // We use darklua process to bundle. 0.18.0 is very powerful.
        execSync(`darklua process ${CONFIG.tempDir}/init.lua ${CONFIG.outputFile} --config .darklua.json`, { stdio: 'inherit' });

        // 5. Add header
        console.log('Adding header...');
        const code = fs.readFileSync(CONFIG.outputFile, 'utf8');
        const finalCode = generateHeader() + code;
        fs.writeFileSync(CONFIG.outputFile, finalCode);

        // 6. Cleanup
        fs.rmSync(CONFIG.tempDir, { recursive: true });

        console.log(`Build successful! File generated at: ${CONFIG.outputFile}`);
    } catch (error) {
        console.error('Build failed:', error.message);
        if (fs.existsSync(CONFIG.tempDir)) fs.rmSync(CONFIG.tempDir, { recursive: true });
        process.exit(1);
    }
}

build();
