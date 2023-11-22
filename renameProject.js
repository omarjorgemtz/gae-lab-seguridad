const replace = require('replace-in-file');
const readline = require('readline');
const promt = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

const constants = {
    current: '"version":.*',
    version: '"version": "0.0.0",',
    actualName: 'angular-template',
    finish: 'Se completo la tarea:',
    reset: 'Se regresa la versión a: "0.0.0"',
    hint: 'No se cumple el pattern (/^[a-z]+$/)',
    question: 'Ingresa un nuevo nombre de proyecto: ',
    fail: 'No se puede renombrar el proyecto con los valores que ingreso.',
    packages: ['./package.json', './package-lock.json'],
    someFiles: [
        './angular.json',
        './app.yaml',
        './karma.conf.js',
        './sonar-project.properties'
    ]
};

promt.question(`\n${constants.question}`, (name) => {
    const pattern = /^[a-z-]+$/;
    const project = pattern.test(name.trim()) ? name.trim() : null;
    if (project && !project.endsWith('-')) {
        const options = {
            from: new RegExp(constants.actualName, 'g'),
            to: project,
            files: [...constants.packages, ...constants.someFiles]
        };
        replace(options)
            .then((res) => {
                replace({
                    from: new RegExp(constants.current),
                    to: constants.version,
                    files: [...constants.packages]
                })
                    .then(() => console.log(`\n${constants.reset}\n`))
                    .catch((e) => console.error(e));
                console.log(`\n${constants.finish}`, res);
            })
            .catch((e) => console.error(e));
    } else {
        console.log(
            `\n${constants.fail}\n
            ${constants.hint}\n`
        );
    }
    promt.close();
});
