const shell = require('shelljs');

const ultimoCommit = shell.exec('git log -n 1');
const keyA = 'Merge branch ';
const keyB = `into 'master'`;
const commit = ultimoCommit.stdout.replace(/(\r\n|\n|\r)/gm, '<->');
const commitSplit = commit.split('<->');
let [filter = ''] = commitSplit
    .filter((item) => item.includes(keyA) && item.includes(keyB))
    .map((item) => item.trim());

switch (true) {
    case filter.includes('major-'):
        console.log('version X.0.0');
        shell.exec('npm run release -- --release-as major');
        break;
    case filter.includes('feature-'):
        console.log('version 0.X.0');
        shell.exec('npm run release -- --release-as minor');
        break;
    case filter.includes('fix-'):
    case filter.includes('hotfix-'):
    case filter.includes('patch-'):
    case filter.includes('minor-'):
        console.log('version 0.0.X');
        shell.exec('npm run release -- --release-as patch');
        break;
    default:
        console.log(`No se crea la versión, porque no proviene de un branch con nomenclatura:
        [major, minor, feature, hotfix, fix, patch]`);
        break;
}
