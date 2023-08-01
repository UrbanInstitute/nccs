// GLOBAL javascript
// Any global javascript that needs to run on each page should be written here


// DYNAMIC MODULES/COMPONENTS
// This pattern allows lazy loading of component-specific javascript without
// a build system like Vite or Webpack. It relies on ESM modules.

// Each module is identified with the data attribute:
// data-module="name-of-module"
// And then loaded with a dynamic import statement

// select every "data-module" and convert the NodeList to an Array

const dataModules = [...document.querySelectorAll('[data-module]')]

// store all instances
const storage = {}

dataModules.forEach((element) => {
  element.dataset.module.split(' ').forEach(function (moduleName) {
    // dynamic imports help with code splitting
    import(
      // assumes modules are in directory `js/modules/<module-name>.js`
      // and your entry point lives in `js/<entry-point-file>.js
      `./modules/${moduleName}.js`
    ).then((Module) => {
      // create a new instance of our module passing the element and store it
      storage[moduleName] = new Module.default(element)
    })
  })
})
