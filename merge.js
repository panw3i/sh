const fs = require('fs');
const path = require('path');

const directoryPath = 'path/to/your/directory'; // 替换为您的目录路径
let combinedContent = '';

function addCommentAndCombine(filePath) {
    const fileName = path.basename(filePath);
    let content = fs.readFileSync(filePath, 'utf8');
    content = `// File: ${fileName}\n${content}`;
    combinedContent += content + '\n';
}

function traverseDirectory(dirPath) {
    fs.readdirSync(dirPath).forEach(file => {
        const fullPath = path.join(dirPath, file);
        if (fs.statSync(fullPath).isDirectory()) {
            traverseDirectory(fullPath);
        } else if (path.extname(fullPath) === '.js') {
            addCommentAndCombine(fullPath);
        }
    });
}

traverseDirectory(directoryPath);
fs.writeFileSync('combined.js', combinedContent); // 输出到一个新文件
